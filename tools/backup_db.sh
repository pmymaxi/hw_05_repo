# TAsk backup for DB
set -a
. /opt/ip-hw05/.env
set +a

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
NET_NAME=ip-hw05_backend
DB_HOST=db
DB_NAME=db_app
BACKUP_DIR=/opt/backup/


docker run \
    --rm --entrypoint "" \
    --network $NET_NAME \
    -v $BACKUP_DIR:/backup \
    schnitzler/mysqldump \
    mysqldump --opt -h $DB_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD "--result-file=/backup/$DB_HOST-$DB_NAME-$TIMESTAMP.sql" $DB_NAME