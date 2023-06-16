docker images | grep dolibarr-17 || wget https://jukebox.linuxconsole.org/docker/dolibarr-17.img
docker images | grep dolibarr-17 || docker load < dolibarr-17.img
docker images | grep dolibarr-17 || exit 1
docker ps |grep dolitest && docker stop dolitest && docker rm dolitest
docker run -d --name dolitest dolibarr-17
sleep 2
docker exec dolitest php --version
