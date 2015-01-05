#include <stdio.h>
#include <stdlib.h>

typedef struct _Tree {
  int data;
  struct _Tree *left;
  struct _Tree *right;
  struct _Tree *parent;
  int balance_factor;
  int height;
} Tree, *PTree;

PTree tree_create(int data) {
  PTree root = malloc(sizeof(Tree));
  root->left = NULL;
  root->right = NULL;
  root->left = NULL;
  root->data = data;
  return root;
}

#define TRUE 1
#define FALSE 0
int tree_isBST(PTree root) {
  if (!root) return TRUE;
  if (root->left && root->left->data > root->data) return FALSE;
  if (root->right && root->right->data < root->data) return FALSE;
  return tree_isBST(root->left) && tree_isBST(root->right);
}

int tree_updateHeight(PTree root) {
  if (!root) { return 0; }
  int leftHeight = tree_updateHeight(root->left);
  int rightHeight =  tree_updateHeight(root->right);
  root->balance_factor = leftHeight - rightHeight;
  root->height = leftHeight>rightHeight?leftHeight:rightHeight;
  root->height += 1;
  return root->height;
}

int tree_isAVL(PTree root) {
  if (!root) return TRUE;
  tree_updateHeight(root);
  int balanceFactor = root->balance_factor;
  if (! (balanceFactor>=-1 && balanceFactor<=1) ) return FALSE;
  return tree_isAVL(root->left) && tree_isAVL(root->right);
}

PTree tree_find(int x, PTree root) {
  return root;
}

PTree tree_findMin(PTree root) {
  return root;
}

PTree tree_findMax(PTree root) {
  return root;
}

PTree tree_insert(int x, PTree root) {
  PTree *child = NULL;
  if (root->data < x) {
    child = &root->right;
  } else {
    child = &root->left;
  }

  if (*child) {
    tree_insert(x, *child);
  } else {
    *child = tree_create(x);
    (*child)->parent = root;
  }
  return root;
}

PTree tree_rotate_RR(PTree root) {
  PTree child = root->right;
  child->parent = root->parent;
  root->right = child->left;
  child->left = root;
  return child;
}

PTree tree_rotate_LL(PTree root) {
  PTree child = root->left;
  child->parent = root->parent;
  root->left = child->right;
  child->right = root;
  return child;
}

PTree tree_rotate_RL(PTree root) {
  PTree child = root->right;
  PTree newRoot = child->left;

  child->parent = newRoot;
  child->left = newRoot->right;
  newRoot->right = child;

  newRoot->parent = root->parent;
  root->parent = newRoot;
  root->right = newRoot->left;
  newRoot->left = root;

  return newRoot;
}

PTree tree_rotate_LR(PTree root) {
  PTree child = root->left;
  PTree newRoot = child->right;

  child->parent = newRoot;
  child->right = newRoot->left;
  newRoot->left = child;

  newRoot->parent = root->parent;
  root->parent = newRoot;
  root->left = newRoot->right;
  newRoot->right = root;

  return newRoot;
}

PTree tree_AvlInsert(int x, PTree root) {
  PTree *child = NULL;
  if (root->data < x) {
    child = &root->right;
  } else {
    child = &root->left;
  }

  if (*child) {
    PTree newSubRoot = tree_AvlInsert(x, *child);
    *child = newSubRoot;
  } else {
    *child = tree_create(x);
    (*child)->parent = root;
  }

  tree_updateHeight(root);
  if (root->balance_factor == -2) {
    if (root->right->balance_factor == -1) {
      root = tree_rotate_RR(root);
    } else {
      root = tree_rotate_RL(root);
    }
  } else if (root->balance_factor == 2) {
    if (root->left->balance_factor == 1) {
      root = tree_rotate_LL(root);
    } else {
      root = tree_rotate_LR(root);
    }
  }

  return root;
}

PTree tree_delete(int x, PTree root) {
  return root;
}
void tree_destroy(PTree root) {
}

void tree_print(PTree root) {
  if (!root) printf("NULL");
  printf("%d (", root->data);
  if (root->left || root->right) {
    if (root->left) tree_print(root->left); else printf("NULL");
    printf(", ");
    if (root->right) tree_print(root->right); else printf("NULL");
  }
  printf(")");
}

int test_isNotBST() {
  PTree root = tree_create(0);
  for (int i = 1; i < 10; i++) tree_insert(i, root);
  if (!(tree_isBST(root))) printf("Test 1 Fail\n");
  tree_destroy(root);

  root = tree_create(0);
  for (int i = 1; i < 10; i++) root = tree_AvlInsert(i, root);
  if (!(tree_isBST(root) && tree_isAVL(root))) printf("Test 2 Fail\n");
  tree_destroy(root);

  root = tree_create(9);
  for (int i = 8; i >= 0; i--) root = tree_AvlInsert(i, root);
  if (!(tree_isBST(root) && tree_isAVL(root))) printf("Test 3 Fail\n");
  tree_destroy(root);

  root = tree_create(0); root = tree_AvlInsert(2, root); root = tree_AvlInsert(1, root);
  root = tree_AvlInsert(4, root); root = tree_AvlInsert(3, root); root = tree_AvlInsert(5, root);
  if (!(tree_isBST(root) && tree_isAVL(root))) printf("Test 4 Fail\n");
  tree_destroy(root);

  root = tree_create(9); root = tree_AvlInsert(7, root); root = tree_AvlInsert(8, root);
  root = tree_AvlInsert(6, root); root = tree_AvlInsert(4, root); root = tree_AvlInsert(5, root);
  if (!(tree_isBST(root) && tree_isAVL(root))) printf("Test 5 Fail\n");
  tree_destroy(root);

  return 0;
}

int main () {
  //test_isNotBST();
  int nodeCount = 0;
  scanf("%d", &nodeCount);

  int number = 0;
  PTree root = NULL;
  for (int i = 0; i < nodeCount; i++) {
    scanf("%d", &number);
    if (root) {
      root = tree_AvlInsert(number, root);
    } else {
      root = tree_create(number);
    }
  }
  printf("%d", root->data);
  return 0;
}
