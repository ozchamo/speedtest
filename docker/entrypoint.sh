#!/bin/bash

set -e
set -x

# Allow selection of Apache port for network_mode: host
if [ "$WEBPORT" != "80" ]; then
  sed -i "s/^Listen 80\$/Listen $WEBPORT/g" /etc/apache2/ports.conf
  sed -i "s/*:80>/*:$WEBPORT>/g" /etc/apache2/sites-available/000-default.conf 
fi

echo "Done, Starting APACHE"

sleep 120 &
# This runs apache
apache2-foreground
