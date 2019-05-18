#!/bin/sh

# Creates the folder where compiling will take place
mkdir work_dir && cd work_dir;

# Downloads and runs bootstrapper to install dependencies
wget https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py;
python bootstrap.py --application-choice=browser --no-interactive;
. $HOME/.cargo/env; # adds the new rust install to PATH

# Clones the firefox source code for compiling
hg clone https://hg.mozilla.org/mozilla-central;

# Extracts our branding to the source code, changing it from firefox to librevixen
cp -r ../source_files/* mozilla-central;

# Bootstraps, builds and packages librevixen
cd mozilla-central;
./mach bootstrap --application-choice=browser --no-interactive; # --application-choice options: browser_artifact_mode/browser/mobile_android_artifact_mode/mobile_android
./mach build;
./mach package;

# moves the packaged tarball to the main folder
cd ../../;
cp ./work_dir/mozilla-central/obj_BUILD_OUTPUT/dist/librevixen*.tar.bz2 ./;

# Adds the librefox config files to the packaged tarball
bzip2 -d ./librevixen*.tar.bz2; 
tar rvf ./librevixen*.tar ../librevixen/*;
bzip2 -z ./librevixen*.tar;

