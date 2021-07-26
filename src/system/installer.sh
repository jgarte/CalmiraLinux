#!/bin/bash
# Calmira Linux pseudographic installator
# (C) 2021 Michail Krasnov <linuxoid85@gmail.com> for Calmira LX4 1.1


##########################################################
#
# BASE VARIABLES
#

BACKTITLE="$DISTRIB_ID $DISTRIB_RELEASE Setup"

##########################################################
#
# CORE-FUNCTIONS
#

function dialog_msg() {
	dialog --backtitle "$BACKTITLE" --title " $1 " --msgbox "$2" 0 0
}

function yesno_msg() {
	dialog --backtitle "$BACKTITLE" --title " $1 " --yesno "$2" 0 0
}


##########################################################
#
# MAIN FUNCTIONS
#

yesno_msg "Welcome to Setup" "The Setup program prepares Calmira LX4 1.1 to run on this computer.

 * To set up Calmira now, select '<Yes>'
 * To exit Setup without installing Calmira, select '<No>'
 
NOTE:
 If you have not backed up your files recently, you might want to do so before
 installing Calmira. To back up your files, select '<No>' to quit Setup now.
 Then, back up your files by using coreutils, tar, squashfs-tools and other."

case $? in
	0)
		echo "Setting up..."
	;;
	
	1)
		echo "Exit."
		exit 0
	;;
	
	255)
		echo "Press ESC key."
		exit 1
	;;
esac

dialog  --backtitle "$BACKTITLE" --title " Disk layout " --clear \
	--inputbox "`lsblk`
	
Enter the LABEL of the disk (e.g. /dev/sda2, /dev/sdc1). This will log in to cfdisk for further markup." 0 0 2> $tempfile
echo -n "Is this correct?"
read run

if [ $run = "Y" ] || [ $run = "y" ]; then
	mkfs.ext4 $(cat $tempfile)
else
	dialog_msg " Error of type " "Critical error."
	exit 1
fi

if [ -d "/mnt/target" ]; then
	rm -rvf /mnt/target
	mkdir -v /mnt/target
else
	mkdir -v /mnt/target
fi

mount -v $(cat $tempfile) /mnt/target

unsquashfs calmira-1.1.sqsh

echo "Copying data. This may take some time."
cd squashfs-root

cp -rxa * /mnt/target/

echo "$(date)" > /mnt/target/etc/system_install_date
