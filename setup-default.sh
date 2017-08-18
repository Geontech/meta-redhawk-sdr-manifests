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

# NOTE: The default manifest places all layers, etc., under "poky".
POKYDIR=poky

# Initialize the OpenEmbedded environment (will change into build directory)
TEMPLATECONF=`pwd`/${POKYDIR}/meta-redhawk-sdr/conf source ./${POKYDIR}/oe-init-build-env ./build ./${POKYDIR}/bitbake

# Set the environment variables required for building the image
export MACHINE=qemuarm64
export BUILD_IMAGE=redhawk-test-image

# Done...
echo "Use: 'bitbake redhawk-test-image' to kick off a build."
echo "Optional: set the MACHINE and BUILD_IMAGE variables appropriately and use 'build-image.sh' to generate a two-partition SD card image"
echo "If you ever need to re-establish your environment later, from the top-level project directory:"
echo "  source ./${POKYDIR}/oe-init-build-env ./build ./${POKYDIR}/bitbake"
