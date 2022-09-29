#!/bin/bash
echo "Waiting 5s to continue..."
sleep 20s

echo "Running PSQL $1..."
psql -U postgres -h 127.0.0.1 -a -c "CREATE USER $1 WITH PASSWORD '$2';" && \
psql -U postgres -h 127.0.0.1 -a -c "CREATE DATABASE $1 encoding='UTF-8' lc_collate='fr_FR.utf8' lc_ctype='fr_FR.utf8' TEMPLATE template0;" && \
psql -U postgres -h 127.0.0.1 -a -c "GRANT ALL PRIVILEGES ON DATABASE $1 TO $1;"
#psql -U postgres -h 127.0.0.1 -a -f -

CREATE USER etude WITH PASSWORD 'etude';
CREATE DATABASE etude encoding='UTF-8' lc_collate='fr_FR.utf8' lc_ctype='fr_FR.utf8' TEMPLATE template0;
GRANT ALL PRIVILEGES ON DATABASE etude TO etude;

sed -i 's/etudeelaoufir/etude/g' D:/Projects/Cloud/etude.sql
docker cp D:/Projects/Cloud/etude.sql postgres:/etude.sql
docker exec -it postgres psql -U etude -d etude -f etude.sql