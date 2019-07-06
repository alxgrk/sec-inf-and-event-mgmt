# pratikum-sec-inf-and-event-mgmt
This is a universitary project playing aroung with the ELK stack and Sysdig.

## Start
To run the whole system at once, simply call
```bash
 $ ./run.sh
```
If you want sysdig to track syscalls, simply add
```bash
 $ ./run.sh --track
```
This will fix potential problems (see below), bring up all containers & watch their syscalls with sysdig.

## References
The setup is heavily based on https://elk-docker.readthedocs.io/

## Frequently encountered issues
_mostly taken from the above reference_

### Max Map Count
Problem:
```
max virtual memory areas vm.max_map_count [65530] likely too low, increase to at least [262144]
```
Solution: 
```
sudo sysctl -w vm.max_map_count=262144
```
## TODO
 - refresh index mapping after a the first document was sent (warning can be found in kibana)
