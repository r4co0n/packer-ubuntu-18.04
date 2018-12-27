#!/bin/bash -eu

echo "==> Disk usage before minimization"
df -h

echo "==> Installed packages before cleanup"
dpkg --get-selections | grep -v deinstall

echo "==> Removing documentation"
dpkg --list | awk '{ print $2 }' | grep -- '-doc$' | xargs apt-get -y purge

echo "==> Removing development packages"
dpkg --list | awk '{ print $2 }' | grep -- '-dev$' | xargs apt-get -y purge

echo "==> Removing development tools"
dpkg --list | grep -i compiler | awk '{ print $2 }' | xargs apt-get -y purge

echo "==> Removing X11 libraries"
apt-get -y purge \
    libx11-data \
    xauth \
    libxmuu1 \
    libxcb1 \
    libx11-6 \
    libxext6

echo "==> Removing other oddities"
apt-get -y purge \
    busybox-static \
    command-not-found \
    ed \
    friendly-recovery \
    ftp \
    hdparm \
    irqbalance \
    info \
    installation-report \
    iputils-tracepath \
    landscape-common \
    libntfs-3g88 \
    libunwind8 \
    libxau6 \
    libxdmcp6 \
    lsof \
    lshw \
    ltrace \
    mtr-tiny \
    ntfs-3g \
    popularity-contest \
    rsync \
    software-properties-common \
    strace \
    tcpdump \
    telnet \
    time \
    wireless-tools \
    wpasupplicant

# Clean up the apt cache
apt-get -y autoremove --purge
apt-get -y clean

# Clean up orphaned packages with deborphan
apt-get -y install deborphan
while [ -n "$(deborphan --guess-all --libdevel)" ]; do
    deborphan --guess-all --libdevel | xargs apt-get -y purge
done
apt-get -y purge deborphan
apt-get -y autoremove --purge

echo "==> Removing man pages"
rm -rf /usr/share/man/*
#echo "==> Removing APT files"
#find /var/lib/apt -type f | xargs rm -f
echo "==> Removing any docs"
rm -rf /usr/share/doc/*
echo "==> Removing caches"
find /var/cache -type f -exec rm -rf {} \;

echo "==> Disk usage after cleanup"
df -h
