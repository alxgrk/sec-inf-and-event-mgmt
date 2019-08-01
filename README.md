# pratikum-sec-inf-and-event-mgmt
This is a universitary project playing aroung with the ELK stack and Sysdig.

## Start
To run the whole system at once, simply call this script with the container name to track, e.g.
```bash
 $ ./run.sh dvwa-sql-app_victim_1
```
If you don't want sysdig to track syscalls, simply add
```bash
 $ ./run.sh --notrack
```
This will fix potential problems (see below), bring up all containers & watch their syscalls with sysdig.

## References
The setup is heavily based on https://elk-docker.readthedocs.io/

