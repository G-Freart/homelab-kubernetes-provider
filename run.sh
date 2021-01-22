#!/bin/bash

# ------------------------------------------------------------------------------------------ #
#                                                                                            #
#                Copyright (c) 2021 - Gilles Freart. All right reserved                      #
#                                                                                            #
#  Licensed under the MIT License. See LICENSE in the project root for license information.  #
#                                                                                            #
# ------------------------------------------------------------------------------------------ #

SCRIPT_NAME=`basename "$0"`
EXTRA_VARS=

usage ()
{
  echo
  echo "usage : ${SCRIPT_NAME} [ -c cluster_name ] "
  echo
  echo " f.i. : ${SCRIPT_NAME} -c \"c7x-crio-fl-ha\""
  echo

  exit 1
}

while getopts ":c:" opt; do
  case ${opt} in
    c)
	EXTRA_VARS="${EXTRA_VAR}cluster_name='${OPTARG}' "
        ;;

    \?)
        usage
        ;;

    :)
        usage
        ;;
  esac
done

if [ ! -d ~/.ansible/collections/ansible_collections/community/libvirt ];
then
  ansible-galaxy collection install -r collections/requirements.yaml
fi

if [ ! -z "${EXTRA_VARS}" ]
then
  ansible-playbook main.yaml --extra-var "${EXTRA_VARS}"
else  
  ansible-playbook main.yaml
fi	

