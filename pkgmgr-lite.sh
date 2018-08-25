#!/bin/bash

#pkgmgr version 0.1L - Copyright 2018 Jan-Daniel Kaplanski
#based on pkgmgr version 0.1a
#
#                            Help on Parameters
#infldr
#   is your installation folder where pkgmgr puts the binaries
#   for standard behaviour set it to ~/pkgmgr/bin
#pkgfldr
#   is the working directory of pkgmgr and is ideally set to ~/pkgmgr
#   it will auto-create on first run
#repo
#   is the path to the online software repo
#   using https://gitup.uni-potsdam.de/kaplanski/pkgmgr/raw/master/repo
#arch
#   your PC's architecture
#   currently supported: i386, amd64

#Release defaults
infldr=~/pkgmgr/bin
pkgfldr=~/pkgmgr
repo=https://gitup.uni-potsdam.de/kaplanski/pkgmgr/raw/master/repo
arch=i386

if [ "$USER" == "root" ]; then
   echo "No need to run as root."
fi

if [ ! -d $pkgfldr ]; then
   mkdir $pkgfldr
   echo "Initial pkgfolder created!"
fi

if [ ! -d $infldr ];then
   mkdir $infldr
   echo "Initial infldr created!"
fi

if [ ! -f $pkgfldr/index.txt ]; then
   echo "Initial package index download..."
   echo "Using online repo $repo"
   cd $pkgfldr && wget -t=1 $repo/$arch/index.txt
   echo "Done!"
fi

if [ "$1" == "" ]; then
   echo "pkgmgr 0.1a - by Jan-Daniel Kaplanski"
   echo "try '$0 -h' for help"
elif [ "$1" == "-h" -o "$1" == "--help" ]; then
   echo "Usage: pkgmgr [-c|-h|-i|-r|-s|-u] [pkg]"
   echo "   -c: (--clean) cleans the package folder of downloaded packages"
   echo "   -h: (--help) displays this help"
   echo "   -u: (--update) updates the package index"
   echo "   -i [pkg]: (--install) installs a package"
   echo "   -r [pkg]: (--remove) removes a package"
   echo "   -s [pkg]: (--search) searches for a package in the package index"
   echo "Current binary folder: $infldr"
   echo "Current pkgmgr folder: $pkgfldr"
elif [ "$1" == "-u" -o "$1" == "--update" ]; then
   echo "Updating package index..."
   echo "Using online repo $repo"
   cd $pkgfldr && wget -t=1 $repo/$arch/index.txt -O index.txt
   echo "Done!"
elif [ "$1" == "-s" -o "$1" == "--search" ]; then
   cat $pkgfldr/index.txt | grep $2; isitin=$?
   if [ "$isitin" != "0" ]; then
      echo "Package $2 not found!"
   fi
elif [ "$1" == "-r" -o "$1" == "--remove" ]; then
   if [ -f "$infldr/$2" ]; then
      rm -ri $infldr/$2
      echo "Done!"
   else
      echo "Package $2 not installed! Aborted!"
   fi
elif [ "$1" == "-c" -o "$1" == "--clean" ]; then
   echo "Removing any downloaded packages..."
   cd $pkgfldr && rm -rf *.tgz 2>/dev/null
   echo "Done!"
elif [ "$1" == "-i" -o "$1" == "--install" ]; then
   if [ ! -f "$pkgfldr/$2.tgz" ]; then
      echo "Downloading..."
      cd $pkgfldr && wget -t=1 $repo/$arch/$2.tgz 2>/dev/null; isitok=$?
      if [ "$isitok" != "0" ]; then
         echo "Package $2 not found on repo!"
      fi
   fi
   if [ -f "$pkgfldr/$2.tgz" ]; then
      echo "Unpacking..."
      cd $pkgfldr && tar -xzf $2.tgz && cd $2
      echo "Installing $2..."
      if [ -f "$2" ]; then
         cp $2 $infldr/$2
         echo "$2 installed sucessfully!"
      elif [ -f "$2.bin" ]; then
         cp $2.bin $infldr/$2
         echo "$2 installed sucessfully!"
      elif [ -f "configure" -o -f "Makefile" ]; then
         echo "$2 is not supported by the light version of the installer."
      else
         echo "No known methode to install package $2! Aborted!"
      fi
      if [ -f "$2-display.txt" ]; then
         cat "$2-display.txt"
      fi
      cd .. && rm -rf $2
   fi
fi
