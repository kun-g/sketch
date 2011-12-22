#include <stdio.h>
#include <string.h>
#include <stdlib.h>

unsigned int PRIME_COUNT;
#define SIEVE_SIZE 1024

char sieve[SIEVE_SIZE];
unsigned int *primes;
unsigned int primesIndex=0;
unsigned int base = 0;
unsigned int sieveIndex=0;

void punchHoles(unsigned int holeSeed)
{
  unsigned int i, hole;

  if (base < holeSeed) {
    hole = holeSeed;
  } else {
    hole = base + ((base%holeSeed)?(holeSeed-(base%holeSeed)):0);
  }
  while (1)
  {
    if (hole > base+8*SIEVE_SIZE-1) {
      break;
    } else {
      i = (hole - base)/8;
      switch ((hole-base)%8) {
        case 0: sieve[i] &= 0xff^0x01;break;
        case 1: sieve[i] &= 0xff^0x02;break;
        case 2: sieve[i] &= 0xff^0x04;break;
        case 3: sieve[i] &= 0xff^0x08;break;
        case 4: sieve[i] &= 0xff^0x10;break;
        case 5: sieve[i] &= 0xff^0x20;break;
        case 6: sieve[i] &= 0xff^0x40;break;
        case 7: sieve[i] &= 0xff^0x80;break;
      }
      hole += holeSeed;
    }
  }
}

void newSieve(unsigned int inewbase)
{// new base new sieve
  unsigned int i;
  base = inewbase;
  sieveIndex = 0;
  memset((void*)sieve, 0xff, sizeof(char)*SIEVE_SIZE);
  for (i = 0; i < primesIndex; i++) {
    punchHoles(primes[i]);
  }
}

unsigned int retrivePrime()
{
  while (1)
  {
    if (sieve[sieveIndex]!=0) {
      unsigned int prime = 0;
      if (sieve[sieveIndex]&0x01) prime = base+sieveIndex*8+0;
      else if (sieve[sieveIndex]&0x02) prime = base+sieveIndex*8+1;
      else if (sieve[sieveIndex]&0x04) prime = base+sieveIndex*8+2;
      else if (sieve[sieveIndex]&0x08) prime = base+sieveIndex*8+3;
      else if (sieve[sieveIndex]&0x10) prime = base+sieveIndex*8+4;
      else if (sieve[sieveIndex]&0x20) prime = base+sieveIndex*8+5;
      else if (sieve[sieveIndex]&0x40) prime = base+sieveIndex*8+6;
      else if (sieve[sieveIndex]&0x80) prime = base+sieveIndex*8+7;
      punchHoles(prime);
      return prime;
      }
    sieveIndex++;
    if (sieveIndex >= SIEVE_SIZE) {
      newSieve(base+8*SIEVE_SIZE);
    }
  }
}

int main()
{
  printf("PRIME_COUNT:");scanf("%d",&PRIME_COUNT);
  primes = (unsigned int*)malloc(sizeof(int)*PRIME_COUNT);
  memset((void*)sieve, (int)0xff, (size_t)sizeof(char)*SIEVE_SIZE);
  sieve[0] &= 0xff^3; // 1 and 0 are not primes

  while (primesIndex < PRIME_COUNT)
  {
    primes[primesIndex++] = retrivePrime();
    printf("%d\n", primes[primesIndex-1]);
  }

  free(primes);

  return 0; 
}
