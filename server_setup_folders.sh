#!/bin/sh

count=3
echo "create kafka folders for $count nodes."
# does not work in sh
# mkdir -p kafka{1..$1}/data

for i in $(seq 1 $count); do
  dir="kafka${i}/data"

  mkdir -p "$dir"
  sudo chmod -R 777 "$dir"
  sudo chown -R 1000:1000 "$dir"
done

echo "folders are created."
