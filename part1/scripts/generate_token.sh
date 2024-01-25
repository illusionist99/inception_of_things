#!/bin/sh


token=`cat /dev/urandom | tr -dc 'A-Z0-9' | fold -w 18 | head -n 1` 

echo "$token" > /home/kali/iot/part1/confs/cluster_token

