#!/bin/bash
sudo docker ps
##
sleep 5
sudo docker ps | xargs docker restart
##
sleep 3


