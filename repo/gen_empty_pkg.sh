#!/bin/bash
arch=${1%/}
if [ "$arch" == "i386" -o "$arch" == "amd64" -o "$arch" == "python2" -o "$arch" == "python3" -a "$2" != "" -a "$3" != "" ]; then
   echo "Running for $arch:"
   cd "$arch"
   mkdir "$2_v$3" && cd $2_v$3
   echo "Standard display file for $2" > $2_display.txt
   touch $2_install.sh && chmod ugo+x $2_install.sh
   touch nofile
   echo "  remove 'nofile' if binary/script is called $2[.bin/.sh/.py]"
   echo "Done for $arch!"
else
   echo "Usage: $0 [arch] [packagename] [version]"
fi
