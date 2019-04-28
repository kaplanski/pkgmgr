#automated install script
#leave settings on default to work!
#ver is either 'lite' or 'full'

pkgfldr=$1
infldr=$2
pkgname=$3

#if [ "$4" == "" ]; then #depreciated
#   ver="lite"
#else
#   ver=$4
#fi

if [ ! -d "$infldr/$pkgname" ]; then
   echo "Initial creation of $pkgfldr/$pkgname!"
   mkdir "$infldr/$pkgname"
   echo "Done!"
fi

#echo "Installing $pkgname..." #depreciated
cp * "$infldr/$pkgname"

#echo "Done!" depreciated
