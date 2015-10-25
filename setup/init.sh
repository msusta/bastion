#!/bin/bash

aptitude install python-dulwich salt-minion

mkdir /etc/salt/states
mkdir /etc/salt/pillar

# put masterless.conf to minion.d

# schedule highstate?
