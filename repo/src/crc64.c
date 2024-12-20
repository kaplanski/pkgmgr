/*
 a fast non-cryptographic hash using the crc64-iso
 polynome x^64 + x^4 + x^3 + x + 1 bytewise
 Copyright (c) 2019-present Jan-Daniel Kaplanski
 MIT/X11 LICENSE
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <fcntl.h>

void crc64(char *tohash, long length){
 int i=0;
 unsigned long long x64=0, x4=0, x3=0, num=0, buf=0, rval=0;

 for(i=0;i<length;i++)
  {
   num = (unsigned long long) tohash[i];
   x64 = pow(num,64);
   x4 = pow(num,4);
   x3 = pow(num,3);
   buf = x64 + x4 +x3 + num + 1;
   rval = rval + buf;
  }
 printf("%llx", rval);
}

int main(int argc, char *argv[]){
 char * tohash = 0;
 long length;

 if (argc<2)
  {
   fprintf(stderr, "Usage: %s [file] > hash.crc\n", argv[0]);
   return 1;
  }
 if(access(argv[1], F_OK) != -1)
  {
   FILE * f = fopen(argv[1], "rb");

   if (f)
    {
     fseek(f, 0, SEEK_END);
     length = ftell(f);
     fseek(f, 0, SEEK_SET);
     tohash = malloc(length);
     if (tohash)
      {
       fread (tohash, 1, length, f);
      }
     fclose (f);
    }

   if (tohash)
    {
     crc64(tohash, length);
    }
   else
    {
     fprintf(stderr, "failed to read into buffer\n");
     return 2;
    }
  }
 else
  {
   perror("fail");
   return 2;
  }
 return 0;
}
