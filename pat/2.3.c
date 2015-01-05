#include <stdio.h>
#include <stdlib.h>

#define TYPE_NUMBER 0
#define TYPE_OPERATOR 1

typedef struct _Node {
  int type;
  char operator;
  float number;
  struct _Node *next;
} Node, *PNode;

typedef struct _Stack {
  PNode top;
} Stack, *PStack;

PNode pop(PStack stack) {
  PNode node = stack->top;
  if (stack->top) stack->top = stack->top->next;
  return node;
}

PStack push(PStack stack, PNode node) {
  node->next = stack->top;
  stack->top = node;
  return stack;
}

PStack handleInput (char input[]) {
  PStack stack = malloc(sizeof(Stack));
  stack->top = NULL;

  char c = ' ';
  float number;
  int index = 0;
  while (input[index]) {
    if (sscanf(input+index, "%f", &number) == 1) {
      PNode node = malloc(sizeof(Node));
      node->type = TYPE_NUMBER;
      node->number = number;
      push(stack, node);
      //printf("Number:%d\n", number);
    } else {
      sscanf(input+index, "%c", &c);
      PNode node = malloc(sizeof(Node));
      switch (c) {
        case '-':
        case '+':
        case '*':
        case '/':
          node->type = TYPE_OPERATOR;
          node->operator = c;
          push(stack, node);
          //printf("Operator:%c\n", c);
          break;
        default:
          free(node);
          break;
      };
    }
    for (; input[index] && input[index] != ' '; index++) ; // Skip Matched Data
    for (; input[index] && input[index] == ' '; index++) ; // Skip Space
  }

  return stack;
}

void calculate(PStack stack) {
  PStack operandStack = malloc(sizeof(Stack));
  operandStack->top = NULL;

  PNode operand0, operand1;
  for (PNode node = pop(stack); node; node = pop(stack)) {
    if (node->type == TYPE_NUMBER) {
      //printf("Push %f \n", node->number);
      push(operandStack, node);
    } else {
      switch (node->operator) {
        case '+':
        case '-':
        case '*':
        case '/':
          operand0 = pop(operandStack);
          operand1 = pop(operandStack);
          //printf("%f %c %f = ", operand0->number, node->operator, operand1->number);
          switch (node->operator) {
            case '+': operand0->number += operand1->number; break;
            case '-': operand0->number -= operand1->number; break;
            case '*': operand0->number *= operand1->number; break;
            case '/':
                      if (operand1->number == 0) {
                        printf("ERROR");
                        return ;
                      }
                      operand0->number /= operand1->number;
                      break;
          }
          free(operand1);
          push(operandStack, operand0);
          //printf("%f \n", operand0->number);
          break;
        default:
          printf("ERROR");
          return;
          break;
      }
    }
  }
  operand0 = pop(operandStack);
  printf("%.1f", operand0->number);
}

int main () {
  char input[1024];
  scanf("%[^\n]", input);
  calculate(handleInput(input));
  //calculate(handleInput("+ + 2 * 3 - 7 4 / 8 4")); printf("\n");
  //calculate(handleInput("/ -25 + * - 2 3 4 / 8 4")); printf("\n");
  //calculate(handleInput("/ 5 + * - 2 3 4 / 8 2")); printf("\n");
  //calculate(handleInput("+10.23")); printf("\n");
  //calculate(handleInput("-10.23")); printf("\n");
}

