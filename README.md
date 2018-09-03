# pkgmgr - a package manager written in bash

**development SUSPENDED**  
Due to active development on 'DBISshit!' this project is halted!  
An adaptation of the 'DBISshit!'-Format DB is planned for repo index files.  
Until 'DBISshit!' has got a non-interactive version this project (pkgmgr) will remain halted!  

pkgmgr uses standard tools like the bash interpreter, cp and wget combined with  
simple if-statements to give the user a full-blown package manager in return.

Features:
- can install precompiled binary packages, .sh and .py scrips (tar-gz format)  
- can install source-code using GNU make (tar-gz format)  
- easy to adopt other formats/package layouts

Known issues:
- no list/database of installed packages  
- repo index files are plain-text, not database files  
- no dependecy checks

Planned:
- .deb support  
- [DONE] a lite version (dev-options and make removed, usable without root access)  
- usage of 'DBISshit!' for repo index files

Package structure for testbinary.tgz:
- testbinary.bin (binary or script with no ending or .bin, .sh or .py)  
- OPTIONAL: testbinary-display.txt (Message to be shown after install has completed)  
- OPTIONAL: testbinary-install.sh (instuctions other than to copy the binary, e.g. for libaries instead)

**This project has tee-making abilities!**
