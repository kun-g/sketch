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

typedef PTreeNode QueueNodeType;
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

void BFV(PTreeNode head) {
  Queue localQueue;
  PQueue queue = &localQueue;
  Queue_init(queue);

  Queue_insert(queue, head);

  int flag = 0;
  while (1) {
    PTreeNode node = Queue_shift(queue);
    if (!node) break;
    if (node->left) Queue_insert(queue, node->left);
    if (node->right) Queue_insert(queue, node->right);

    if (!node->left && !node->right) {
      if (flag) printf(" ");
      printf("%d", node->data);
      flag = 1;
    }
  }
}

int main () {
  int nodeCount = 0;
  scanf("%d", &nodeCount);
  
  PTreeNode memory = malloc(sizeof(TreeNode)*nodeCount);
  for (int i = 0; i < nodeCount; i++) memory[i].parent = NULL;
  PTreeNode head = memory;
  int left, right;
  for (int i = 0; i < nodeCount; i++) {
    int res = scanf("%d ", &left);
    if (res == 0) {
      scanf("%*c ");
      left = -1;
    }
    res = scanf("%d", &right);
    if (res == 0) {
      scanf("%*c");
      right = -1;
    }
    Tree_addLeftChild(memory+i, left==-1?NULL:memory+left);
    Tree_addRightChild(memory+i, right==-1?NULL:memory+right);
    memory[i].data = i;
  }

  while (head->parent) head = head->parent;

  BFV(head);

  return 0;
}
