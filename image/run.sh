#!/bin/sh

export PATH=$PATH:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

# Check to see if this is the first time we have run, and set up the DB if necessary
if [ ! -f /var/lib/pgsql/data/db_initalized ]
then
  sudo /usr/bin/postgresql-setup --initdb
  cat "local   all             all                                     trust" > /var/lib/pgsql/data/pg_hba.conf
  touch /var/lib/pgsql/data/db_initalized
fi

# start postgres deamon
/usr/bin/postmaster -D /var/lib/pgsql/data

# Run sshd in the foreground
sudo /usr/sbin/sshd -D
