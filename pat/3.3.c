#include <stdio.h>
#include <stdlib.h>

typedef struct _TreeNode {
  int data;
  struct _TreeNode *parent;
  struct _TreeNode *left;
  struct _TreeNode *right;
} TreeNode, *PTreeNode;

void Tree_addLeftChild(PTreeNode root, PTreeNode node) {
  root->left = node;
  if (node) node->parent = root;
}

void Tree_addRightChild(PTreeNode root, PTreeNode node) {
  root->right = node;
  if (node) node->parent = root;
}

int flag = 0;
void Tree_postOrderVisit(PTreeNode root) {
  if (!root) return;

  Tree_postOrderVisit(root->left);
  Tree_postOrderVisit(root->right);

  if (flag) printf(" ");
  printf("%d", root->data);
  flag = 1;
}

typedef PTreeNode QueueNodeType;

typedef struct _Node {
  int data;
  struct _Node *next;
} Node, *PNode;

// STACK
typedef struct _Stack {
  PNode top;
} Stack, *PStack;

int pop(PStack stack) {
  PNode node = stack->top;
  int ret = node?node->data:-1;
  if (stack->top) {
    stack->top = stack->top->next;
    free(node);
  }
  return ret;
}

PStack push(PStack stack, int data) {
  PNode node = malloc(sizeof(Node));
  node->next = stack->top;
  node->data = data;
  stack->top = node;
  return stack;
}
/// queue begin
typedef struct _QueueNode {
  QueueNodeType data;
  struct _QueueNode *next;
} QueueNode, *PQueueNode;

typedef struct _Queue {
  PQueueNode head;
  PQueueNode tail;
} Queue, *PQueue;

void Queue_init(PQueue queue) {
  queue->head = queue->tail = NULL;
}

QueueNodeType Queue_shift(PQueue queue) {
  QueueNodeType data = 0;
  if (queue->head) {
    data = queue->head->data;
    PQueueNode tmp = queue->head;
    queue->head = queue->head->next;
    free(tmp);
    if (!queue->head) queue->tail = NULL;
  }
  return data;
}
PQueue Queue_insert(PQueue queue, QueueNodeType data) {
  PQueueNode node = malloc(sizeof(QueueNode));
  node->data = data;
  node->next = NULL;
  if (queue->tail) {
    queue->tail->next = node;
  } else {
    queue->head = node;
  }
  queue->tail = node;
  return queue;
}
/// queue end 


#define MODE_LEFT 1
#define MODE_RIGHT 2
int main () {
  int nodeCount = 0;
  scanf("%d", &nodeCount);
  
  Stack _stack;
  _stack.top = NULL;
  PStack stack = &_stack;
  PTreeNode memory = malloc(sizeof(TreeNode)*(nodeCount+1));
  for (int i = 0; i < nodeCount; i++) memory[i].parent = NULL;
  PTreeNode head = NULL, currentNode = NULL, lastPushNode = NULL;
  int input;
  char op[8];
  int mode = MODE_LEFT;
  while (1) {
    int res = scanf("%s", op);
    if (op[1] == 'u') { //Push
      scanf("%d", &input);
      if (!head) {
        head = memory+input;
      } else {
        if (mode == MODE_LEFT) {
          Tree_addLeftChild(currentNode, memory+input);
        } else {
          Tree_addRightChild(currentNode, memory+input);
        }
      }
      push(stack, input);
      memory[input].data = input;
      mode = MODE_LEFT;
      currentNode = memory+input;
    } else { // pop
      int index = pop(stack);
      if (res == EOF || index == -1) break;
      currentNode = memory+index;
      mode = MODE_RIGHT;
    }
  }

  Tree_postOrderVisit(head);

  return 0;
}
