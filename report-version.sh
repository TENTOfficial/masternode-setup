#!/bin/bash

# Grab node binary version
version=$(~/snowgem-cli getinfo |grep -w version |grep -Eo '[0-9]+')
#echo $version

ack=$(curl -s -d "version=$version" -X POST https://asgard.snowgem.org/php/public-api.php?action=reportVersion)
echo $ack
