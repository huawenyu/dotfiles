#!/usr/bin/env bash
# Orig: https://superuser.com/questions/109213/how-do-i-list-the-ssl-tls-cipher-suites-a-particular-website-offers
#  [@linux ~]$ ./test_ciphers 192.168.1.11:443
#      Obtaining cipher list from OpenSSL 0.9.8k 25 Mar 2009.
#      Testing ADH-AES256-SHA...NO (sslv3 alert handshake failure)
#      Testing DHE-RSA-AES256-SHA...NO (sslv3 alert handshake failure)
#      Testing DHE-DSS-AES256-SHA...NO (sslv3 alert handshake failure)
#      Testing AES256-SHA...YES

# OpenSSL requires the port number.
SERVER=$1
DELAY=1
ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')

echo Obtaining cipher list from $(openssl version).

for cipher in ${ciphers[@]}
do
echo -n Testing $cipher...
result=$(echo -n | openssl s_client -cipher "$cipher" -connect $SERVER 2>&1)
if [[ "$result" =~ ":error:" ]] ; then
  error=$(echo -n $result | cut -d':' -f6)
  echo NO \($error\)
else
  if [[ "$result" =~ "Cipher is ${cipher}" || "$result" =~ "Cipher    :" ]] ; then
    echo YES
  else
    echo UNKNOWN RESPONSE
    echo $result
  fi
fi
sleep $DELAY
done
