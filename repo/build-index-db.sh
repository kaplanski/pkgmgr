#!/usr/bin/env bash
arch=${1%/}
if [ "$arch" == "stable" ]; then
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
         echo "Done for $arch!"
         exit 1
      fi
   done

   if [ -f index.db ]; then
      echo "  removing old index..."
      rm index.db
   fi

   if [ ! -f "index.db" ]; then
      ID_cnt=1
      echo "[ID:Name:Version:Dependencies]" >> index.db
   else
      ID_cnt=$(( $(tail -n 1 "index.db" | cut -d ":" -f 1 | cut -d "{" -f 2) + 1 ))
   fi

   for f in *_v*.tgz; do
      if [ "$f" != "*_v*.tgz" ]; then
         p_ver="${f#*_v}"
         ver="${p_ver%.tgz}"
         echo "Enter dependencies for ${f%_v*} (or leave blank; delim: ,) [ENTER]:"; read deps
         echo "{$ID_cnt:${f%_v*}:$ver:$deps}" >> index.db 2>/dev/null
         ID_cnt=$(($ID_cnt + 1))
      fi
   done
   echo "  new index created!"
   echo "Done for $arch!"
else
   echo "unknown architecture!"
fi
