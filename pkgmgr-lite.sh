#!/bin/bash

#pkgmgr version 0.1cL - Copyright 2018 Jan-Daniel Kaplanski
#based on pkgmgr version 0.1a
#
#                            Help on Parameters
#infldr
#   is your installation folder where pkgmgr puts the binaries
#   for standard behaviour set it to $HOME/pkgmgr/bin
#pkgfldr
#   is the working directory of pkgmgr and is ideally set to $HOME/pkgmgr
#   it will auto-create on first run
#repo
#   is the path to the online software repo
#   using https://gitup.uni-potsdam.de/kaplanski/pkgmgr/raw/master/repo
#arch
#   your PC's architecture
#   currently supported: i386, amd64, python2, python3

#Release defaults
#infldr=$HOME/pkgmgr/bin
#pkgfldr=$HOME/pkgmgr
#ARCHfldr=ARCH
#repo=https://gitup.uni-potsdam.de/kaplanski/pkgmgr/raw/master/repo
#arch=

#my config
infldr=$HOME/pkgmgr/bin
pkgfldr=$HOME/pkgmgr
ARCHfldr=ARCH
repo=https://gitup.uni-potsdam.de/kaplanski/pkgmgr/raw/master/repo
arch=

if [ "$infldr" == "" -o "$pkgfldr" == "" -o "$ARCHfldr" == "" -o "$repo" == "" ]; then
   echo "Check config!"
   exit 42
fi

if [ "$arch" == "" -a "$1" != "-ca" ]; then
   echo "Run '$0 -ca [arch]' to set your architecture!"
   echo "Available architectures: i386, amd64, python2, python3"
   exit 255
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

if [ ! -f $pkgfldr/.aliases.sh ]; then
   echo "#alias list file for pkgmgr" > $pkgfldr/.aliases.sh
   chmod ugo+x $pkgfldr/.aliases.sh
   if [ "$(grep $pkgfldr $HOME/.bashrc)" != "source $pkgfldr/.aliases.sh" ]; then
      echo "source $pkgfldr/.aliases.sh" >> $HOME/.bashrc
      echo 'alias reload-bashrc="source $HOME/.bashrc"' >> $HOME/.bashrc
   fi
   echo "Initial aliases file created!"
fi

if [ ! -f $pkgfldr/installed_$arch.db -a "$1" != "-ca" ]; then
   echo "[PKGID:Name:Version]" > $pkgfldr/installed_$arch.db
   echo "Initial installed_$arch.db created!"
fi

if [ ! -f $pkgfldr/index_$arch.db -a "$1" != "-ca" ]; then
   echo "Initial package index download for $arch..."
   echo "Using online repo $repo"
   cd $pkgfldr && wget -q -t 1 $repo/$arch/index.db -O index_$arch.db
   echo "Done!"
fi

if [ "$1" == "" ]; then
   echo "pkgmgr 0.1cL - by Jan-Daniel Kaplanski"
   echo "try '$0 -h' for help"
elif [ "$1" == "-h" ]; then
   echo "Usage: pkgmgr [-c|-da|-di|-h|-i|-r|-s|-u] [pkg]"
   echo "   -c: cleans the package folder of downloaded packages"
   echo "   -h: displays this help"
   echo "   -u: updates the package index"
   echo "   -i [pkg]: installs a package (-ri: reinstall)"
   echo "   -r [pkg]: removes a package"
   echo "   -s [pkg]: searches for a package in the package index"
   echo "  -da: list all available packages for $arch"
   echo "  -di: list all installed packages for $arch"
   echo "  -ca [arch]: change your architecture"
   echo "Current binary folder: $infldr"
   echo "Current pkgmgr folder: $pkgfldr"
   echo "Current architecture: $arch"
elif [ "$1" == "-u" ]; then
   echo "Updating package index..."
   echo "Using online repo $repo"
   cd $pkgfldr && wget -q -t 1 $repo/$arch/index.db -O index_$arch.db
   echo "Done!"
elif [ "$1" == "-ca" ]; then
   if [ "$2" == "i386" ]; then
      echo "Set arch to i386!"
      sed -i "32 s#arch=$arch#arch=i386#" $0
      exit 1337
   elif [ "$2" == "amd64" ]; then
      echo "Set arch to amd64!"
      sed -i "32 s#arch=$arch#arch=amd64#" $0
      exit 1337
   elif [ "$2" == "python2" ]; then
      echo "Set arch to python2!"
      sed -i "32 s#arch=$arch#arch=python2#" $0
      exit 1337
   elif [ "$2" == "python3" ]; then
      echo "Set arch to python3!"
      sed -i "32 s#arch=$arch#arch=python3#" $0
      exit 1337
   else
      echo "Available architectures: i386, amd64, python2, python3"
      echo "Unknown architecture!"
      exit 255
   fi
elif [ "$1" == "-s" ]; then
   if [ "$2" == "" ]; then
      echo "Empty request!"
   else
      grep "$2" $pkgfldr/index_$arch.db | cut -d: -f2
   fi
elif [ "$1" == "-da" ]; then
   echo "Available packages for $arch:"
   grep { $pkgfldr/index_$arch.db | cut -d: -f2
elif [ "$1" == "-di" ]; then
   echo "Installed packages for $arch:"
   grep { $pkgfldr/installed_$arch.db | cut -d: -f2
elif [ "$1" == "-r" ]; then
   if [ "$(grep $2 $pkgfldr/index_$arch.db | cut -d: -f2)" ==  "$2" -a -d "$infldr/$2" ]; then
      echo "Removing $2..."
      if [ -f $infldr/$2/.uninstall.sh ]; then
         chmod ugo+x $infldr/$2/.uninstall.sh
         $infldr/$2/.uninstall.sh
      fi
      rm -rf $infldr/$2
      if [ -d $pkgfldr/src/$2 ]; then
         rm -rf $pkgfldr/src/$2
      fi
      sed -i "s#$(grep $2 $pkgfldr/index_$arch.db)##g" $pkgfldr/installed_$arch.db
      sed -i "s#$(grep $2 $pkgfldr/.aliases.sh)##g" $pkgfldr/.aliases.sh
      echo "Done!"
   else
      echo "Package $2 not installed! Aborted!"
   fi
elif [ "$1" == "-c" ]; then
   echo "Removing any downloaded packages from cache..."
   cd $pkgfldr/$ARCHfldr && rm -rf * 2>/dev/null
   echo "Done!"
elif [ "$1" == "-i" -o "$1" == "-ri" -a "$2" != "" ]; then
   prog=$(grep $2 $pkgfldr/index_$arch.db | cut -d: -f2)
   if [ "$prog" != "" ]; then
      if [ "$1" == "-i" -a "$2" == "$(grep $2 $pkgfldr/installed_$arch.db | cut -d: -f2)" ]; then
         echo "$2 is already installed! Aborting install..."
         exit 2
      elif [ "$1" == "-ri" -a "$2" != "$(grep $2 $pkgfldr/installed_$arch.db | cut -d: -f2)" ]; then
         echo "$2 is not installed! Aborting reinstall..."
         exit 2
      fi
      if [ "$(grep $2 $pkgfldr/.aliases.sh)" != "source $infldr/$2/.alias.sh" ]; then
         echo "source $infldr/$2/.alias.sh" >> $pkgfldr/.aliases.sh
      fi
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
