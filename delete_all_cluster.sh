#!/bin/bash

# ------------------------------------------------------------------------------------------ #
#                                                                                            #
#                Copyright (c) 2021 - Gilles Freart. All right reserved                      #
#                                                                                            #
#  Licensed under the MIT License. See LICENSE in the project root for license information.  #
#                                                                                            #
# ------------------------------------------------------------------------------------------ #

original_pwd=`pwd`
iso_node_path=`cat vars/default-settings.yaml | grep -e "libvirt_node_image_path"   | sed "s/^[^:]*\:\ *//"`
storage_path=` cat vars/default-settings.yaml | grep -e "libvirt_storage_pool_path" | sed "s/^[^:]*\:\ *//"`

if [ -d "instances" ]
then
  instances=$original_pwd/instances/`cat /var/lib/dbus/machine-id`

  if [ -d "${instances}" ]
  then
    cd ${instances}

    for cluster_name in * ;
    do
      if [ "$cluster_name" != "*" ] 
      then	    
        echo "Processing cluster $cluster_name at folder `pwd`"
  
        for terraform_repo_name in `ls -d ${instances}/${cluster_name}/terraform/*/` ;
        do
          echo "  Check existenz at ${terraform_repo_name}"
  
          if [ -d ${terraform_repo_name} ]
          then
            echo "    Terraform destroying $cluster_name -> `basename $terraform_repo_name`"
    
            cd ${terraform_repo_name}
    
      	  echo yes | terraform destroy
    
          echo "    Deleting terraform folder"
  
    	  rm -rf ${terraform_repo_name}
          fi
        done
  
        sudo virsh pool-destroy  ${cluster_name} 2> /dev/null
        sudo virsh pool-delete   ${cluster_name} 2> /dev/null
        sudo virsh pool-undefine ${cluster_name} 2> /dev/null
  
        sudo rm -rf ${iso_node_path}/${cluster_name}
        sudo rm -rf ${storage_path}/${cluster_name}
    
        rm -rf ${instances}/${cluster_name}
      fi
    done

    cd $original_pwd
  fi

fi
