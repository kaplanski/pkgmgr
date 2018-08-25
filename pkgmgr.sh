#!/bin/bash

#pkgmgr version 0.1 - Copyright 2018 Jan-Daniel Kaplanski
#
#                            Help on Parameters
#mk
#   set mk to your make executable name (make, gmake)
#mkloc
#   is optional to set the location where your make binary is at when not at /bin or /usr/bin
#infldr
#   is your installation folder where pkgmgr puts the binaries (when not using make to install)
#   for standard behaviour set it to /usr/bin or /usr/local/bin
#pkgfldr
#   is the working directory of pkgmgr and is ideally set to /etc/pkgmgr
#   it will auto-create on first run
#repo
#   is the path to the online software repo
#   currently uses wget, could change in the future
#   maybe a sftp or ssh+dd solution
#   ---NO SERVER ONLINE--- 2018-08-23T01:27:00+0200UTC
#   using https://gitup.uni-potsdam.de/kaplanski/pkgmgr/raw/master/repo
#   works (tested) - currently no packages online 2018-08-26T00:38:00+0200UTC
#repoloc
#   local repo path
#   ---DEVELOPMENT ONLY---
#arch
#   your PC's architecture
#   currently supported: i386, amd64
#usr
#   default: $USER (system user identifier)
#   set to "Devloc" to disable "make install" (which needs root)
#   Devloc is for testing purposes only
#   be smart and set pkgfldr and infldr to where you have rwx permission while using Devloc

#Release defaults
mk=make
mkloc=
infldr=/usr/bin
pkgfldr=/etc/pkgmgr
repo=https://gitup.uni-potsdam.de/kaplanski/pkgmgr/raw/master/repo
arch=i386
usr=$USER

#Dev defaults
#mk=make
#mkloc=
#infldr=$PWD/installed
#pkgfldr=$PWD/pkgmgr
#repo=
#repoloc=$PWD/repo
#arch=i386
#usr=$USER

if [ "$usr" == "root" -o "$usr" == "Devloc" ]; then
   if [ ! -d $pkgfldr ]; then
      mkdir $pkgfldr
      echo "Initial pkgfolder created!"
   fi

   if [ ! -f $pkgfldr/index.txt ]; then
      echo "Initial package index download..."
      if [ $repo ]; then
         echo "Using online repo $repo"
         cd $pkgfldr && wget -t=1 $repo/$arch/index.txt
      elif [ $repoloc ]; then
         echo "Using local repo $repoloc"
         dd if=$repoloc/$arch/index.txt of=$pkgfldr/index.txt
      fi
      echo "Done!"
   fi

   if [ "$usr" == "Devloc" ]; then
      echo
      echo "Warning! usr is set to 'Devloc'!"
      echo "'make install' disabled!"
      echo "programs which use make to build and install will fail to install"
      echo
   fi

   if [ "$1" == "" ]; then
      echo "pkgmgr 0.1 - by Jan-Daniel Kaplanski"
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
      if [ $repo ]; then
         echo "Using online repo $repo"
         cd $pkgfldr && wget -t=1 $repo/$arch/index.txt -O index.txt
      elif [ $repoloc ]; then
         echo "Using local repo $repoloc"
         dd if=$repoloc/$arch/index.txt of=$pkgfldr/index.txt
      fi
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
         if [ $repo ]; then
            cd $pkgfldr && wget -t=1 $repo/$arch/$2.tgz 2>/dev/null; isitok=$?
         elif [ $repoloc ]; then
            echo "Using local repo $repoloc"
            dd if=$repoloc/$arch/$2.tgz of=$pkgfldr/$2.tgz 2>/dev/null; isitok=$?
         fi
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
            if [ -f "$mkloc/$mk" -o -f "/bin/$mk" -o -f "/usr/bin/$mk" ]; then
               if [ -f "configure" ]; then
                  echo "configuring $2..."
                  ./configure
                  echo "Done!"
               fi
               echo "Building $2 and installing using make..."
               make 1>/dev/null
               if [ "$usr" != "Devloc" ]; then
                  make install 1>/dev/null
               else
                  echo "Not installed! (disabled due to Devloc)"
                  echo "Run again to install the binary only. (should work, else: install manually)"
               fi
            else
               echo "make not found! Unable to build $2!"
            fi
         else
            echo "No known methode to install package $2! Aborted!"
         fi
      if [ -f "$2-display.txt" ]; then
         cat "$2-display.txt"
      fi
      cd .. && rm -rf $2
      fi
   fi
else
   echo "Run as root!"
fi
