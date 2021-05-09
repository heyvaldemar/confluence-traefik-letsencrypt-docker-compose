#!/bin/bash

CONFLUENCE_CONTAINER=$(docker ps -aqf "name=confluence_confluence")
CONFLUENCE_BACKUPS_CONTAINER=$(docker ps -aqf "name=confluence_backups")

echo "--> All available database backups:"

for entry in $(docker container exec -it $CONFLUENCE_BACKUPS_CONTAINER sh -c "ls /srv/confluence-postgres/backups/")
do
  echo "$entry"
done

echo "--> Copy and paste the backup name from the list above to restore database and press [ENTER]
--> Example: confluence-postgres-backup-YYYY-MM-DD_hh-mm.gz"
echo -n "--> "

read SELECTED_DATABASE_BACKUP

echo "--> $SELECTED_DATABASE_BACKUP was selected"

echo "--> Stopping service..."
docker stop $CONFLUENCE_CONTAINER

echo "--> Restoring database..."
docker exec -it $CONFLUENCE_BACKUPS_CONTAINER sh -c 'PGPASSWORD="$(echo $POSTGRES_PASSWORD)" dropdb -h postgres -p 5432 confluencedb -U confluencedbuser \
&& PGPASSWORD="$(echo $POSTGRES_PASSWORD)" createdb -h postgres -p 5432 confluencedb -U confluencedbuser \
&& PGPASSWORD="$(echo $POSTGRES_PASSWORD)" gunzip -c /srv/confluence-postgres/backups/'$SELECTED_DATABASE_BACKUP' | PGPASSWORD=$(echo $POSTGRES_PASSWORD) psql -h postgres -p 5432 confluencedb -U confluencedbuser'
echo "--> Database recovery completed..."

echo "--> Starting service..."
docker start $CONFLUENCE_CONTAINER
