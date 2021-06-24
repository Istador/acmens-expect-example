#!/bin/bash
# this script is expected to set the TXT DNS record for _acme-challenge.$DOMAIN to $CONTENT
# it should only exit once the DNS update has propageted (e.g. by querying several nameservers in a loop)

DOMAIN="$1"
CONTENT="$2"

echo "<dns>"              > dns.$DOMAIN.log
echo "Domain:  $DOMAIN"  >> dns.$DOMAIN.log
echo "Content: $CONTENT" >> dns.$DOMAIN.log
