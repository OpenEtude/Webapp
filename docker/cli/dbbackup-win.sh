#!/usr/bin/env bash
# DOCKER_HOST=tcp://192.168.99.100:2376
# DOCKER_MACHINE_NAME=default
# DOCKER_TLS_VERIFY=1
# DOCKER_TOOLBOX_INSTALL_PATH=/D/Docker\ Toolbox
# DOCKER_CERT_PATH=~/.docker/machine/machines/default
echo "*********************************************"
mkdir -vp D:/root/arkilogbackup/current/
rm -vRf D:/root/arkilogbackup/current/*
cd D:/root/arkilogbackup/current/
# winpty docker exec -it postgres pg_dump -F p -U etude etude > etude.sql
winpty docker.exe exec -it postgres pg_dump -F p -U etude etude > etude.sql
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
