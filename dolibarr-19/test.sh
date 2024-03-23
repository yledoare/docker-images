docker images | grep dolibarr-19 || wget https://jukebox.linuxconsole.org/docker/dolibarr-19.img
docker images | grep dolibarr-19 || docker load < dolibarr-19.img
docker images | grep dolibarr-19 || exit 1
docker ps |grep dolitest && docker stop dolitest && docker rm dolitest
docker run -d --name dolitest dolibarr-19
sleep 2
docker exec dolitest php --version
