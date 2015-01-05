#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct _HuffmanTree {
  char c;
  int freq;
  char code[9];
  struct _HuffmanTree *left;
  struct _HuffmanTree *right;
} HuffmanTree, *PHuffmanTree;

typedef struct _HuffmanTree* HeapData;
typedef struct _HeapNode {
  struct _HeapNode *left;
  struct _HeapNode *right;
  struct _HeapNode *parent;
  HeapData data;
} HeapNode, *PHeapNode;

typedef struct _Heap {
  PHeapNode root;
  PHeapNode nodes;
  unsigned int size;
  unsigned int last;
} Heap, *PHeap;

PHeap heap_init(unsigned int size) {
  PHeap heap = malloc(sizeof(Heap));
  heap->root = NULL;
  heap->nodes = malloc(sizeof(HeapNode)*size);
  heap->size = size;
  heap->last = 0;
  return heap;
}
void heap_destroy(PHeap heap) {
  free(heap->nodes);
  free(heap);
}
unsigned int parentIndexFor(unsigned int id) { return (id-1)/2; }
#define swap(a, b, Type) {Type temp = a; a = b; b = temp;}
typedef int CompareFunction(void *, void *);
void heap_update(PHeapNode node, CompareFunction cmpFunc) {
  PHeapNode parent = node->parent;
  if (!parent) return ;
  if (cmpFunc(node->data, parent->data)) {
    swap(parent->data, node->data, HeapData);
  }
  heap_update(parent, cmpFunc);
}
PHeap minHeap_add(PHeap heap, HeapData data, CompareFunction cmpFunc) {
  PHeapNode node = heap->nodes+heap->last;
  node->left = NULL;
  node->right = NULL;
  node->parent = NULL;
  node->data = data;

  if (heap->root) {
    PHeapNode parent = heap->nodes + parentIndexFor(heap->last);
    if (heap->last%2) {
      parent->left = node;
    } else {
      parent->right = node;
    }
    node->parent = parent;
    
    heap_update(node, cmpFunc);
  } else {
    heap->root = node;
  }
  heap->last += 1;

  return heap;
}

HeapData minHeap_pop(PHeap heap, CompareFunction cmpFunc) {
  PHeapNode node = NULL;
  if (heap->last == 0) {
    return NULL;
  } else if (heap->last == 1) {
    heap->last -= 1;
    node = heap->root;
    heap->root = NULL;
    return node->data;
  }
  heap->last -= 1;
  node = heap->nodes + heap->last;
  swap(heap->root->data, node->data, HeapData);

  PHeapNode parent = heap->nodes + parentIndexFor(heap->last);
  if (heap->last%2) {
    parent->left = NULL;
  } else {
    parent->right = NULL;
  }

  PHeapNode curr = heap->root;
  while (curr) {
    PHeapNode left = curr->left;
    PHeapNode right = curr->right;
    PHeapNode min = curr;
    if (left && !cmpFunc(min->data, left->data)) {
      min = left;
    }
    if (right && !cmpFunc(min->data, right->data)) {
      min = right;
    }
    if (min == curr) {
      break;
    } else {
      swap(curr->data, min->data, HeapData);
      curr = min;
    }
  }
  return node->data;
}

int compareFunction(void * a, void *b) {
  return ((PHuffmanTree)a)->freq < ((PHuffmanTree)b)->freq;
}

void strAppend(char *dst, char *src, char c) {
  unsigned int i = 0;
  while (src[i]) {
    dst[i] = src[i];
    i += 1;
  }
  dst[i] = c;
  dst[i+1] = '\0';
}
void huffman_update_code(PHuffmanTree tree) {
  if (tree->left) {
    strAppend(tree->left->code, tree->code, '0');
    huffman_update_code(tree->left);;
  }
  if (tree->right) {
    strAppend(tree->right->code, tree->code, '1');
    huffman_update_code(tree->right);;
  }
}

void huffman_destroy_tree(PHuffmanTree root) {
  if (!root) return ;
  huffman_destroy_tree(root->left); root->left = NULL;
  huffman_destroy_tree(root->right); root->right = NULL;
  if (root->c == -1) free(root);
}
PHuffmanTree huffman_generate_tree(PHeap heap) {
  while (1) {
    PHuffmanTree left = minHeap_pop(heap, compareFunction);
    PHuffmanTree right = minHeap_pop(heap, compareFunction);
    if (right) {
      PHuffmanTree root = malloc(sizeof(HuffmanTree));
      root->left = left;
      root->right = right;
      root->c = -1;
      root->freq = left->freq + right->freq;
      minHeap_add(heap, root, compareFunction);
    } else {
      left->code[0] = '\0';
      return left;
    }
  }
}

#define MAX_N 64
int getWPL(PHuffmanTree data, int length) {
  int wpl = 0;
  for (int i = 0; i < length; i++) {
    wpl += data[i].freq * strlen(data[i].code);
  }
  return wpl;
}

int buildBranch(PHuffmanTree root, PHuffmanTree node) {
  char *code = node->code;
  int i = 0;
  PHuffmanTree *pNode = &root;
  while (code[i]) {
    if (*pNode) {
      if ((*pNode)->c != -1) {
        return 0;
      }
    } else {
      *pNode = malloc(sizeof(HuffmanTree));
      (*pNode)->c = -1;
      (*pNode)->left = NULL;
      (*pNode)->right = NULL;
    }
    if (code[i] == '0') {
      pNode = &((*pNode)->left);
    } else {
      pNode = &((*pNode)->right);
    }
    i += 1;
  }
  if (*pNode) {
    return 0;
  } else {
    *pNode = node;
    return 1;
  }
}
int hasPreCode(PHuffmanTree data, int length) {
  PHuffmanTree root = malloc(sizeof(HuffmanTree));
  root->c = -1;
  for (int i = 0; i < length; i++) {
    PHuffmanTree node = data+i;
    if (!buildBranch(root, data+i)) {
      huffman_destroy_tree(root);
      return 1;
    }
  }
  huffman_destroy_tree(root);
  return 0;
}
int isValidateHuffmanTree(PHuffmanTree data, int length, int minWpl) {
  if (minWpl != getWPL(data, length)) return 0;
  if (hasPreCode(data,length)) return 0;
  return 1;
}

int main() {
  int N;
  scanf("%d", &N);

  //printf("N:%d\n", N);
  PHeap heap = heap_init(MAX_N);
  HuffmanTree data[N];
  getchar();
  for (int i = 0; i < N; i++) {
    scanf("%c %d", &data[i].c, &data[i].freq);
    if (i < N-1) getchar();
    //printf("%c %d\n", data[i].c, data[i].freq);
    data[i].left = data[i].right = NULL;
    data[i].code[0] = 0;
    minHeap_add(heap, data+i, compareFunction);
  }
  PHuffmanTree tree = huffman_generate_tree(heap);
  huffman_update_code(tree);
  huffman_destroy_tree(tree);

  int length = N;
  int minWPL = getWPL(data, length);
  //printf("WPL:%d\n", minWPL);
  int M;
  scanf("%d", &M);
  //printf("M:%d\n", M);
  getchar();
  for (int i = 0; i < M; i++) {
    HuffmanTree input[N];
    for (int j = 0; j < N; j++) {
      scanf("%c %s", &input[j].c, input[j].code);
      getchar();
      //printf("%d %c %s\n", j, input[j].c, input[j].code);
      input[j].freq = data[j].freq;
      input[j].left = input[j].right = NULL;
    }
    printf("%s", isValidateHuffmanTree(input, length, minWPL)?"Yes":"No");
    if (i < M-1)printf("\n");
  }

  return 0;
}
