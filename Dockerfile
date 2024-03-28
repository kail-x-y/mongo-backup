FROM mongo:latest

USER root

RUN apt update && \
    apt install wget -y && \
    wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/bin/mc && \
    chmod +x /usr/bin/mc

RUN mkdir -p /data/db/.mc && \
    chmod -R 777 /data/db/.mc

WORKDIR /scripts

COPY backup-mongodb.sh .
RUN chmod +x backup-mongodb.sh && \
    chmod g=u -R backup-mongodb.sh && \
    chgrp 0 -R backup-mongodb.sh


RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

USER 1001

ENV MONGODB_URI="" \
    OCP_BACKUP_S3_NAME="" \
    OCP_BACKUP_S3_HOST="" \
    OCP_BACKUP_S3_ACCESS_KEY="" \
    OCP_BACKUP_S3_SECRET_KEY="" \
    OCP_BACKUP_S3_BUCKET=""

CMD ["/scripts/backup-mongodb.sh"]
