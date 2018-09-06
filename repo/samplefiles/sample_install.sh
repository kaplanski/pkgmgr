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

#if [ "$ver" == "lite" ]; then
#   echo "alias [name]=$infldr/$pkgname/[file]" >> $infldr/$pkgname/.alias.sh
#   chmod ugo+x $infldr/$pkgname/.alias.sh
#   echo "unalias [name]" >> $infldr/$pkgname/.uninstall.sh
#fi
echo "Done!"
