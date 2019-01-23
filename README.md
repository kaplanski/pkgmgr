# pkgmgr - a package manager written in bash

**pkgmgr** uses standard tools like the bash interpreter, cp and wget combined with  
simple if-statements to give the user a full-blown package manager in return.

*Install instructions:*  
wget https://gitup.uni-potsdam.de/kaplanski/pkgmgr/raw/master/pkgmgr-lite.sh  
chmod ugo+x pkgmgr-lite.sh

*Versions:*  
full: pkgmgr.sh (support dropped, present in i386 repo)  
lite: pkgmgr-lite.sh  

*Features:*
- can install precompiled binary packages, .sh and .py scripts (tar-gz format)  
- can install source-code using GNU make (tar-gz format, dev-version only)  
- easy to adopt other formats/package layouts  
- database of installed packages  
- currently supported architectures: i386, amd64, python2, python3

*Known issues:*
- no dependecy checks  
- aliases - need to restart bash to be loaded after install
  - workaround: "reload-bashrc" alias (auto-created on first startup)  

*Planned:*
- [DONE] a lite version (dev-options and make removed, usable without root access)  
- [DONE] usage of 'DBISshit!'-Format for repo index files  

*Reqired tools:*
- bash interpreter  
- grep (package search)  
- cut (package search)  
- sed (package removal from db when removing a package)  
- wget (index and package download)  

*Package structure for testbinary_v0.1.tgz:*
- testbinary.bin (binary or script with no ending or .bin, .sh or .py)  
  - if no .bin, .sh, .py with packagename is present include an (empty) file  
    called "nofile" ([packagename]_install.sh is REQUIRED)
- OPTIONAL: nofile
- OPTIONAL: testbinary_display.txt (Message to be shown after install has completed)  
- OPTIONAL: testbinary_install.sh (install instructions; REQUIRED if "nofile" is present)  
- OPTIONAL: anything named in _install.sh (like src)  

*WIP Content:*
- package format and handling will be reworked to not use aliases anymore  
- database handling  
- python2 and C ports of pkgmgr-lite  
  - the c port will enventually replace pkgmgr-lite.sh  

**This project has tee-making abilities!**
