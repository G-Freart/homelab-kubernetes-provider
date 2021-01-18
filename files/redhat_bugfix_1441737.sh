#!/bin/bash

# ------------------------------------------------------------------------------------------ #
#                                                                                            #
#                Copyright (c) 2021 - Gilles Freart. All right reserved                      #
#                                                                                            #
#  Licensed under the MIT License. See LICENSE in the project root for license information.  #
#                                                                                            #
# ------------------------------------------------------------------------------------------ #

#
# Bugfix for https://bugzilla.redhat.com/show_bug.cgi?id=1441737
#
if [ -f /proc/sys/fs/may_detach_mounts ]
then
  # Clear old value
  sed -i "/fs.may_detach_mounts/ d" /etc/sysctl.conf

  # Set new valueue
  echo "fs.may_detach_mounts=1" >> /etc/sysctl.conf

  sysctl -p
fi
