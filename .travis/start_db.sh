#!/bin/bash
set -e

# Create the dir to host oracledata and check if it is present on cache.
mkdir -p $HOME/$ORACLE_VERSION && chmod -R 777 $HOME/$ORACLE_VERSION
if [ -f $HOME/$ORACLE_VERSION.tar.gz ]; then
    echo "Restoring database from cache..."
    sudo tar -zxf $HOME/$ORACLE_VERSION.tar.gz -C $HOME/$ORACLE_VERSION
fi

# Oracle 12c R1 SE
if [ $ORACLE_VERSION = $ORACLE_12cR1SE ]; then
    docker login -u "$DOCKER_12cR1SE_USER" -p "$DOCKER_12cR1SE_PASS"
    docker run -d --name $ORACLE_VERSION -p 1521:1521 -v $HOME/$ORACLE_VERSION:/opt/oracle/oradata viniciusam/oracle-12c-r1-se
    docker logs -f $ORACLE_VERSION | grep -m 1 "DATABASE IS READY TO USE!" --line-buffered
    docker exec $ORACLE_VERSION ./setPassword.sh $ORACLE_PWD
fi

# Oracle 11g R2 XE
if [ $ORACLE_VERSION = $ORACLE_11gR2XE ]; then
    docker login -u "$DOCKER_11gR2XE_USER" -p "$DOCKER_11gR2XE_PASS"
    docker run -d --name $ORACLE_VERSION --shm-size=1g -p 1521:1521 -v $HOME/$ORACLE_VERSION:/u01/app/oracle/oradata vavellar/oracle-11g-r2-xe
    docker logs -f $ORACLE_VERSION | grep -m 1 "DATABASE IS READY TO USE!" --line-buffered
    docker exec $ORACLE_VERSION ./setPassword.sh $ORACLE_PWD
fi

# Save the oracledata dir to cache.
if [ ! -f $HOME/$ORACLE_VERSION.tar.gz ]; then
    echo "Saving database to cache..."
    docker pause $ORACLE_VERSION
    sudo tar -zcf $CACHE_DIR/$ORACLE_VERSION.tar.gz $HOME/$ORACLE_VERSION
    docker unpause $ORACLE_VERSION
fi
