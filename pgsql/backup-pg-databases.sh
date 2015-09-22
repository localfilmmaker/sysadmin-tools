#!/bin/bash

echo "$(date) Backing up Postgres databases"

echo "Dumping global settings and users"
pg_dumpall --global > postgres-global-dump.sql
gzip -f postgres-global-dump.sql

echo "Dumping each database..."
for db in `psql -qt -c "select datname from pg_database where datname not like 'template%' and datname not like 'information_schema'"`
do
    echo $db
    pg_dump $db > $db.dump.sql
    gzip -f $db.dump.sql
done

echo "$(date) Done"
