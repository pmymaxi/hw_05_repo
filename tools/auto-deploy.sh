#!/bin/bash
# bash-скрипт, который скачает ваш fork-репозиторий в каталог и запустит проект целиком.

read -p "Project Location: " DIR
read -p "Link to the repository in github: " REPO

#Create directory
mkdir -p $DIR
if [ -e "$DIR" ]; then
    echo "$DIR create"
    echo
    #Clone repo
    git clone $REPO $DIR
else
    echo "The directory cannot be created"
    exit 1
fi

#Add env file for MySQL
touch $DIR/.env
ENV=$DIR/.env

if [ -e "$ENV" ]; then
    echo
    echo "$ENV file create"
    echo
    echo "Add env file in directory $DIR"
    read -s -p "Enter MySQL root password: " MYSQL_ROOT_PASSWORD
    echo
    read -p "Enter name databases: " MYSQL_DATABASE
    read -p "Enter user name: " MYSQL_USER
    read -s -p "Enter MySQL user password: " MYSQL_PASSWORD
    echo
    sleep 1s
cat <<EOF > $ENV
MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
MYSQL_DATABASE=$MYSQL_DATABASE
MYSQL_USER=$MYSQL_USER
MYSQL_PASSWORD=$MYSQL_PASSWORD
EOF
else
    echo "The env file in directory cannot be created"
    exit 1
fi

#Chek value env file
if [ -s "$ENV" ]
    then
    . $ENV
        for chekvar in MYSQL_ROOT_PASSWORD MYSQL_DATABASE MYSQL_USER MYSQL_PASSWORD 
            do
                if [ -z "${!chekvar}" ] 
                then
                    echo "Err: $chekvar value is empty"
                    exit 1
                    fi
            done
else    
    echo "! The env file has no variables"
fi

# Deploy stage docker compose
docker compose --project-directory $DIR -f $DIR/compose.yaml up -d
echo
sleep 5s
docker compose --project-directory $DIR ps