#!/bin/bash

#pkgmgr version 0.1cL - Copyright 2018 Jan-Daniel Kaplanski
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
#   currently supported: i386, amd64, python2, python3

#Release defaults
#infldr=~/pkgmgr/bin
#pkgfldr=~/pkgmgr
#ARCHfldr=ARCH
#repo=https://gitup.uni-potsdam.de/kaplanski/pkgmgr/raw/master/repo
#arch=i386

#my config
infldr=~/pkgmgr/bin
pkgfldr=~/pkgmgr
ARCHfldr=ARCH
repo=https://gitup.uni-potsdam.de/kaplanski/pkgmgr/raw/master/repo
arch=i386

if [ "$infldr" == "" -o "$pkgfldr" == "" -o "$ARCHfldr" == "" -o "$repo" == "" -o "$arch" == "" ]; then
   echo "Check config!"
   exit 42
fi

if [ "$USER" == "root" ]; then
   echo "No need to run as root."
fi

if [ ! -d $pkgfldr ]; then
   mkdir $pkgfldr
   echo "Initial pkgfolder created!"
fi

if [ ! -d $pkgfldr/src ]; then
   mkdir $pkgfldr/src
   echo "Initial srcfolder created!"
fi

if [ ! -d $infldr ]; then
   mkdir $infldr
   echo "Initial infldr created!"
fi

if [ ! -d $pkgfldr/$ARCHfldr ]; then
   mkdir $pkgfldr/$ARCHfldr
   echo "Initial archive folder created!"
fi

if [ ! -f $pkgfldr/installed_$arch.db ]; then
   echo "[PKGID:Name:Version]" > $pkgfldr/installed_$arch.db
   echo "Initial installed_$arch.db created!"
fi

if [ ! -f $pkgfldr/index_$arch.db ]; then
   echo "Initial package index download for $arch..."
   echo "Using online repo $repo"
   cd $pkgfldr && wget -q -t 1 $repo/$arch/index.db -O index_$arch.db
   echo "Done!"
fi

if [ "$1" == "" ]; then
   echo "pkgmgr 0.1cL - by Jan-Daniel Kaplanski"
   echo "try '$0 -h' for help"
elif [ "$1" == "-h" -o "$1" == "--help" ]; then
   echo "Usage: pkgmgr [-c|-da|-di|-h|-i|-r|-s|-u] [pkg]"
   echo "   -c: (--clean) cleans the package folder of downloaded packages"
   echo "   -h: (--help) displays this help"
   echo "   -u: (--update) updates the package index"
   echo "   -i [pkg]: (--install) installs a package (-ri: reinstall)"
   echo "   -r [pkg]: (--remove) removes a package"
   echo "   -s [pkg]: (--search) searches for a package in the package index"
   echo "  -da: (--displayall) list all available packages for $arch"
   echo "  -di: (--displayinstalled) list all installed packages for $arch"
   echo "Current binary folder: $infldr"
   echo "Current pkgmgr folder: $pkgfldr"
   echo "Current architecture: $arch"
elif [ "$1" == "-u" -o "$1" == "--update" ]; then
   echo "Updating package index..."
   echo "Using online repo $repo"
   cd $pkgfldr && wget -q -t 1 $repo/$arch/index.db -O index_$arch.db
   echo "Done!"
elif [ "$1" == "-s" -o "$1" == "--search" ]; then
   if [ "$2" == "" ]; then
      echo "Empty request!"
   else
      grep "$2" $pkgfldr/index_$arch.db | cut -d: -f2
   fi
elif [ "$1" == "-da" -o "$1" == "--displayall" ]; then
   echo "Available packages for $arch:"
   grep { $pkgfldr/index_$arch.db | cut -d: -f2
elif [ "$1" == "-di" -o "$1" == "--displayinstalled" ]; then
   echo "Installed packages for $arch:"
   grep { $pkgfldr/installed_$arch.db | cut -d: -f2
elif [ "$1" == "-r" -o "$1" == "--remove" ]; then
   if [ "$(grep $2 $pkgfldr/index_$arch.db | cut -d: -f2)" ==  "$2" -a -d "$infldr/$2" ]; then
      echo "Removing $2..."
      if [ -f $infldr/$2/.uninstall.sh ]; then
         chmod ugo+x $infldr/$2/.uninstall.sh
         source $infldr/$2/.uninstall.sh
      fi
      rm -rf $infldr/$2
      if [ -d $pkgfldr/src/$2 ]; then
         rm -rf $pkgfldr/src/$2
      fi
      sed -i "/$(grep $2 $pkgfldr/index_$arch.db)/d" $pkgfldr/installed_$arch.db
      sed -i "/$(grep $2 ~/.bashrc)/d" ~/.bashrc
      echo "Done!"
   else
      echo "Package $2 not installed! Aborted!"
   fi
elif [ "$1" == "-c" -o "$1" == "--clean" ]; then
   echo "Removing any downloaded packages from cache..."
   cd $pkgfldr/$ARCHfldr && rm -rf * 2>/dev/null
   echo "Done!"
elif [ "$1" == "-i" -o "$1" == "--install" -o "$1" == "-ri" -a "$2" != "" ]; then
   prog=$(grep $2 $pkgfldr/index_$arch.db | cut -d: -f2)
   if [ "$1" == "-ri" -a "$2" != "$(grep $2 $pkgfldr/installed_$arch.db | cut -d: -f2)" ]; then
      echo "$2 not installed! Aborting reinstall!"
      exit 2
   fi
   if [ "$prog" != "" -a "$prog" == "$2" ]; then
      ver=$(grep $2 $pkgfldr/index_$arch.db | cut -d: -f3)
      ver="${ver%?}"
      if [ ! -f "$pkgfldr/$ARCHfldr/$2_v$ver.tgz" ]; then
         echo "Downloading..."
         cd $pkgfldr/$ARCHfldr && wget -q -t 1 $repo/$arch/$2_v$ver.tgz
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
         if [ -f "$2" -o -f "$2.bin" -o -f "$2.sh" -o -f "$2.py" ]; then
            if [ "$1" != "-ri" ]; then
               echo "source $infldr/$2/.alias.sh" >> ~/.bashrc
            fi
            if [ ! -f "nofile" ]; then
               if [ -f "$2" ]; then
                  cp $2 $infldr/$2/$2
               elif [ -f "$2.bin" ]; then
                  cp $2.bin $infldr/$2/$2
               elif [ -f "$2.sh" ]; then
                  cp $2.sh $infldr/$2/$2
               elif [ -f "$2.py" ]; then
                  cp $2.py $infldr/$2/$2
               fi
               echo "alias $2=$infldr/$2/$2" >> $infldr/$2/.alias.sh
               chmod ugo+x $infldr/$2/.alias.sh
               echo "unalias $2" >> $infldr/$2/.uninstall.sh
            fi
            if [ -f "$2_install.sh" ]; then
               ./$2_install.sh $pkgfldr $infldr $2 lite
            fi
            if [ -f "$2_display.txt" ]; then
               echo ""
               cat "$2_display.txt"
               echo ""
            fi
            if [ "$(grep $2 $pkgfldr/installed_$arch.db)" != "$(grep $2 $pkgfldr/index_$arch.db)" ]; then
               echo $(grep $2 $pkgfldr/index_$arch.db) >> $pkgfldr/installed_$arch.db
            fi
            echo "$2 installed sucessfully!"
         elif [ -f "nofile" ]; then
            if [ -f "$2_install.sh" ]; then
               ./$2_install.sh $pkgfldr $infldr $2 lite
            fi
            if [ -f "$2_display.txt" ]; then
               echo ""
               cat "$2_display.txt"
               echo ""
            fi
            if [ "$(grep $2 $pkgfldr/installed_$arch.db)" != "$(grep $2 $pkgfldr/index_$arch.db)" ]; then
               echo $(grep $2 $pkgfldr/index_$arch.db) >> $pkgfldr/installed_$arch.db
            fi
            echo "$2 installed sucessfully!"
         elif [ -f "configure" -o -f "Makefile" ]; then
            echo "$2 is not supported by the lite version of pkgmgr!"
         else
            echo "No known methode to install package $2! Aborted!"
         fi
         cd .. && rm -rf $2_v$ver
      fi
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
exit 0
