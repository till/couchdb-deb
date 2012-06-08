#!/bin/bash

# fix mirrors for us
US_COUNT=$(cat /etc/apt/sources.list|grep -a 'us.'|wc -l)
if [ $US_COUNT -gt 0 ]; then
    sed -i 's/us.archive.ubuntu.com/de.archive.ubuntu.com/g' /etc/apt/sources.list
    apt-get -f -qq -y update
else
    echo "Skipping - seems OK already!"
fi

# install packages

apt-get update
apt-get install -y git-core devscripts fakeroot ssmtp debhelper gnupg
