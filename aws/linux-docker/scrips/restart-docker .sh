#!/bin/bash
sudo docker ps
##
sleep 5
sudo docker ps | xargs docker restart
## or sudo docker restart $(docker ps -qa) ##
sleep 3

