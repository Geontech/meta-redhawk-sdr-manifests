# Meta-REDHAWK-SDR -based Manifests for OpenEmbedded Development

The purpose of this repository is to make establishing an OpenEmbedded (OE) build environment easier.  These instructions have been adapted from the Ettus Research e300-manifest that was used to build the original REDHAWK on an E310 image found at [Geon Technologies](http://www.geontech.com), the instructions of which can be found in several other repos manifests (Gumstix, etc.) as well.  Most of the adaptations to the instructions were targeted at making them more generic.

## Getting Started

1.  Install Repo.

    Download the Repo script.

        $ curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > repo

    Make it executable.

        $ chmod a+x repo

    Move it on to your system path.

        $ sudo mv repo /usr/local/bin/

2.  Initialize a Repo client.

    Create an empty directory to hold your working files.

        $ mkdir <working directory>
        $ cd <working directory>

    Tell Repo where to find the manifest

        $ repo init -u <git repo> -b <branch> -m <manifest XML name>
    
    For example:
    
        $ repo init -u git://github.com/GeonTech/meta-redhawk-sdr-manifests.git -b krogoth


    A successful initialization will end with a message stating that Repo is
    initialized in your working directory. Your client directory should now
    contain a .repo directory where files such as the manifest will be kept.
    
    > **NOTE:** The `-m` option lets you specify a different manifest file other than the `default.xml`.

    To learn more about the repo manifest format, here is the [documentation](https://gerrit.googlesource.com/git-repo/+/master/docs/manifest-format.txt).

3.  Fetch all the repositories.

        $ repo sync

    This may take upwards of 20 minutes depending on your network connection.

4.  Initialize the OpenEmbedded Environment. This assumes you created the oe-core directory
    in your home directory.

        $ TEMPLATECONF=`pwd`/poky/meta-redhawk-sdr/conf source ./poky/oe-init-build-env ./build ./poky/bitbake


    This copies default configuration information into the build/conf*
    directory and sets up some environment variables for OpenEmbedded.  You may
    wish to edit the configuration options at this point.
    
    > **NOTE:** If you're using manifests other than default, like a REDHAWK one, find your machine in the `meta-redhawk-sdr` (or `meta-redhawk`) `machines` directory for the `TEMPLATECONF` variable above.  This will let you initialize layers as appropriate more quickly.

5.  Build an image.

    This process downloads potentially several hundred megabytes of source code and then proceeds to
    compile several artifacts for each package, so make sure you have plenty of space (25GB
    minimum). Also, it takes a considerable amount of time and RAM (try to have at least 8 GB).

        $ export MACHINE="qemuarm"
        $ bitbake redhawk-gpp-image
    
    Optionally, we have included a script: `meta-redhawk-sdr/contrib/scripts/build-image.sh` that can produce an SD card image.  You provide `MACHINE` and `BUILD_IMAGE` environment variables, and it produces an `images/MACHINE/sd-image-BUILD_IMAGE.direct` file for writing to an SD Card image.  Link the script into your `build` folder, set the variables, and run it.

6.  Run QEMU (optional)
    
    If your build `MACHINE` was `qemuarm`, you can use `runqemu qemuarm` to test the system out (with obvious limitations, of course).  Once it is running, you may need to secure-shell as `root` into the IP address it provided: `ssh root@<IP ADDRESS>`.
    

