if [ "$1" != "" ]; then
   prog=$(grep $1 index.db | cut -d: -f2)

   if [ "$prog" != "" -a "$prog" == "$1" ]; then
      ver=$(grep $1 index.db | cut -d: -f3)
      ver="${ver%?}"
      echo $ver
   else
      echo "$1 not found!"
      if [ "$(grep $1 index.db | cut -d: -f2)" != "" ]; then
         echo "Similar sounding packages:"
         grep $1 index.db | cut -d: -f2
      fi
   fi
fi
