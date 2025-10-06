#!/bin/sh

echo "- run certificate generation script"
sh ./generate_cert.sh $1 $2

echo "Press Enter - run own CA signing script"
read dummy
sh ./sign_with_own_ca.sh $1 $2

echo " Press Enter - setup folders for kafka nodes"
read dummy
sh ./setup_folders.sh 3
echo "- all scripts are finished"