#!/bin/sh

export PATH=$PATH:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
export DB_INIT_FILE=/var/lib/pgsql/data/db_initalized

# Check to see if this is the first time we have run, and set up the DB if necessary
if [ ! -f ${DB_INIT_FILE} ]
then
  echo "Initializing DB"
  initdb -D /var/lib/pgsql/data
  echo "Create pg_hba.conf"
  echo "local   all             all                                     trust" > /var/lib/pgsql/data/pg_hba.conf
  touch ${DB_INIT_FILE}
fi

# start postgres deamon
echo "Starting pgsql"
/usr/bin/postmaster -D /var/lib/pgsql/data &

# Run sshd in the foreground
echo "Starting SSHD"
sudo /usr/sbin/sshd -D
