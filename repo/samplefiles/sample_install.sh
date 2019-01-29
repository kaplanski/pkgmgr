#automated install script
#leave settings on default to work!
#ver is either 'lite' or 'full'

pkgfldr=$1
infldr=$2
pkgname=$3

if [ "$4" == "" ]; then
   ver="lite"
else
   ver=$4
fi

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
   echo 'echo "----------------------"' >> $infldr/$pkgname/$pkgname.sh
   echo 'read -p "Enter a number: " num' >> $infldr/$pkgname/$pkgname.sh
   echo 'if [ "$num" == "1" ]; then' >> $infldr/$pkgname/$pkgname.sh
   echo '   exec ./app1' >> $infldr/$pkgname/$pkgname.sh
   echo 'elif [ "$num" == "2" ]; then' >> $infldr/$pkgname/$pkgname.sh
   echo '   exec ./app2' >> $infldr/$pkgname/$pkgname.sh
   echo 'elif [ "$num" == "3" ]; then' >> $infldr/$pkgname/$pkgname.sh
   echo '   exec ./app3' >> $infldr/$pkgname/$pkgname.sh
   echo 'else' >> $infldr/$pkgname/$pkgname.sh
   echo '   echo "Unknown option!"' >> $infldr/$pkgname/$pkgname.sh
   echo 'fi' >> $infldr/$pkgname/$pkgname.sh
   chmod ugo+x $infldr/$pkgname/$pkgname.sh
fi
echo "Done!"
