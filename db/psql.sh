#APP SCHEMA
docker run -it --rm -e PGPASSWORD=$RDS_PASSWORD postgres:10.6 psql -U $RDS_USERNAME -h $RDS_HOSTNAME -d $RDS_DB_NAME

#POSTGRES SCHEMA
docker run -it --rm postgres:10.6 psql -U arkilog -h $RDS_HOSTNAME -d postgres
