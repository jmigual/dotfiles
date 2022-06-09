#!/bin/bash

tmp=`mktemp`
powershell="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
trap ctrlC INT

removeTempFiles() {
    rm -f $tmp
}

ctrlC() {
    echo
    echo "Trapped Ctrl-C, removing temporary files"
    removeTempFiles
    stty sane
}

echo "Current resolv.conf"
echo "-------------------"
cat /etc/resolv.conf

echo
echo "Creating new resolv.conf"
echo "------------------------"

{
    head -1 /etc/resolv.conf | grep '^#.*generated'
    nameservers=$($powershell \
        -Command "Get-DnsClientServerAddress -AddressFamily ipv4 | Select-Object -ExpandProperty ServerAddresses" \
        )
    for i in $nameservers; do
        echo nameserver $i
    done
    tail -n+2 /etc/resolv.conf | grep -v '^nameserver'
} | tr -d '\r' | tee $tmp

(set -x; sudo cp -i $tmp /etc/resolv.conf; chmod 644 /etc/resolv.conf)

removeTempFiles
