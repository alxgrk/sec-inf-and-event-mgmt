# sec-inf-and-event-mgmt
This is a university project demonstrating the usage of the [Elastic Stack](https://www.elastic.co/products/elastic-stack) to process and visualize [System calls](https://en.wikipedia.org/wiki/System_call) produced by [Sysdig](https://github.com/draios/sysdig).

## Start
To run the whole system at once, simply call this script with the container name to track, e.g.
```bash
 $ ./run.sh ${CONTAINER_NAME}
```
If you don't want sysdig to track syscalls, simply add
```bash
 $ ./run.sh --no-track
```
This will fix potential problems (see below), bring up all containers & watch their syscalls with sysdig.

If you instead want to only run sysdig to track syscalls, simply call
```bash
 $ ./run.sh --only-track ${CONTAINER_NAME}
```

## Test scenario
#### starting
To run the modified [DVWA](https://github.com/ethicalhack3r/DVWA) with some clients (located in [./dvwa-app](dvwa-app/README.md)) and track the victim, call  
```bash
 $ ./run.sh dvwa-app_victim_1
```

#### running attacker
When the Elastic Stack and the DVWA is up and running, you see the syscalls visualized in Kibana. At some point you might want to start the attacker, which performs SQL injection attacks and watch the dashboard change. Do so by running:
```bash
 $ docker-compose -f ./dvwa-app/docker-compose.yml up -d --scale attacker=1
```

## Project structure
* _run.sh_ - execute to start Elastic Stack and track the specified container's syscalls
* _dashboard\_and\_visualizations.ndjson_ - a new-line-delimited JSON file configuring all Kibana objects
* _elasticsearch-default-filebeat-mapping.json_ - the mapping to be applied to the ElasticSearch index
* _sysdig-utils_ - some utility scripts to get lists of e.g. all Sysdig supported syscalls or all sycall parameters
* _DummyApp_ - an containerized Nginx serving as a simple test container
* _dvwa-app_ - the modified and containerized [DVWA](https://github.com/ethicalhack3r/DVWA)
* _Filebeat_ - a Filebeat container watching the [log-file](logs/sysdig/syscalls.log) and sending beats to Logstash
* _logstash-conf_ - the Logstash configuration for defining a single pipeline

## Clean up
For stopping all Docker containers run:
```bash
 $ docker-compose -f dvwa-app/docker-compose.yml down -v && docker-compose down -v
```

## References
The setup of the Elastic Stack is heavily based on https://elk-docker.readthedocs.io/
