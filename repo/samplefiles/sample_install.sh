#automated install script
#leave settings on default to work!
#ver is either 'lite' or 'full'

pkgfldr=$1
infldr=$2
pkgname=$3
ver=$4

if [ ! -d "$infldr/$pkgname" ]; then
   echo "Initial creation of $pkgfldr/$pkgname!"
   mkdir "$infldr/$pkgname"
   echo "Done!"
fi

echo "Installing $pkgname..."
cp * "$infldr/$pkgname"

if [ "$ver" == "lite" ]; then
   echo '#!/usr/bin/env bash' > $infldr/$pkgname/$pkgname.sh
   echo 'echo "Choose an application:"' >> $infldr/$pkgname/$pkgname.sh
   #echo 'echo "   1. APP"' >> $infldr/$pkgname/$pkgname.sh
   #echo 'echo "   2. APP"' >> $infldr/$pkgname/$pkgname.sh
   #echo 'echo "   3. APP"' >> $infldr/$pkgname/$pkgname.sh
   #just add your apps to this list
fi
echo "Done!"
