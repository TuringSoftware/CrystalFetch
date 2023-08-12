#!/bin/sh
#
# w11arm_esd2iso - download and convert Microsoft ESD files for Windows 11 ARM to ISO
#
# Copyright (C) 2023 Paul Rockwell
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA#
#
# Credit: Location and methods of obtaining Microsoft ESD distributions and
# Microsoft Product catalog from b0gdanw "ESD to ISO on macOS.txt" https://gist.github.com/b0gdanw/e36ea84828dbd19e03eff6158f1fc77c
#

versionID="4.0.2 (13-July-2023)"
version="w11arm_esd2iso ${versionID}\n"
verbosityLevel=0

awk="/usr/bin/awk"
genisoimage="$(command -v mkisofs)"

declare -a lTags
declare -a lDesc

usage() {
  echo "Usage:\n"
  echo "$0 [-v]"
  echo "$0 [-Vh]"
  echo "\nOptions:"
  echo "\t-h\tPrint usage and exit"
  echo "\t-v\tEnable verbose output"
  echo "\t-V\tPrint program version and exit"
}
printVersion() {
	echo $version
}
verboseOn() {
	if (( verbosityLevel == 0 )); then
		return 1
	else
		return 0
	fi
}

extractEsd(){	
	
	local eFile
	local eDir
	local retVal
	local esdImageCount
	local bootWimFile
	local installWimFile
	local images
	local imageIndex
	local imageEdition
	local beQuiet
	
	eFile=$1
	eDir=$2
	beQuiet="--quiet"
	bootWimFile=$eDir/sources/boot.wim
	installWimFile=$eDir/sources/install.wim
	images=("4" "5")
	
	verboseOn && beQuiet=""
	
	esdImageCount=$(wimlib-imagex info $eFile | $awk '/Image Count:/ {print $3}')
	verboseOn && echo "[DEBUG] image count in ESD: $esdImageCount"
	(( $esdImageCount == 6 )) && images+=("6")

	#---------------
	# Extract image 1 in the ESD to create the boot environment
	#---------------

	echo "\nApplying boot files to the image"
	wimlib-imagex apply $eFile 1 $eDir $beQuiet 2>/dev/null
	retVal=$?
	if (( retVal != 0 )); then
		echo "[ERROR] Extract of boot files failed"
		return $retVal
	fi

	echo "Boot files successfully applied to image"

	#---------------
	# Create the boot.wim file that contains WinPE and Windows Setup
	# Images 2 and 3 in the ESD contain these components
	#
	# Important: image 3 in the ESD must be marked as bootable when
	# transferred to boot.wim or else the installer will fail
	#---------------

	echo "\nAdding WinPE and Windows Setup to the image"
	wimlib-imagex export $eFile 2 $bootWimFile --compress=LZX --chunk-size 32K $beQuiet
	retVal=$?
	if (( retVal != 0 )); then
		echo "[ERROR] Add of WinPE failed"
		return $retVal
	fi

	wimlib-imagex export $eFile 3 $bootWimFile --compress=LZX --chunk-size 32K --boot $beQuiet
	retVal=$?
	if (( retVal != 0 )); then
		echo "[ERROR] Add of Windows Setup failed"
		return $retVal
	fi
	echo "WinPE and Windows Setup added successfully to image\n"
	
	verboseOn && {
		echo "[DEBUG] contents of $bootWimFile"
		wimlib-imagex info  $bootWimFile
	}


	#---------------
	# Create the install.wim file that contains the files that Setup will install
	# Images 4, 5, (and 6 if it exists) in the ESD contain these components
	#---------------
	
	for imageIndex in ${images[*]}; do
		imageEdition="$(wimlib-imagex info $eFile $imageIndex | grep '^Description:' | sed 's/Description:[ \t]*//')"
		echo "\nAdding $imageEdition to the image"
		wimlib-imagex export $eFile $imageIndex $installWimFile --compress=LZMS --chunk-size 128K $beQuiet
		retVal=$?
		if (( retVal != 0 )); then
			echo "[ERROR] Addition of $imageIndex to the image failed"
			return $retVal
		fi
		echo "$imageEdition added successfully to the image"

	done

	echo "\nAll Windows editions added to image"	
	
	verboseOn && {
		echo "[DEBUG] contents of $installWimFile"
		wimlib-imagex info $installWimFile
	}
	
	return 0
}

buildIso(){
	local iDir=$1
	local iFile=$2
	local iLabel=$3
	local elToritoBootFile
	
	iDir=$1
	iFile=$2
	
	if [ -e $iFile ]; then
	  echo "\t[INFO] File $iFile exists, removing it"
	  rm -rf $iFile
	fi

	elToritoBootFile=$iDir/efi/microsoft/boot/efisys.bin
	
	#
	# Create the ISO file
	#

	#$hdiutil makehybrid -o $iFile -iso -udf -hard-disk-boot -eltorito-boot $elToritoBootFile $iDir
	"$genisoimage" -b "efi/microsoft/boot/efisys.bin" --no-emul-boot \
		--udf -iso-level 3 --hide "*" -V "$iLabel" -o "$iFile" $iDir
	return $?
}

#-------------------
#
# Start of program
#
#-------------------


#-------------------
# 
# Process arguments
# 
#-------------------

while getopts ":hr:vV" opt; do
  case $opt in
    h)
    	usage
    	exit 1
    	;;
    	
	v)
    	let verbosityLevel+=1
    	;;
	V)
    	printVersion
    	exit 1
    	;;
    :)
    	echo "[ERROR] Option -$OPTARG requires an argument"
    	usage
    	exit 1
    	;;
    
    \?)
    	echo "[ERROR] Invalid option: -$OPTARG\n"
    	usage
    	exit 1
    	;;
    esac
done
shift "$((OPTIND-1))"


printVersion

esdFile="$1"
isoFile="$2"
isoLabel="$3"

#-------------------
# Check number of arguments
# One argument is allowed when using the -r option for restart
# No arguments are allowed otherwise
#-------------------

if (( $# > 3 )); then
	echo "[ERROR] Too many arguments"
	usage
	exit 1
fi

workingDir="$(mktemp -q -d ./esd2iso_temp.XXXXXX)"
if (( $? != 0 )); then
	echo "[ERROR] Unable to create work directory, exiting"
	exit 1
fi

#---------------
#
# extDir is the "extract directory" where we're going to extract the ESD 
# and evenutally build the ISO from. It's a subdirectory of the working/temp directory
#
##---------------

extDir=$workingDir/ESD_ISO
mkdir $extDir

echo "\nStep 3: Building installation image from ESD distribution"
extractEsd $esdFile $extDir
retVal=$?
if (( retVal != 0 )); then
	echo "[ERROR] Installation image build failed with error code $retVal"
	echo "Work directory $workingDir was not deleted, use for debugging"
	exit 1
fi

#---------------
# At this point we no longer need the ESD file as it's already extracted
# In order to reduce disk space reauirements, delete the ESD file unless we
# have set the environment variable keepDownloads
#---------------

if [[ "x${keepDownloads}" == "x" ]]; then
	echo \n"ESD added successfully to installation image and is no longer needed.\nDeleting it to save disk space."
	verboseOn && echo "Deleting ESD file ${esdFile}"
	rm -rf ${esdFile} 
	retVal=$?
	if (( retVal != 0 )); then
		echo "[WARNING] Deletion of ESD file encountered a problem."
		echo "          The ISO build can continue, but will consume an addtional 5 GB of disk space."
	else
		echo "ESD file deleted successfully\n"
	fi
else
	verboseOn && echo "[DEBUG] keepDownloads is set - keeping ESD download"
fi

echo "\nStep 3 complete - installation image built"
	
echo "\nStep 4: Creating ISO $isoFile from the installation image\n"

buildIso $extDir $isoFile $isoLabel
retVal=$?
if (( retVal != 0 )); then
	echo "[ERROR] ISO was NOT created"
    echo "Working directory $workingDir was not deleted, use for debugging"
    exit 1
fi

echo "Step 4 complete - ISO created"
echo "\nCleaning up work directory"
rm -rf $workingDir
echo "Done!"
exit 0
