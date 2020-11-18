#!/bin/sh

export PATH=$PATH:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
export INIT_DIR=/home/terraform/terraform_scratch/init
export PROVIDER_INIT_FILE_NAME=.provider_inited
export WORKSPACE_INIT_FILE_NAME=.workspace_inited

if [ ! -d ${INIT_DIR} ] ; then
  echo "Cloning terraform project"
  git clone https://grandpaw-westcott:github123!@github.com/john-westcott-iv/terraform.git ${INIT_DIR}
fi

for PROVIDER in 'aws' 'azure' ; do
    cd ${INIT_DIR}/${PROVIDER}
    if [ ! -f ${PROVIDER_INIT_FILE_NAME} ] ; then
      /home/terraform/bin/terraform init
      touch ${PROVIDER_INIT_FILE_NAME}
    fi
    if [ ! -f ${WORKSPACE_INIT_FILE_NAME} ] ; then
      /home/terraform/bin/terraform workspace new ${PROVIDER}
      touch ${WORKSPACE_INIT_FILE_NAME}
      # When using postgres you have to re-init after createing the workspace
      /home/terraform/bin/terraform init
    fi
done
