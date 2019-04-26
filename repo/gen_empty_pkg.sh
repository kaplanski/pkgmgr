#!/bin/bash
if [ "$1" != "" -a "$2" != "" -a "$3" != "" ]; then
   arch=${1%/}
   if [ "$arch" == "i386" -o "$arch" == "amd64" -o "$arch" == "python2" -o "$arch" == "python3" ]; then
      echo "Running for $arch:"
      cd "$arch"
      echo "  Creating $2_v$3 folder..."
      mkdir "$2_v$3"; cd $2_v$3
      echo "  Creating $2_display.txt..."
      echo "standard display file for $2" > $2_display.txt
      echo "  Creating $2_install.sh..."
      cp ../../samplefiles/sample_install.sh $2_install.sh
      #echo "  Creating nofile..." #depreciated
      #echo "  (remove 'nofile' manually if binary/script is called $2[.bin/.sh/.py])"
      #touch nofile
      echo "Done for $arch!"
   else
      echo "Unknown architecture!"
   fi
else
   echo "Usage: $0 [arch] [packagename] [version]"
fi
