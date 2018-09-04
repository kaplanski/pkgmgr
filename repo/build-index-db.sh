#!/bin/bash
arch=${1%/}
ID_cnt=1
if [ "$arch" == "i386" -o "$arch" == "amd64" -o "$arch" == "python2" -o "$arch" == "python3" ]; then
   echo "Running for $arch:"
   cd "$arch"
   for dir in */; do
      base=$(basename "$dir")
      if [ "$base" != "*" ]; then
         echo "  Building $base..."
         tar -czf "${base}.tgz" "$dir"
         rm -rf "$dir"
      else
         echo "  nothing to build..."
      fi
   done

   if [ -f index.db ]; then
      echo "  removing old index..."
      rm index.db
   fi

   echo "[ID:Name:Version]" >> index.db

   for f in *_v*.tgz; do
      if [ "$f" != "*_v*.tgz" ]; then
         p_ver="${f#*_v}"
         ver="${p_ver%.tgz}"
         echo "{$ID_cnt:${f%_v*}:$ver}" >> index.db 2>/dev/null
         ID_cnt=$(($ID_cnt + 1))
      fi
   done
   echo "  new index created!"
   echo "Done for $arch!"
else
   echo "unknown architecture!"
fi
