FROM docker.elastic.co/beats/filebeat:7.2.0

### configure Filebeat

# config file
ADD --chown=root:filebeat filebeat.yml /usr/share/filebeat/filebeat.yml

# CA cert
RUN mkdir -p /etc/pki/tls/certs
ADD logstash-beats.crt /etc/pki/tls/certs/logstash-beats.crt

# create template based on filebeat version (assumption: it is the same version as elasticsearch version)
# RUN filebeat export template --es.version 7.2.0 > /etc/filebeat/filebeat.template.json

