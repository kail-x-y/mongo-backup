#!/bin/bash

set -e

SCRIPT_NAME=backup-mongodb
ARCHIVE_NAME=mongodump_$(date +%Y%m%d_%H%M%S).gz
# update CA trust
update-ca-trust

# configure mc assuming the bucket already exists

mc alias set "${OCP_BACKUP_S3_NAME}" "${OCP_BACKUP_S3_HOST}" "${OCP_BACKUP_S3_ACCESS_KEY}" "${OCP_BACKUP_S3_SECRET_KEY}"

echo "[$SCRIPT_NAME] Dumping all MongoDB databases to compressed archive..."

mongodump --archive="$ARCHIVE_NAME" --gzip --uri "$MONGODB_URI" 
	
COPY_NAME=$ARCHIVE_NAME

echo "[$SCRIPT_NAME] Uploading compressed archive to S3 bucket..."

# move files to S3 and delete temporary files
mc cp "$COPY_NAME" "${OCP_BACKUP_S3_NAME}"/"${OCP_BACKUP_S3_BUCKET}"

echo "[$SCRIPT_NAME] Cleaning up compressed archive..."
rm "$COPY_NAME"
rm "$ARCHIVE_NAME" || true

echo "[$SCRIPT_NAME] Backup complete!"
