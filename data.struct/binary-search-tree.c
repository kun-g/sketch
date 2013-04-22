#include <stdio.h>

typedef struct _BSTNode {
  struct _BSTNode * left;
  struct _BSTNode * right;
  struct _BSTNode * parent;
  int v;
} BSTNode;

void inorder_tree_walk(BSTNode *root)
{
  if (NULL != root) {
    inorder_tree_walk(root->left);
    printf("%d ", root->v);
    inorder_tree_walk(root->right);
  }
}

BSTNode* tree_search(BSTNode *root, int key)
{
  if (NULL == root || root->v == key) {
    return root;
  }
  if (root->v > key) {
    return tree_search(root->left, key);
  } else {
    return tree_search(root->right, key);
  }
}

BSTNode* iterative_tree_search(BSTNode *root, int key)
{
  BSTNode *node = root;
  while (NULL != node && node->v != key) {
    if (node->v > key) {
      node = node->left;
    } else {
      node = node->right;
    }
  }
}

BSTNode* tree_maximum(BSTNode *root)
{
  while (NULL != root->right) {
    root = root->right;
  }
  return root;
}

BSTNode* tree_minimum(BSTNode *root)
{
  while (NULL != root->left) {
    root = root->left;
  }
  return root;
}

BSTNode* tree_successor(BSTNode *tar)
{
  if (NULL != tar) {
    return tree_minimum(tar->right);
  }
  BSTNode *parent = tar->parent;
  while (NULL != parent && parent->right == tar){
    parent = parent->parent;
  }
  return parent;
}

BSTNode* tree_predecessor(BSTNode *tar)
{
  if (NULL != tar) {
    return tree_maximum(tar->left);
  }
  BSTNode *parent = tar->parent;
  while (NULL != parent && parent->right == tar){
    parent = parent->parent;
  }
  return parent;
}

BSTNode* tree_insert(BSTNode **root, BSTNode *val)
{
  if (NULL == root) return NULL;

  BSTNode *node, *parent;
  node = *root;
  parent = NULL;
  while (NULL != node) {
    parent = node;
    if (val->v < node->v) {
      node = node->left;
    } else {
      node = node->right;
    }
  }
  val->parent = parent;
  if (NULL == parent) {
    *root = val; 
    val->left = val->right = NULL;
  } else if (val->v < parent->v) {
    parent->left = val;
  } else {
    parent->right = val;
  }
}

BSTNode* tree_delete(BSTNode** root, BSTNode* tar)
{
  BSTNode *parent, *node;
  if (NULL == tar->left || NULL == tar->right) {
    parent = tar->parent;
  } else { // have two children,need to replace it with its' successor
    parent = tree_successor(tar);
  }
  if (NULL != parent->left) {
    node = parent->left;
  } else {
    node = parent->right;
  }
  // fix children's parent node
  if (NULL != node) {
    node->parent = parent->parent;
  }
  // fix parent's children node
  if (NULL == parent->parent) {
    *root = node;
  } else if (parent->parent->left == parent) {
    parent->parent->left = node;
  } else {
    parent->parent->right = node;
  }
  // two children
  if (parent != tar) {
    tar->v = parent->v;
  }
  return parent;
}


int main(int argc, const char *argv[])
{
  
  return 0;
}
