#include <stdio.h>
#include "mod_hash.h"

int main(int argc, char *argv[]){
 char hash[512];

 if (argc == 2)
  {
   fhash(argv[1], &hash);
   printf("%s", hash);
   return 0;
  }
 else
  {
   fprintf(stderr, "Usage: %s [file]\n", argv[0]);
   return 1;
  }
}
