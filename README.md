
## Dockerize your development environment for PHP & Laravel Framework
Here is one way to structure your [docker](https://www.docker.com/) application if you want to develop/build/test/deploy your PHP WEB application using [Laravel Framework](https://laravel.com/).
Using docker will greatly simplify your [DevOps](https://en.wikipedia.org/wiki/DevOps) operations and focus solerly on development activities (not installing, configuring, pachting, version conflict resolution dependencies depending on your OS system ...). The beauty of docker is that I can deploy & scale my web application in production with a minimum effort configuration thanks to [Kubernetes](https://en.wikipedia.org/wiki/Kubernetes) using [AWS] (https://en.wikipedia.org/wiki/Amazon_Web_Services) or any others cloud platform.


### How it works
* [Why Docker ?](https://www.docker.com/why-docker)
* [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

### Base Image contains
* php:7.3.0-apache-stretch
* mysql:8.0.13
* redis:5.0-alpine
* Mount volume : php code on your computer/mlaptop & MySQL databases are outside the containers
* Official Apache httpd image modified to have SSL turned on. Copy cert and key into image or mount them as volumes.

### How to use this image
* [Install Docker on computer] (https://www.docker.com/products/docker-desktop)
*
Provide excution rights to bash (helper) scripts
```
chmod u+x *.sh
./dcompose_build.sh
./dcompose_up.sh
```
### Docker command summary 
```
docker-compose build
docker-compose up -d
docker-compose down
docker ps
```
Sample output
```
CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS              PORTS                                         NAMES
e15c2bb0627f        mokchend:laravel-app-docker   "docker-php-entrypoi…"   19 minutes ago      Up 17 minutes       0.0.0.0:8080->80/tcp, 0.0.0.0:4443->443/tcp   laravelApp-docker
3fc1c72b4b10        redis:5.0-alpine              "docker-entrypoint.s…"   About an hour ago   Up 17 minutes       0.0.0.0:16379->6379/tcp                       laravelApp-redis-docker
d2dc00499385        mysql:8.0.13                  "docker-entrypoint.s…"   About an hour ago   Up 17 minutes       33060/tcp, 0.0.0.0:13306->3306/tcp            laravelApp-mysql-docker

```

### To connect to the apache/php container
```
docker exec -it laravel-app bash
docker exec -it laravel-app bash
cat /etc/apache2/sites-available/000-default.conf
```

### To connect to your mysql container
```
The pwd is password as defined in docker-compose.yml file
docker exec -it docker_app_mysql mysql --user=root --password
docker exec -it docker_app_mysql bash
```

### To connect to MySQL from your laptop/computer
```
mysql -u root -P 13306 -h 127.0.0.1 -p
mysql -u app -P 13306 -h 127.0.0.1 -p 
```

### To list & inspect volume
```
docker volume ls           
docker inspect mystack_dbdata
```

### To delete unused volumes
```
docker volume prune
```

### List all containers (only IDs)
```
docker ps -aq
```
### Stop all running containers
```
docker stop $(docker ps -aq)
```
### Remove all containers
```
docker rm $(docker ps -aq)
```
### Remove all images
```
docker rmi $(docker images -q)
```

### To Stop
```
docker stop laravel-docker_app_1 docker_app_mysql laravel-docker_redis_1 
docker kill laravel-docker_app_1 docker_app_mysql laravel-docker_redis_1   
```


### Cheat Sheet
Creating a high secure SSL CSR with openssl
This cert might be incompatible with Windows 2000, XP and older IE Versions
```
openssl req -nodes -new -newkey rsa:4096 -out csr.pem -sha256
```

Creating a self-signed ssl cert
Please note, that the Common Name (CN) is important and should be the FQDN to the secured server:
```
openssl req -x509 -newkey rsa:4086 \
-keyout key.pem -out cert.pem \
-days 3650 -nodes -sha256
```