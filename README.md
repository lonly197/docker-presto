# Presto docker image based on alpine

```
# network 
docker network create vnet

# load docker env as needed
eval $(docker-machine env default)

# build docker image
docker build --rm --build-arg BUILD_DATE=$(date +'%m/%d/%Y') --build-arg VERSION=0.187 --build-arg HIVE_METASTORS_URI=thrift://dmp2:9083 -t lonly/presto:0.187 https://github.com/lonly197/docker-presto.git

# run container for presto-server-coordinator
docker run -p 8200:8080 -v /data00/presto/data:/presto --name presto -d lonly/presto:0.187 coordinator

# run container for presto-server-worker
docker run -p 8200:8080 -v /data00/presto/data:/presto --name presto -d lonly/presto:0.187 worker

$ docker ps


# CLUSTER OVERVIEW UI
open http://$(docker-machine ip default):8080

# cleanup
docker stop [container-id]
docker rm -fv [container-id]
```

