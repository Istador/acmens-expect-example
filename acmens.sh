#!/bin/bash
# this script generates an example output of the real acmens script to test the client.sh

set -e
. .env

CSR="$1"
CRT="$2"

#python3  ./acmens/acmens.py  --account-key ./user.ukey  --email "$EMAIL"  --csr "$CSR"  >"$CRT"

>&2 echo "blub"
>&2 echo "Do you agree to the Let's Encrypt Subscriber Agreement"
>&2 echo -n "(https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf)? "
read $REPLY

>&2 echo "blub"
>&2 echo "--------------"
>&2 echo 'URL: http://test1.domain.tld/.well-known/acme-challenge/file1'
>&2 echo 'File contents: "file1.secret1"'
>&2 echo "--------------"
>&2 echo "blub"
>&2 echo -n "Press Enter when you've got the file hosted on your server..."
read $REPLY
>&2 echo "blub"
>&2 echo "test1.domain.tld verified!"

>&2 echo "blub"
>&2 echo "--------------"
>&2 echo 'URL: http://test2.domain.tld/.well-known/acme-challenge/file2'
>&2 echo 'File contents: "file2.secret2"'
>&2 echo "--------------"
>&2 echo "blub"
>&2 echo -n "Press Enter when you've got the file hosted on your server..."
read $REPLY
>&2 echo "blub"
>&2 echo "test2.domain.tld verified!"

>&2 echo "Please update your DNS for 'domain.tld' to have the following TXT record:"
>&2 echo "--------------"
>&2 echo '_acme-challenge    IN    TXT ( "foobar" )'
>&2 echo "--------------"
>&2 echo "Press Enter when the TXT record is updated on the DNS..."
read $REPLY

 >$CRT echo "-----BEGIN CERTIFICATE-----"
>>$CRT echo "example"
>>$CRT echo "-----END CERTIFICATE-----"

>&2 echo "blub"
>&2 echo "Received certificate!"
>&2 echo "You can remove the acme-challenge file from your webserver now."
