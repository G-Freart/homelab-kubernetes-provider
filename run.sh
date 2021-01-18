#!/bin/bash

# ------------------------------------------------------------------------------------------ #
#                                                                                            #
#                Copyright (c) 2021 - Gilles Freart. All right reserved                      #
#                                                                                            #
#  Licensed under the MIT License. See LICENSE in the project root for license information.  #
#                                                                                            #
# ------------------------------------------------------------------------------------------ #

if [ ! -d ~/.ansible/collections/ansible_collections/community/libvirt ];
then
  ansible-galaxy collection install -r collections/requirements.yaml
fi

ansible-playbook main.yaml
