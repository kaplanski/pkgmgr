#!/bin/bash
if [ "$1" != "" -a "$2" != "" -a "$3" != "" ]; then
   arch=${1%/}
   if [ "$arch" == "stable" -o "$arch" == "lnx-bin" -o "$arch" == "rpi-bin" -o "$arch" == "freebsd11-bin" ]; then
      echo "Running for $arch:"
      cd "$arch"
      echo "  Creating $2_v$3 folder..."
      mkdir "$2_v$3"; cd $2_v$3
      echo "  Creating $2_display.txt..."
      echo "standard display file for $2" > $2_display.txt
      echo "  Creating $2_install.sh..."
      cp ../../samplefiles/sample_install.sh $2_install.sh
      echo "Done for $arch!"
   else
      echo "Unknown architecture!"
   fi
else
   echo "Usage: $0 [arch] [packagename] [version]"
fi
