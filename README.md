# pratikum-sec-inf-and-event-mgmt
This is a universitary project playing aroung with the ELK stack and Sysdig.

## Start
To run the whole system at once, simply call this script with the container name to track, e.g.
```bash
 $ ./run.sh dvwa-sql-app_victim_1
```
If you don't want sysdig to track syscalls, simply add
```bash
 $ ./run.sh --no-track
```
This will fix potential problems (see below), bring up all containers & watch their syscalls with sysdig.

If you instead want to only run sysdig to track syscalls, simply call
```bash
 $ ./run.sh --only-track dvwa-sql-app_victim_1
```

## References
The setup is heavily based on https://elk-docker.readthedocs.io/

## Troubleshooting

### Segmentation fault

For some reason it is sometimes happening, that sysdig is exiting with an error mentioning a Segmentation Fault.
Couldn't figure out, why this happens, but stopping all containers helps:
```
 $ docker-compose down
 $ docker-compose -f dvwa-app/docker-compose.yml down
```
