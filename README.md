# pkgmgr - a package manager written in bash

pkgmgr uses standard tools like the bash interpreter, cp and wget combined with  
simple if-statements to give the user a full-blown package manager in return.

Features:
- can install precompiled binary packages (tar-gz format)  
- can install source-code using GNU make (tar-gz format)  
- easy to adopt other formats/package layouts

Known issues:
- no list/database of installed packages  
- repo index files are plain-text, not database files

Planned:
- .deb support  
- [DONE] a lite version (dev-options and make removed, usable without root access)

**This project has tee-making abilities!**
