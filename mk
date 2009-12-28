#! /bin/bash

cd initrd

rm -rf lib
rm -rf busybox
mkdir -p lib
ln -s ../firmware lib/firmware
ln -s ../modules lib/modules

mkdir -p busybox

ldd bin/* | grep -v 'not a dynamic' |awk 'NF==4 {print $3;} NF==2 {print $1;}' |
(
while read fn; do
	if ! [ -f .$fn ]; then 
		if [ -f $fn ]; then
			cp $fn .$fn 
		else
			echo Depencency $fn unresolved;
		fi;
	fi;
done;
)

xargs ../mkbusybox <<EOF
	[ [[ acpid addgroup adduser adjtimex ar arp arping ash awk basename beep
	blkid brctl bunzip2 bzcat bzip2 cal cat catv chat chattr chgrp chmod
	chown chpasswd chpst chroot chrt chvt cksum clear cmp comm cp cpio crond
	crontab cryptpw cttyhack cut date dc dd deallocvt delgroup deluser depmod
	devmem df dhcprelay diff dirname dmesg dnsd dnsdomainname dos2unix du
	dumpkmap dumpleases echo ed egrep eject env envdir envuidgid ether-wake
	expand expr fakeidentd false fbset fbsplash fdflush fdformat fdisk fgrep
	find findfs fold free freeramdisk fsck fsck.minix fsync ftpd ftpget ftpput
	fuser getopt getty grep gunzip gzip halt hd hdparm head hexdump hostid
	hostname httpd hush hwclock id ifconfig ifdown ifenslave ifplugd ifup inetd
	init insmod install ionice ip ipaddr ipcalc ipcrm ipcs iplink iproute
	iprule iptunnel kbd_mode kill killall killall5 klogd last length less
	linux32 linux64 linuxrc ln loadfont loadkmap logger login logname logread
	losetup lpd lpq lpr ls lsattr lsmod lzmacat makedevs makemime man md5sum
	mdev mesg microcom mkdir mkdosfs mkfifo mkfs.minix mkfs.vfat mknod mkpasswd
	mkswap mktemp modprobe more mount mountpoint msh mt mv nameif nc netstat
	nice nmeter nohup nslookup od openvt passwd patch pgrep pidof ping ping6
	pipe_progress pivot_root pkill popmaildir poweroff printenv printf ps pscan
	pwd raidautorun rdate rdev readahead readlink readprofile realpath reboot
	reformime renice reset resize rm rmdir rmmod route rpm2cpio rtcwake
	run-parts runlevel runsv runsvdir rx script scriptreplay sed sendmail seq
	setarch setconsole setfont setkeycodes setlogcons setsid setuidgid sh sha1sum
	sha256sum sha512sum showkey slattach sleep softlimit sort split
	start-stop-daemon stat strings stty su sulogin sum sv svlogd swapoff swapon
	switch_root sync sysctl syslogd tac tail tar tcpsvd tee telnet telnetd
	test tftp tftpd time timeout top touch tr traceroute true tty ttysize
	tunctl udhcpc udhcpd udpsvd umount uname uncompress unexpand uniq unix2dos
	unlzma unzip uptime usleep uudecode uuencode vconfig vi vlock volname watch
	watchdog wc wget which who whoami xargs yes zcat zcip
EOF

find ./ | cpio -c -o | gzip -c > ../initrd.img
cd ..
