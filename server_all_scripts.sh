#!/bin/sh

echo "- run certificate generation script"
sh ./server_gen_crt.sh $1 $2

echo "Press Enter - run own CA signing script"
read dummy
sh ./server_sign_server_crt.sh $1 $2

echo " Press Enter - setup folders for kafka nodes"
read dummy
sh ./server_setup_folders.sh

echo "add grants to server certificates"
sudo chmod -R 777 "$1"
sudo chown -R 1000:1000 "$1"

echo "- all scripts are finished"