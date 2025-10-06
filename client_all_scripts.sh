#!/bin/bash

echo "generate client certificates"
sudo sh client_gen_crt.sh $2

echo "Press Enter - sign client certificates with CA"
read dummy

sudo sh client_sign_crt.sh $1 $2

echo "add grants to client certificates"
sudo chmod -R 777 "$2"
sudo chown -R 1000:1000 "$2"

echo "all client scripts are finished"
