#!/bin/sh

export PATH=$PATH:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

# Check to see if this is the first time we have run, and set up the DB if necessary
if [ ! -f /var/lib/pgsql/data/db_initalized ]
then
  sudo postgresql-setup --initdb
  
  touch /var/lib/pgsql/data/db_initalized
fi




