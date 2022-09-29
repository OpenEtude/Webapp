#!/usr/bin/env bash
mkdir -p /root/arkilogbackup/current/
rm -Rf /root/arkilogbackup/current/*
PGPASSWORD=$RDS_PASSWORD pg_dump -w -F p -h $RDS_HOSTNAME $RDS_DB_NAME -U $RDS_USERNAME > /root/arkilogbackup/current/etude.sql