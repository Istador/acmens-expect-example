#!/bin/bash
# this script is expected to delete: http://$DOMAIN/.well-known/acme-challenge/$FILE

DOMAIN="$1"
FILE="$2"

echo "<remove>"          >> $FILE.log
echo "Domain:  $DOMAIN"  >> $FILE.log
echo "File:    $FILE"    >> $FILE.log
