#automated install script
#leave settings on default to work!
#ver is either 'lite' or 'full'

pkgfldr=$1
infldr=$2
pkgname=$3
ver=$4

if [ ! -d "$infldr/src" ]; then
   echo "Initial creation of $pkgfldr/src!"
   mkdir "$infldr/src"
   echo "Done!"
fi

if [ ! -d "$infldr/src/$pkgname" ]; then
   echo "Creating $infldr/src/$pkgname..."
   mkdir "$infldr/src/$pkgname"
   echo "Done!"
fi

echo "Copying source code of $pkgname to $infldr/src/$pkgname..."
cp src/* "$infldr/src/$pkgname"
echo "Done!"
