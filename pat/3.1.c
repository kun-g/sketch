#include <stdio.h>
#include <stdlib.h>

float func(float a[], float x) {
  return a[0]*x*x*x + a[1]*x*x + a[2]*x + a[3];
}

#define EPSI 0.001

int main() {
  float as[] = {0, 0, 4, 1};
  float a = -0.5, b = 0.5;

  scanf("%f %f %f %f", as+0, as+1, as+2, as+3);
  scanf("%f %f", &a, &b);

  float mid;
  while (b-a > EPSI) {
    float fa = func(as, a);
    float fb = func(as, b);
    if (fa*fb < 0) {
      float tmp = func(as, (a+b)/2);
      if (tmp*fa > 0) {
        a = (a+b)/2;
      } else if (tmp*fb > 0) {
        b = (a+b)/2;
      } else {
        printf("%.2f", (a+b)/2);
        return 0;
      }
    } else if (fa == 0) {
      printf("%.2f", a);
      return 0;
    } else if (fb == 0) {
      printf("%.2f", b);
      return 0;
    } else {
      printf("ERROR");
      return 1;
    }
  }

  printf("%.2f", (a+b)/2);
  return 0;
}
