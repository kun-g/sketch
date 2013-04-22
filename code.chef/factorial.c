#include <stdio.h>

int main()
{
  unsigned int t,n,i,count[100000];

  scanf("%d", &t);
  for (i = 0; i < t; i++) {
    scanf("%d", &n);
    count[i] = 0;
    while (5<=n) {
      n /= 5;
      count[i] += n;
    }
  }
  for (i = 0; i < t; i++) {
    printf("%d\n", count[i]);
  }
  return 0;
}
