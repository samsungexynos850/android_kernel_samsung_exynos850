#!/bin/bash
# Script by Me - RiskyGUY22 (thomas_turner36)

# Set default kernel variables
PROJECT_NAME="Lineage Kernel"
ZIPNAME=A217F-S8-Lineage.zip
DEFCONFIG=lineage_defconfig
LOS=$(pwd)/Lineage
LOS_KERNEL=$(pwd)/out/arch/arm64/boot
LOS_DTB=$(pwd)/out/arch/arm64/boot/dts
PACKAGING=$(pwd)/Lineage/packaging

# Export commands
export ARCH=arm64
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s

# Get date and time
DATE=$(date +"%m-%d-%y")
BUILD_START=$(date +"%s")

################### Executable functions #######################
CLEAN_PACKAGES()
{

	if [ ! -e "out" ]
	then
	  {
	     mkdir out
	  }
	fi

	rm -rf Lineage/packaging/boot.img
	rm -rf Lineage/packaging/A21F-S8-Lineage.zip
  rm -rf $LOS_KERNEL/Image
  rm -rf $LOS_KERNEL/../configs/.tmp_defconfig
}

CLEAN_SOURCE()
{
  read -p "Clean source? [Y] (Y/N): " clean_confirm
  if [[ $clean_confirm == [yY] || $clean_confirm == [yY][eE][sS] ]]; then
    echo "Cleaning source ..."
    make clean && make mrproper
    rm -rf $(pwd)/out
  else
    echo "Source will not be cleaned"
  fi
}

UPDATE_DEPS()
{
  if hostnamectl | grep -q 'Ubuntu'; then
    echo "You are running an Ubuntu machine"
    sudo apt update && sudo apt upgrade -y
    sudo apt-get install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison python3 python-is-python3 -y
  else
    echo "You are not running Ubuntu - *DEPENDENCIES will NOT be installed*"
  fi
}

DETECT_TOOLCHAIN()
{
  if [ ! -e "~/toolchains/gcc-4.9" ]; then
    echo "GCC v4.9 Toolchain NOT detected, Downloading now..."
    sudo git clone --depth=1 https://github.com/Samsung-Galaxy-A21s/toolchain ~/toolchains/gcc-4.9/
  fi
}

BUILD_KERNEL()
{
	echo "*****************************************************"
	echo "           Building kernel for SM-A217F S8           "
	make ARCH=arm64 $DEFCONFIG O=$(pwd)/out
	make ARCH=arm64 -j64 O=$(pwd)/out

  # Check if kernel Image was created
  if [ ! -e $LOS_KERNEL/Image ]; then
  echo "Failed to compile Kernel!"
  echo "Abort"
  exit 0;
  fi

}


AIK-Linux()
{
	# Building boot image with AIK-Linux
	if [ -e "out/arch/$ARCH/boot/Image" ]
	then
	{
		echo -e "*****************************************************"
		echo -e "                                                     "
		echo -e "       Building flashable boot image...              "
		echo -e "                                                     "
		echo -e "*****************************************************"

		# Build bootable image
		$LOS/AIK-Linux/unpackimg.sh
    cp -r $LOS_KERNEL/Image $LOS/AIK-Linux/split_img/boot.img-kernel
		$LOS/AIK-Linux/repackimg.sh
		cp -r $LOS/AIK-Linux/image-new.img $PACKAGING/boot.img
		$LOS/AIK-Linux/cleanup.sh

		# Build packaging
		cd $PACKAGING
		zip -r $ZIPNAME *
		chmod 0777 $ZIPNAME
		# Change back into kernel source directory
		cd ../../
	}
	fi
}

DISPLAY_ELAPSED_TIME()
{
	# Find out how much time build has taken
	BUILD_END=$(date +"%s")
	DIFF=$(($BUILD_END - $BUILD_START))

	BUILD_SUCCESS=$?
	if [ $BUILD_SUCCESS != 0 ]
		then
			echo " Error: Build failed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds $reset"
			exit
	fi

	echo -e " Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds $reset"
}


MAIN()
{
  UPDATE_DEPS
  DETECT_TOOLCHAIN
  CLEAN_SOURCE
  CLEAN_PACKAGES
	echo "*****************************************************"
	echo "                                                     "
	echo "        Starting compilation of Lineage kernel       "
	echo "                                                     "
	echo " Defconfig = $DEFCONFIG                              "
	echo "                                                     "
	echo "                                                     "
	echo " "
	BUILD_KERNEL
	echo " "
	AIK-Linux
	echo " "
	DISPLAY_ELAPSED_TIME
	echo " "
	echo "**********************************************************************"
	echo "*                                                                    *"
	echo "*                         build finished                             *"
	echo "*           Check Lineage/packaging for a flashable zip              *"
  echo "*                                                                    *"
	echo "**********************************************************************"
}


#################################################################

# Call the function which runs everything
MAIN
