#!/bin/bash

CONFLUENCE_CONTAINER=$(docker ps -aqf "name=confluence_confluence")
CONFLUENCE_BACKUPS_CONTAINER=$(docker ps -aqf "name=confluence_backups")

echo "--> All available application data backups:"

for entry in $(docker container exec -it $CONFLUENCE_BACKUPS_CONTAINER sh -c "ls /srv/confluence-application-data/backups/")
do
  echo "$entry"
done

echo "--> Copy and paste the backup name from the list above to restore application data and press [ENTER]
--> Example: confluence-application-data-backup-YYYY-MM-DD_hh-mm.tar.gz"
echo -n "--> "

read SELECTED_APPLICATION_BACKUP

echo "--> $SELECTED_APPLICATION_BACKUP was selected"

echo "--> Stopping service..."
docker stop $CONFLUENCE_CONTAINER

echo "--> Restoring application data..."
docker exec -it $CONFLUENCE_BACKUPS_CONTAINER sh -c "rm -rf /var/atlassian/application-data/confluence/* && tar -zxpf /srv/confluence-application-data/backups/$SELECTED_APPLICATION_BACKUP -C /"
echo "--> Application data recovery completed..."

echo "--> Starting service..."
docker start $CONFLUENCE_CONTAINER
