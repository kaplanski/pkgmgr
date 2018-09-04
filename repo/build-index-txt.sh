#!/bin/bash
arch=${1%/}
if [ "$arch" == "i386" -o "$arch" == "amd64" -o "$arch" == "python2" -o "$arch" == "python3" ]; then
   cd "$arch"
   for dir in */; do
      base=$(basename "$dir")
      if [ "$base" != "*" ]; then
         echo "Building $base..."
         tar -czf "${base}.tgz" "$dir"
         rm -rf "$dir"
      else
         echo "nothing to build..."
      fi
   done

   if [ -f index.txt ]; then
      echo "removing old index..."
      rm index.txt
   fi

   for f in *.tgz; do
      if [ "$f" != "*.tgz" ]; then
         echo "${f%.tgz}" >> index.txt 2>/dev/null
      else
         touch index.txt
      fi
   done
   echo "new index created!"
else
   echo "unknown architecture!"
fi
