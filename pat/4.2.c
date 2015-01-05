#include <stdio.h>
#include <stdlib.h>

typedef struct _SetElem {
  int data;
  struct _Set *set;
  struct _SetElem *next;
} SetElem, *PSetElem;

typedef struct _Set {
  struct _SetElem *head;
  struct _Set *next;
  struct _Set *prev;
} Set, *PSet;

PSet set_add(PSet set, PSetElem elem) {
  elem->next = set->head;
  elem->set = set;
  set->head = elem;
  return set;
}

PSet set_new() {
  PSet set = malloc(sizeof(Set));
  set->next = NULL;
  set->prev = NULL;
  set->head = NULL;
  return set;
}

PSet set_union(PSet sa, PSet sb) {
  if (!sb->head) return sa;
  if (sa == sb) return sa;
  //printf("%d %d %d\n",
  //    sa->head->data,
  //    sa->prev?sa->prev->head->data:-1,
  //    sa->next?sa->next->head->data:-1);
  //printf("%d %d %d\n",
  //    sb->head->data,
  //    sb->prev?sb->prev->head->data:-1,
  //    sb->next?sb->next->head->data:-1);

  PSetElem p = sb->head;
  while (p) {
    p->set = sa;
    if (p->next) {
      p = p->next;
    } else {
      p->next = sa->head;
      p = NULL;
    }
  }
  sa->head = sb->head;

  if (sb->prev) sb->prev->next = sb->next;
  if (sb->next) sb->next->prev = sb->prev;
  sb->prev = NULL;
  sb->next = NULL;

  //printf("%d %d %d\n",
  //    sa->head->data,
  //    sa->prev?sa->prev->head->data:-1,
  //    sa->next?sa->next->head->data:-1);
  //printf("==========\n");
  free(sb);
  return sa;
}

void createSetWithElem(PSetElem e, PSet sets) {
  //printf("Create %d\n", e->data);
  e->set = set_new();
  set_add(e->set, e);
  if (sets->next) {
    sets->next->prev = e->set;
    e->set->next = sets->next;
  }
  e->set->prev = sets;
  sets->next = e->set;
}

int check(PSetElem a, PSetElem b, PSet sets) {
  //printf("Set:%p %d\n", a->set, a->data);
  //printf("Set:%p %d\n", b->set, b->data);
  return a->set == b->set;
}

void input(PSetElem a, PSetElem b, PSet sets) {
  //printf("Set:%p %d\n", a->set, a->data);
  //printf("Set:%p %d\n", b->set, b->data);
  set_union(a->set, b->set);
}

int main () {
  int N = 5;
  scanf("%d", &N);

  SetElem elem[N+1];
  Set sets;
  sets.next = NULL;
  for (int i = 1; i < N+1; i++) {
    elem[i].next = NULL;
    elem[i].set = NULL;
    elem[i].data = i;
    createSetWithElem(elem+i, &sets);
  }

  int numbera, numberb;
  char op[8];
  while (1) {
    scanf("%c", op);
    if (op[0] == 'S') break;
    scanf("%d %d", &numbera, &numberb);
    if (op[0] == 'C') {
      printf("%s\n", check(elem+numbera, elem+numberb, &sets)?"yes":"no");
    } else if (op[0] == 'I') {
      input(elem+numbera, elem+numberb, &sets);
    }
  }

  int count = 0;
  for (PSet p = sets.next; p; p = p->next) {
    count += 1;
  }

  if (count == 1) {
    printf("The network is connected.");
  } else {
    printf("There are %d components.", count);
  }
  return 0;
}
