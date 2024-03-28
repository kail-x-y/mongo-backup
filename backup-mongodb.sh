#!/bin/bash

set -e

SCRIPT_NAME=backup-mongodb
ARCHIVE_NAME=mongodump_$(date +%Y%m%d_%H%M%S).gz
echo "[$SCRIPT_NAME] Dumping all MongoDB databases to compressed archive..."

mongodump --archive="$ARCHIVE_NAME" --gzip --uri "$MONGODB_URI"

COPY_NAME=$ARCHIVE_NAME

echo "[$SCRIPT_NAME] Uploading compressed archive to S3 bucket..."
# configure mc assuming the bucket already exists

mc alias set "${OCP_BACKUP_S3_NAME}" "${OCP_BACKUP_S3_HOST}" "${OCP_BACKUP_S3_ACCESS_KEY}" "${OCP_BACKUP_S3_SECRET_KEY}"


# move files to S3
mc cp "$COPY_NAME" "${OCP_BACKUP_S3_NAME}"/"${OCP_BACKUP_S3_BUCKET}"


echo "[$SCRIPT_NAME] Backup complete!"
