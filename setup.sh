echo "Create kafka folders for $1 nodes."
# does not work in sh
# mkdir -p kafka{1..$1}/data

for i in $(seq 1 $1); do
  mkdir -p "kafka${i}/data"
done

echo "Add grants to kafka folders."
ls -d */ | while read folder; do sudo chmod -R 755 "$folder"; done

echo "Setup is done."
