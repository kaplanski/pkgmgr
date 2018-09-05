# pkgmgr - a package manager written in bash

**pkgmgr** uses standard tools like the bash interpreter, cp and wget combined with  
simple if-statements to give the user a full-blown package manager in return.

*Features:*
- can install precompiled binary packages, .sh and .py scrips (tar-gz format)  
- can install source-code using GNU make (tar-gz format)  
- easy to adopt other formats/package layouts  
- database of installed packages (lite version only - wip for full ver)  
- currently supported architectures: i386, amd64, python2, python3

*Known issues:*
- no dependecy checks  

*Planned:*
- [DONE] a lite version (dev-options and make removed, usable without root access)  
  - support for main version (pkgmgr.sh) is dropped  
    it is present in the i386 and amd64 repo  
- [DONE] usage of 'DBISshit!' for repo index files

*Package structure for testbinary_v0.1.tgz:*
- testbinary.bin (binary or script with no ending or .bin, .sh or .py)  
  - if no .bin, .sh, .py with packagename is present include an (empty) file  
    called "nofile" ([packagename]_install.sh is REQUIRED)
- OPTIONAL: testbinary_display.txt (Message to be shown after install has completed)  
- OPTIONAL: testbinary_install.sh (install instructions; REQUIRED if "nofile" is present)

**This project has tee-making abilities!**
