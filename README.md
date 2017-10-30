# Presto docker image based on alpine

```
# network 
docker network create vnet

# load docker env as needed
eval $(docker-machine env default)

# build docker image
docker build --rm --build-arg BUILD_DATE=$(date +'%m/%d/%Y') --build-arg VERSION=0.178 --build-arg HIVE_METASTORS_URI=thrift://dmp2:9083 -t lonly197/presto:v0.178 https://github.com/lonly197/docker-presto.git

# run containers
docker run -p 8285:8080 -v /data00/presto/data:/presto --name presto -d lonly197/presto:lastest

$ docker ps


# CLUSTER OVERVIEW UI
open http://$(docker-machine ip default):8080

# cleanup
docker stop [container-id]
docker rm -fv [container-id]
```

