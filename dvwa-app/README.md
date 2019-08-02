# dvwa-sql-app
Drei Akteure, die mit der [DVWA](https://github.com/vulnerables/docker-vulnerable-dvwa) interagieren:
1. victim - Host der DVWA
2. client - normaler Besucher der Website, der randomisiert Links klickt
3. attacker - Angriff per SQL-Injection, um Passwörter zu erraten

## Starten

### mit Docker-Compose

```
 $ docker-compose up -d --build --scale attacker=0
```
... um den attacker später hinzuzufügen.

### Manuell

1. Alle 3 Images jeweils mit `docker build . -t dvwa/<victim|client|attacker>` bauen
2. victim starten
3. http://172.17.0.2/login.php öffnen und mit admin/password einloggen
4. Datenbank neu createn
5. Client starten mit `docker run --rm -it dvwa/client:latest`
6. in Terminal `./home/start-client.sh` ausführen.
7. Attacker starten mit `docker run --rm -it dvwa/attacker:latest`
8. in Terminal `./home/start-attacker.sh` ausführen.

Dabei den Victim-Container von Sysdig überwachen lassen.
