#!/bin/bash
echo $DB_HOST
unset PG_CONN_STRING
export PG_CONN_STRING=jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_GIS_DB?user=$DB_USER&password=$DB_PASS
echo $PG_CONN_STRING
