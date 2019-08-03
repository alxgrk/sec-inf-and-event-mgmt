docker-compose down -v
cd dvwa-app
docker-compose down -v


docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

docker volume rm $(docker volume ls -f dangling=true -q) -f
docker network prune -f