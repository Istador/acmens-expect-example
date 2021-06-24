#!/bin/bash
# this script is expected to host $CONTENT inside of a file accessible under: http://$DOMAIN/.well-known/acme-challenge/$FILE

DOMAIN="$1"
FILE="$2"
CONTENT="$3"

echo "<host>"             > $FILE.log
echo "Domain:  $DOMAIN"  >> $FILE.log
echo "File:    $FILE"    >> $FILE.log
echo "Content: $CONTENT" >> $FILE.log
