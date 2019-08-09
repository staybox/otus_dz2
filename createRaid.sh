#!/bin/bash
DIRECTORY=/etc/mdadm
FILE=/etc/mdadm/mdadm.conf
if ! test -d $DIRECTORY; then
    mkdir $DIRECTORY
else
    echo "$DIRECTORY exist"
fi
if ! test -f $FILE; then
    mkdir $FILE
else
    echo "$FILE exist"
fi

#mdadm --zero-superblock --force /dev/sd{e,f}
echo 'y' | mdadm --create --force --quiet --verbose /dev/md1 -l 1 -n 2 /dev/sd{e,f}
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
parted -s /dev/md1 mklabel gpt
parted /dev/md1 mkpart primary ext4 0% 100%
mkfs.ext4 /dev/md1p1
mkdir /mnt/raid
mount /dev/md1p1 /mnt/raid
mdadm -D /dev/md1