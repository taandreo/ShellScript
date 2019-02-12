#!/bin/bash
# DnsTest
#
# Autor: Tairan Andreo
# Git: https://github.com/taandreo
#
# Histórico:
#
# v1.0:

SITES_LIST='sites.txt'
DNS_LIST='dns.txt'

for DNS in $(cat $DNS_LIST)
do
    echo -e "$DNS:"
    for SITE in $(cat $SITES_LIST)
    do
        echo -ne "\t$SITE:"
        dig -t a $SITE @$DNS | fgrep 'Query time:' | cut -d : -f 2
    done
    echo
done
