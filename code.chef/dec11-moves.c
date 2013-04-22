#include <stdio.h>

unsigned int aTable[5001];

unsigned int arrange(int m)
{
  unsigned int tmp, i;

  tmp = 1;
  for (i = 0; i < m; i++) {
    tmp *= i+1;
  }
  return tmp;
}

unsigned int combination(int m, int n)
{
  return aTable[n]/(aTable[m]*aTable[n-m]);
}

int main()
{
  unsigned int N, K, C1, C2;

  int i;
  for (i = 1; i < 5001; i++) {
    aTable[i] = arrange(i);
    printf("%d\n", aTable[i]);
  }
  printf("done\n");

  do {
    scanf("%d %d", &N, &K);
    if (0==N && 0==K) {
      break;
    }

    C1 = combination(((K+2)>>1)-1, N-2);
    C2 = (K+1)&1 ? combination(((K)>>1)-1, N-2) : C1;
    printf("%d\n", (2*C1*C2)%1000000007); // C(1,2)*C((K+2)/2-1,N-2)*C((K+1)/2-1,N-2)
  } while (1);
  return 0;
}
