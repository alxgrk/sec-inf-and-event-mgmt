FROM docker.elastic.co/beats/filebeat:7.2.0

### configure Filebeat

# config file
ADD --chown=root:filebeat filebeat.yml /usr/share/filebeat/filebeat.yml
ADD --chown=root:filebeat sysdig_event_processor.js /usr/share/filebeat/sysdig_event_processor.js

