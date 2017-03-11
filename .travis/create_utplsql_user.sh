#!/bin/bash
set -ev

cd $(dirname "$(readlink -f "$0")")
#create user
"$SQLCLI" -L -S sys/oracle@//$CONTAINER_IP:1521/ORCLCDB AS SYSDBA <<SQL
set echo off
@@create_utplsql_user.sql $UT3_USER $UT3_USER_PASSWORD $UT3_USER_TABLESPACE
SQL
