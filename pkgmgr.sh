#!/bin/bash

#pkgmgr version 0.1b - Copyright 2018 Jan-Daniel Kaplanski
#
#                Help on Parameters
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
#   currently uses wget -q, could change in the future
#   maybe a sftp or ssh+dd solution
#   ---NO SERVER ONLINE--- 2018-08-23T01:27:00+0200UTC
#   using https://gitup.uni-potsdam.de/kaplanski/pkgmgr/raw/master/repo
#   works (tested) - currently no packages online 2018-08-26T00:38:00+0200UTC
#repoloc
#   local repo path
#   ---DEVELOPMENT ONLY---
#arch
#   your PC's architecture
#   currently supported: i386, amd64, python2, python3
#usr
#   default: $USER (system user identifier)
#   set to "Devloc" to disable "make install" (which needs root)
#   Devloc is for testing purposes only
#   be smart and set pkgfldr and infldr to where you have rwx permission while using Devloc

#Release defaults
#mk=make
#mkloc=
#infldr=/usr/bin
#pkgfldr=/etc/pkgmgr
#ARCHfldr=ARCH
#repo=https://gitup.uni-potsdam.de/kaplanski/pkgmgr/raw/master/repo
#arch=i386
#usr=$USER

#Dev defaults
mk=make
mkloc=
pkgfldr=$PWD/pkgmgr
infldr=$pkgfldr/bin
ARCHfldr=ARCH
repo=
repoloc=$PWD/repo
arch=i386
usr=$USER

if [ "$usr" != "root" -a "$usr" != "Devloc" ]; then
   echo "Run as root!"
   exit 0
fi
if [ ! -d $pkgfldr ]; then
   mkdir $pkgfldr
   echo "Initial pkgfolder created!"
fi

if [ ! -d $infldr ]; then
   mkdir $infldr
   echo "Initial infolder created!"
fi

if [ ! -d $pkgldr/$ARCHfldr ]; then
   mkdir $pkgfldr/$ARCHfldr
   echo "Initial archive folder created!"
fi

if [ ! -d $pkgldr/src ]; then
   mkdir $pkgfldr/src
   echo "Initial src folder created!"
fi

if [ ! -f $pkgfldr/installed_$arch.db ]; then
   echo "[PKGID:Name:Version]" > $pkgfldr/installed_$arch.db
   echo "Initial installed_$arch.db created!"
fi

if [ ! -f $pkgfldr/index_$arch.db ]; then
   echo "Initial package index download..."
if [ "$repo" != "" ]; then
   echo "Using online repo $repo"
   cd $pkgfldr && wget -q -t 1 $repo/$arch/index_$arch.db
elif [ "$repoloc" != "" ]; then
   echo "Using local repo $repoloc"
   dd if=$repoloc/$arch/index.db of=$pkgfldr/index_$arch.db
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
   echo "pkgmgr 0.1b - by Jan-Daniel Kaplanski"
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
   if [ "$repo" != "" ]; then
      echo "Using online repo $repo"
      cd $pkgfldr && wget -q -t 1 $repo/$arch/index.db -O index_$arch.db
   elif [ "$repoloc" != "" ]; then
      echo "Using local repo $repoloc"
      dd if=$repoloc/$arch/index.db of=$pkgfldr/index_$arch.db
   fi
   echo "Done!"
elif [ "$1" == "-s" -o "$1" == "--search" ]; then
   if [ "$2" == "" ]; then
      echo "Empty request!"
   else
      grep "$2" "$pkgfldr"/index.db | cut -d: -f2
   fi
elif [ "$1" == "-r" -o "$1" == "--remove" ]; then
   if [ -f "$infldr/$2" ]; then
      rm -ri $infldr/$2
      echo "Done!"
   else
      echo "Package $2 not installed! Aborted!"
   fi
elif [ "$1" == "-c" -o "$1" == "--clean" ]; then
   echo "Removing any downloaded packages from cache..."
   cd $pkgfldr && rm -rf *.tgz 2>/dev/null
   echo "Done!"
elif [ "$1" == "-i" -o "$1" == "--install" -a "$2" != "" ]; then
   prog=$(grep $2 $pkgfldr/index_$arch.db | cut -d: -f2)
   if [ "$prog" != "" -a "$prog" == "$2" ]; then
      ver=$(grep $2 $pkgfldr/index_$arch.db | cut -d: -f3)
      ver="${ver%?}"
      if [ ! -f "$pkgfldr/$ARCHfldr/$2_v$ver.tgz" ]; then
         echo "Downloading..."
         if [ $repo ]; then
            cd $pkgfldr/$ARCHfldr && wget -q -t 1 $repo/$arch/$2_v$ver.tgz
         elif [ $repoloc ]; then
            echo "Using local repo $repoloc"
            dd if=$repoloc/$arch/$2_v$ver.tgz of=$pkgfldr/$ARCHfldr/$2_v$ver.tgz 2>/dev/null
         fi
      fi
      if [ -f "$pkgfldr/$ARCHfldr/$2_v$ver.tgz" ]; then
         echo "Unpacking..."
         cd $pkgfldr/$ARCHfldr && tar -xzf $2_v$ver.tgz && cd $2_v$ver
         if [ ! -d "$infldr/$2" ]; then
            mkdir $infldr/$2
         else
            echo "Removing previous version..."
            rm -rf $infldr/$2/*
            echo "Done!"
         fi
         echo "Installing $2..."
      elif [ -f "$2" -o -f "$2.bin" -o -f "$2.sh" -o -f "$2.py" ]; then
         if [ ! -f "nofile" ]; then
            if [ -f "$2" ]; then
               cp $2 $infldr/$2/$2
            elif [ -f "$2.bin" ]; then
               cp $2.bin $infldr/$2/$2
            elif [ -f "$2.sh" ]; then
               cp $2.sh $infldr/$2/$2
            elif [ -f "$2.py" ]; then
               cp $2.sh $infldr/$2/$2
            elif [ -f "nofile" ]; then
               echo "Multibinary archive"
            fi
         fi
         if [ -f "$2_install.sh" ]; then
            ./$2_install.sh $pkgfldr $infldr $2 full
         fi
         if [ -f "$2-display.txt" ]; then
            cat "$2-display.txt"
         fi
         if [ "$(grep $2 $pkgfldr/installed_$arch.db)" != "$(grep $2 $pkgfldr/index_$arch.db)" ]; then
            echo $(grep $2 $pkgfldr/index_$arch.db) >> $pkgfldr/installed_$arch.db
         fi
         echo "$2 installed sucessfully!"
      elif [ -f "nofile" ]; then
         if [ -f "$2_install.sh" ]; then
            ./$2_install.sh $pkgfldr $infldr $2 full
         fi
         if [ -f "$2-display.txt" ]; then
            cat "$2-display.txt"
         fi
         if [ "$(grep $2 $pkgfldr/installed_$arch.db)" != "$(grep $2 $pkgfldr/index_$arch.db)" ]; then
            echo $(grep $2 $pkgfldr/index_$arch.db) >> $pkgfldr/installed_$arch.db
         fi
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
      cd .. && rm -rf $2_v$arch
   else
      echo "$2 not found!"
      if [ "$(grep $2 $pkgfldr/index_$arch.db | cut -d: -f2)" != "" ]; then
         echo "Similar sounding packages:"
         grep $2 $pkgfldr/index_$arch.db | cut -d: -f2
      else
         echo "No similar sounding packages found!"
      fi
   fi
fi
