#!/bin/bash

# This is a basic setup script for using th default repo manifest.  Feel free to modify/extend
# for your own platforms.

if ! [ -x "$(hash repo 2>/dev/null)" ]; then
    echo "Google's repo is not installed.  Attempting to do it for you..." >&2
    curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > repo
    chmod a+x repo
    sudo mv repo /usr/local/bin
fi

# The repo initialization and sync. Point these at your manifest.xml file.
# Ex: repo init -u <git repo> -b <branch> -m <manifest other than default.xml>
repo init -u git://github.com/geontech/meta-redhawk-sdr-manifests.git    
repo sync

# Initialize the OpenEmbedded environment (will change into build directory)
TEMPLATECONF=`pwd`/meta-redhawk-sdr/conf source ./oe-core/oe-init-build-env ./build ./bitbake

# Link the build_image script from meta-redhawk-sdr into the build directory
ln -s `pwd`/../meta-redhawk-sdr/contrib/scripts/build-image.sh ./build-image.sh

# Set the environment variables required for building the image
export MACHINE=zedboard-zynq7
export BUILD_IMAGE=redhawk-base-image

# Done...
echo "Use: 'bitbake redhawk-base-image' to kick off a build."
echo "Optional: set the MACHINE and BUILD_IMAGE variables appropriately and use 'build-image.sh' to generate a two-partition SD card image"
