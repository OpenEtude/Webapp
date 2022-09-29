#!/bin/bash
docker rm -f postgres
docker rm -f pgweb
docker run --name postgres -p 5432:5432 -v d:/data/etude-db:/data  -e PGDATA=/home/etude/postgres -e POSTGRES_PASSWORD=etude -e POSTGRES_USER=etude -d postgres:alpine
sleep 10
docker run --name pgweb -p 8081:8081 --link postgres:db -d sosedoff/pgweb
docker logs -tf postgres | sed 's/^/postgres: /' &
docker logs -tf pgweb | sed 's/^/pgweb: /'