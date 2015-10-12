#!/bin/bash

echo "$(date) Backing up Postgres databases"

backups_dir=`dirname $0`
echo "Backups dir: $backups_dir/"

echo "Dumping global settings and users"
pg_dumpall --global > $backups_dir/postgres-global-dump.sql
gzip -f $backups_dir/postgres-global-dump.sql

dbs_to_ignore="template0 template1 information_schema"

echo "Dumping each database..."
sql="SELECT datname FROM pg_database WHERE datname NOT IN ("
for ignore in $dbs_to_ignore
do
    echo "Ingoring $ignore"
    sql="$sql '$ignore',"
done
sql="$sql '')"

for db in `psql -qt -c "$sql"`
do
    echo "Backing up database $db"
    pg_dump -C $db > $backups_dir/$db.dump.sql
    gzip -f $backups_dir/$db.dump.sql
done

echo "$(date) Done"
