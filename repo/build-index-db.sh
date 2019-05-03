#!/usr/bin/env bash
arch=${1%/}

if [ "$arch" == "stable" ]; then

   echo "Running for $arch:"
   cd "$arch"

   #get last ID
   if [ ! -f "index.db" ]; then
      ID_cnt=1
      echo "[ID:Name:Version:Dependencies]" >> index.db
   else
      ID_cnt=$(( $(tail -n 1 "index.db" | cut -d ":" -f 1 | cut -d "{" -f 2) + 1 ))
   fi

   for dir in */; do
      base=$(basename "$dir")
      if [ "$base" != "*" ]; then
         #building package
         echo "  Building $base..."
         tar -czf "${base}.tgz" "$dir"
         rm -rf "$dir"

         #generating index
         p_ver="${dir#*_v}"
         ver="${p_ver%/}"
         echo "Enter dependencies for ${dir%_v*} (or leave blank; delim: ,) [ENTER]:"; read deps
         echo "{$ID_cnt:${dir%_v*}:$ver:$deps}" >> index.db 2>/dev/null
         ID_cnt=$(($ID_cnt + 1))

         #hashing
         ../hashme "${base}.tgz" > "${base}.sha3"
      else
         echo "  nothing to build..."
         echo "Done for $arch!"
         exit 1
      fi
   done
   echo "  new index created!"
   echo "Done for $arch!"
else
   echo "unknown architecture!"
fi
