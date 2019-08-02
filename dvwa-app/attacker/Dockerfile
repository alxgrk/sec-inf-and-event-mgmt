FROM debian:9.2


RUN apt-get update && apt-get install -y wget python3 python3-pip wget unzip xvfb udev python2.7
# chrome in debian
RUN echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list
RUN wget https://dl-ssl.google.com/linux/linux_signing_key.pub
RUN apt-key add linux_signing_key.pub

# install chrome
RUN apt-get update && apt-get install -y google-chrome-stable git

# python related
RUN pip3 install --upgrade pip setuptools
RUN pip3 install selenium
RUN pip3 install 'urllib3==1.23' --force-reinstall
RUN pip3 install pyvirtualdisplay
RUN pip3 install requests
RUN pip3 install numpy

RUN wget https://chromedriver.storage.googleapis.com/2.42/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d /usr/bin
RUN chmod +x /usr/bin/chromedriver

RUN wget https://github.com/sqlmapproject/sqlmap/zipball/master
RUN unzip master -d /home/
RUN mv /home/sqlmapproject* /home/sqlmapproject

COPY attacker.py /home/attacker.py
COPY start-attacker.sh /home/start-attacker.sh

RUN chmod +x /home/start-attacker.sh
ENTRYPOINT [ "./home/start-attacker.sh" ]
