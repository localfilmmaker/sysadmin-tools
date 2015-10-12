#!/bin/bash

echo "$(date) Backing up Postgres databases"

backups_dir=`dirname $0`
echo "Backups dir: $backups_dir/"

echo "Dumping global settings and users"
pg_dumpall --global > $backups_dir/postgres-global-dump.sql
gzip -f $backups_dir/postgres-global-dump.sql

echo "Dumping each database..."
for db in `psql -qt -c "select datname from pg_database where datname not like 'template%' and datname not like 'information_schema'"`
do
    echo $db
    pg_dump $db > $backups_dir/$db.dump.sql
    gzip -f $backups_dir/$db.dump.sql
done

echo "$(date) Done"
