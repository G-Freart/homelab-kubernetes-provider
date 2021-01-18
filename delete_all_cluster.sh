#!/bin/bash

# ------------------------------------------------------------------------------------------ #
#                                                                                            #
#                Copyright (c) 2021 - Gilles Freart. All right reserved                      #
#                                                                                            #
#  Licensed under the MIT License. See LICENSE in the project root for license information.  #
#                                                                                            #
# ------------------------------------------------------------------------------------------ #

original_pwd=`pwd`
iso_node_path=`cat group_vars/kvm_host/libvirt_setup.yaml | grep -e "libvirt_node_image_path"   | sed "s/^[^:]*\:\ *//"`
storage_path=` cat group_vars/kvm_host/libvirt_setup.yaml | grep -e "libvirt_storage_pool_path" | sed "s/^[^:]*\:\ *//"`

if [ -d "instances" ]
then
  instance=$original_pwd/instances/`cat /var/lib/dbus/machine-id`

  if [ -d "instance" ]
  then
    cd ${instance}

    for cluster_name in * ;
    do
      if [ "$cluster_name" != "*" ] 
      then	    
        echo "Processing cluster $cluster_name at folder `pwd`"
  
        for terraform_repo_name in control_plane worker load_balancer ;
        do
          echo "  Check existenz at ${instance}/${cluster_name}/terraform/${terraform_repo_name}"
  
          if [ -d ${instance}/${cluster_name}/terraform/${terraform_repo_name} ]
          then
            echo "    Terraform destroying $cluster_name -> $terraform_repo_name"
    
            cd ${instance}/${cluster_name}/terraform/${terraform_repo_name}
    
      	  echo yes | terraform destroy
    
          echo "    Deleting terraform folder"
  
    	  rm -rf ${instance}/${cluster_name}/terraform/${terraform_repo_name}
          fi
        done
  
        sudo virsh pool-destroy  ${cluster_name} 2> /dev/null
        sudo virsh pool-delete   ${cluster_name} 2> /dev/null
        sudo virsh pool-undefine ${cluster_name} 2> /dev/null
  
        sudo rm -rf ${iso_node_path}/${cluster_name}
        sudo rm -rf ${storage_path}/${cluster_name}
    
        rm -rf ${instance}/${cluster_name}
      fi
    done
  fi

  cd $original_pwd
fi
