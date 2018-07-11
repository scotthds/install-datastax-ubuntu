#!/usr/bin/env bash
cloud_type=$1
opscenter_version=6.5.0

if [ -z "$OPSC_VERSION" ]
then
  echo "env \$OPSC_VERSION is not set, using default: $opscenter_version"
else
  echo "env \$OPSC_VERSION is set: $OPSC_VERSION overiding default"
  opscenter_version=$OPSC_VERSION
fi

echo "Installing OpsCenter"

echo "Adding the DataStax repository"
if [[ $cloud_type == "gce" ]] || [[ $cloud_type == "gke" ]]; then
  echo "deb http://datastax%40google.com:8GdeeVT2s7zi@debian.datastax.com/enterprise stable main" | sudo tee -a /etc/apt/sources.list.d/datastax.sources.list
elif [[ $cloud_type == "azure" ]]; then
  echo "deb http://datastax%40microsoft.com:3A7vadPHbNT@debian.datastax.com/enterprise stable main" | sudo tee -a /etc/apt/sources.list.d/datastax.sources.list
elif [[ $cloud_type == "aws" ]]; then
  echo "deb http://datastax%40amazon.com:A8ePXn%5EHH0%260@debian.datastax.com/enterprise stable main" | sudo tee -a /etc/apt/sources.list.d/datastax.sources.list
elif [[ $cloud_type == "oracle" ]] || [[ $cloud_type == "bmc" ]]; then
  echo "deb http://datastax%40oracle.com:*9En9HH4j%5Ep4@debian.datastax.com/enterprise stable main" | sudo tee -a /etc/apt/sources.list.d/datastax.sources.list
else
  echo "deb http://datastax%40clouddev.com:CJ9o%21wOlDX1a@debian.datastax.com/enterprise stable main" | sudo tee -a /etc/apt/sources.list.d/datastax.sources.list
fi

echo -e "Checking if apt/dpkg running, start: $(date +%r)"
while ps -A | grep -e apt -e dpkg >/dev/null 2>&1; do sleep 10s; done;
echo -e "No other procs: $(date +%r)"

curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -

apt-get update
apt-get -y install opscenter=$opscenter_version
