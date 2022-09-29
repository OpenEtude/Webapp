#!/bin/bash
function log(){
	docker logs -tf $1 | sed 's/^/$1: /'
}
log nginx &
log etude-$1 & 
log nginx-letsencypt &
log nginx-gen &