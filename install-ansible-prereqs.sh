#!/bin/bash

#
# Install Ansible prerequisites on the remote host
#

if [ ! -f ~/.ansible-prereqs-installed ]; then
   apt-get install -y python
   [ "$?" -eq 0 ] && touch ~/.ansible-prereqs-installed
fi
