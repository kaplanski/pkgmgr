pkgfldr=$1
infldr=$2
pkgname=$3

if [ ! -d "$pkgfldr/src" ]; then
   echo "Initial creation of $pkgfldr/src!"
   mkdir "$pkgfldr/src"
   echo "Done!"
fi

if [ ! -d "$pkgfldr/src/$pkgname" ]; then
   echo "Creating $pkgfldr/src/$pkgname..."
   mkdir "$pkgfldr/src/$pkgname"
   echo "Done!"
fi

echo "Copying source code of $pkgname to $pkgfldr/src/$pkgname..."
cp src/* "$pkgfldr/src/$pkgname"
echo "Done!"
