docker images | grep dolibarr-18 || wget https://jukebox.linuxconsole.org/docker/dolibarr-18.img
docker images | grep dolibarr-18 || docker load < dolibarr-18.img
docker images | grep dolibarr-18 || exit 1
docker ps |grep dolitest && docker stop dolitest && docker rm dolitest
docker run -d --name dolitest dolibarr-18
sleep 2
docker exec dolitest php --version
