#include <stdio.h>

#define COUNT 100000

int findBiggestSubSquence(int *sequence, int length) {
  int maxSum, curSum, index, from, to;
  maxSum = -1;
  curSum = index = 0;
  to = sequence[0];
  from =  sequence[index];
  for (int i = 0; i<length; i++) {
    curSum += sequence[i];
    if (curSum > maxSum) {
      maxSum = curSum;
      to = sequence[i];
      from =  sequence[index];
    }
    if (curSum < 0) {
      index = i+1;
      curSum = 0;
    }
  }

  if (maxSum < 0) {
    maxSum = 0;
    from = sequence[0];
    to = sequence[length-1];
  }

  printf("%d %d %d", maxSum, from, to);
  return maxSum;
}

int handleInput(int *numbers) {
  int K;
  scanf("%d", &K);

  int i = 0;
  while (i < K) {
    scanf("%d", numbers+i);
    i++;
  }

  return K;
}

int main() {
  int numbers[COUNT];
  findBiggestSubSquence(numbers, handleInput(numbers));
}
