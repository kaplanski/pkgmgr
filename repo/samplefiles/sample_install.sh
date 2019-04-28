#automated install script
#leave settings on default to work!
#$ver is either 'lite' or 'full' (old bash pkgmgr versions)

pkgfldr=$1 # pkgmgr folder. default: $HOME/pkgmgr
infldr=$2 # bin folder. default: $HOME/pkgmgr/bin
pkgname=$3 # pkgname (if pkg=abc_v0.1b.tgz; then pkgname=abc)

#create pkg folder in $HOME/pkgmgr/bin
if [ ! -d "$infldr/$pkgname" ]; then
   echo "Initial creation of $infldr/$pkgname!"
   mkdir "$infldr/$pkgname"
   echo "Done!"
fi

#place your install instructions here (i.e. cp)
cp * "$infldr/$pkgname"
