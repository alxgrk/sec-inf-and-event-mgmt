# pratikum-sec-inf-and-event-mgmt
This is a universitary project playing aroung with the ELK stack and Sysdig.

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