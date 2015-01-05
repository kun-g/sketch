#include <stdio.h>
#include <stdlib.h>

#define STRING_LEN 10240

int main () {
  int coefficient, index, flag_space = 0, flag_zero = 1; 
  char c;
  while (c != '\n') {
    scanf("%d%*c%d%c", &coefficient, &index, &c);
    if (index == 0 || coefficient == 0) continue;
    flag_zero = 0;
    if (flag_space) printf(" ");
    printf("%d %d", coefficient*index, (index-1));
    flag_space = 1;
  }
  if (flag_zero) {
    printf("0 0");
  }
}
