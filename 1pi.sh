#!/bin/bash

#things are gonna be messy at first as i dump in all the features before cooking...

###STEP 0 - Overclock and offer reboot
#Declare config file to be modified
CONFIG="/boot/config.txt"

#gpu overclock
if grep -Fq "gpu_freq" $CONFIG
then
	echo "Modifying gpu_freq"
	sed -i "/gpu_freq/c\gpu_freq=500" $CONFIG
else
	echo "gpu_freq not defined. Creating definition"
	echo "gpu_freq=500" >> $CONFIG
fi

#gpu mem overclock
if grep -Fq "core_freq" $CONFIG
then
	echo "Modifying core_freq"
	sed -i "/core_freq/c\core_freq=500" $CONFIG
else
	echo "core_freq not defined. Creating definition"
	echo "core_freq=500" >> $CONFIG
fi

#ram overclock
if grep -Fq "sdram_freq" $CONFIG
then
	echo "Modifying sdram_freq"
	sed -i "/sdram_freq/c\sdram_freq=500" $CONFIG
else
	echo "sdram_freq not defined. Creating definition"
	echo "sdram_freq=500" >> $CONFIG
fi

#ram overvoltage
if grep -Fq "sdram_over_voltage" $CONFIG
then
	echo "Modifying sdram_over_voltage"
	sed -i "/sdram_over_voltage/d" $CONFIG
	echo "sdram_over_voltage=2" >> $CONFIG
else
	echo "sdram_over_voltage not defined. Creating definition"
	echo "sdram_over_voltage=2" >> $CONFIG
fi

#dat schmoo doe
if grep -Fq "sdram_schmoo" $CONFIG
then
	echo "Modifying sdram_schmoo"
	sed -i "/sdram_schmoo/c\sdram_schmoo=0x02000020" $CONFIG
else
	echo "sdram_schmoo not defined. Creating definition"
	echo "sdram_schmoo=0x02000020" >> $CONFIG
fi

#SD card overclock (my fav)
if grep -Fq "dtparam=sd_overclock" $CONFIG
then
	echo "Modifying dtparam=sd_overclock"
	sed -i "/dtparam=sd_overclock/c\dtparam=sd_overclock=100" $CONFIG
else
	echo "dtparam=sd_overclock not defined. Creating definition"
	echo "dtparam=sd_overclock=100" >> $CONFIG
fi

#done overclocking, ask to reboot or continue...
echo "Overclock settings updated."
echo -n "Reboot Now? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;
then
    echo "rebooting now..."
    sudo reboot now
else
    echo "Continuing with script..."
fi

###STEP 1 - Update
sudo apt-get update

###STEP 2 - Purge (credit to github user "hyper3xpl0iter")

#list of packages to remove
pkgs="
epiphany-browser
xpdf
weston
omxplayer
#qt50-snapshot qt50-quick-particle-examples
idle 
python3-pygame 
python-pygame 
python-tk
idle3 python3-tk
python3-rpi.gpio
python-serial 
python3-serial
python-picamera 
python3-picamera
python3-pygame 
python-pygame 
python-tk
python3-tk
debian-reference-en 
dillo x2x
scratch2 
#nuscratch
timidity
smartsim 
#penguinspuzzle
pistore
sonic-pi
python3-numpy
python3-pifacecommon 
python3-pifacedigitalio 
python3-pifacedigital-scratch-handler 
python-pifacecommon 
python-pifacedigitalio
oracle-java8-jdk
minecraft-pi 
python-minecraftpi
libreoffice*
wolfram-engine
greenfoot
bluej
geany
nodered
bluez
bluez-firmware
"

# Go Thru and remove one at a time...
for i in $pkgs; do
	sudo apt-get -y remove --purge $i
done

#alternative command that might be faster but less stable
#sudo apt-get -y remove --purge $pkgs

# Remove all installed dependency packages
sudo apt-get -y autoremove

# Remove packages marked "rc" (doesnt seem to do much)
sudo dpkg --list |grep "^rc" | cut -d " " -f 3 | xargs dpkg --purge

#clean?
sudo apt-get clean

###STEP3 - Upgrade
sudo apt-get upgrade -y

echo "seems like we're done here. thanks, ghostbusker"
read ghostbusker
