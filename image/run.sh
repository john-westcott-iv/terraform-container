#!/bin/sh

export PATH=$PATH:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
export DB_INIT_FILE=/var/lib/pgsql/data/db_initalized
export TF_DB_INIT_FILE=/var/lib/pgsql/data/tf_created

# make sure our permissions are set on the PVCs
sudo /usr/bin/chown postgres.0 /var/lib/pgsql
/usr/bin/chmod 700 /var/lib/pgsql
sudo /usr/bin/chown terraform.0 /home/terraform/terraform_scratch

# Check to see if this is the first time we have run, and set up the DB if necessary
if [ ! -f ${DB_INIT_FILE} ]
then
  echo "Initializing DB"
  initdb -D /var/lib/pgsql/data && touch ${DB_INIT_FILE}
fi

if [ ! -f /var/lib/pgsql/data/pg_hba.conf ]
then
  echo "Create pg_hba.conf"
  echo "local   all             all                                     trust" > /var/lib/pgsql/data/pg_hba.conf
fi

# start postgres deamon
echo "Starting pgsql"
/usr/bin/postmaster -D /var/lib/pgsql/data &
# Give postgres a couple seconds to actually start
sleep 5

# Create the terraform_backend database
if [ ! -f ${TF_DB_INIT_FILE} ]
then
  echo "Creating Terraform DB"
  /usr/bin/createdb terraform_backend --user=postgres && touch ${TF_DB_INIT_FILE}
fi

# Initialize terraform
sudo --user=terraform /terraform_init.sh

# Run sshd in the foreground
echo "Starting SSHD"
sudo /usr/sbin/sshd -D
