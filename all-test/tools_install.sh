#!/bin/bash

PACET_DIR=$(pwd)
echo $PACET_DIR

debug=0
if [ ${debug} -eq 0 ]
then

### vnc ###
rm /etc/rc.local -rf
cp $PACET_DIR/rc.local /etc/

### copy shell ###
cd $PACET_DIR/jiaoben/
cp * /home/

### copy test music ###
cd $PACET_DIR
cp test_music.mp3 /root/

### spec2006 ###
cd $PACET_DIR/spec2006/spec2006/
tar zxvf spec2006-loongson.tar.gz -C /home/
rm -rf /home/spec2006-loongson/myrun.sh
cp ./myrun.sh /home/spec2006-loongson/
cd /home/spec2006-loongson/
echo y | bash install.sh

### spec2000 ###
cd $PACET_DIR/spec2000/
tar -xvf spec2000-all.tar.bz2 -C /home/
rm -rf /home/spec2000-all/myrun.sh
cp ./myrun.sh /home/spec2000-all/
cd /home/spec2000-all/
rm -rf ./bin
tar -xzvf bin_spec32.tgz
rm -rf ./exe
tar -xzvf exe_gcc.tgz

### IOZONE ###
cd $PACET_DIR/iozone/iozone/
tar xvf iozone3_326.tar -C /opt/
cp *.sh /opt/iozone3_326/
cd /opt/iozone3_326/
mkdir results
cd src/current/
make linux

### UnixBench ###
cd $PACET_DIR/UnixBench5.1.3/
tar zxvf UnixBench5.1.3.tgz -C /home/
cd /home/UnixBench
make

### netperf ###
cd $PACET_DIR/netperf/
tar xvf netperf-2.4.5.tar -C /opt/
cp netperf.sh /opt/netperf-2.4.5/
cd /opt/netperf-2.4.5
./configure
make
make install

### stream ###
cd $PACET_DIR/stream/
cp ./stream /home/ -rf

### x11perf ###
cd $PACET_DIR/x11perf/
tar zxvf x11perf-1.5.4.tar.gz -C /opt/
cd /opt/x11perf-1.5.4/rpm-install/
rpm -ivh *
cd ..
./configure 
make all

### stress ###
cd $PACET_DIR/stress/
tar xvf stress.tar.gz -C /home/

### LTP ###
cd $PACET_DIR/LTP/
tar xvf ltp-full-20150420.tar.bz2 -C /home/
cd /home/ltp-full-20150420
./configure
make all
make install
# ltp rpm #
cd $PACET_DIR/LTP/tools/
rpm  -ivh  xinetd-2.3.14-32.ND6.1.mipsel.rpm
rpm  -ivh  rsh-server-0.17-62.ND6.1.mipsel.rpm
rm -rf /etc/xinetd.d/rsh
rm -rf /etc/xinetd.d/rlogin
cp rsh /etc/xinetd.d
cp rlogin /etc/xinetd.d/
service xinetd restart
service xinetd restart
# sysstat #
cd ./sysstat
tar xvf sysstat-11.1.3.tar.xz
cd ./sysstat-11.1.3
./configure
make
make install
# bison #
cd $PACET_DIR/LTP/tools/bison/
tar zxvf bison-2.4.1.tar.gz
cd ./bison-2.4.1
./configure
make
make install
# flex #
cd $PACET_DIR/LTP/tools/flex
tar xvf flex-2.5.33.tar.bz2
cd ./flex-2.5.33
./configure
make
make install

fi
