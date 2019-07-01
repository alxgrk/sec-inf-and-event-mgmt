FROM nginx

# remove log symlinks
RUN rm /var/log/nginx/access.log /var/log/nginx/error.log

### add dummy HTML file

COPY html /usr/share/nginx/html


###############################################################################
#                                    START
###############################################################################

ADD ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
CMD [ "/usr/local/bin/start.sh" ]
