#include <stdio.h>
#include <stdlib.h>

#define MAX_ADDR 100000

typedef struct _Node {
  int data;
  int address;
  int next_address;
  struct _Node *next;
} Node, *PNODE;

void printList(PNODE head) {
  for (PNODE p = head; p; p = p->next) {
    if (p->next_address == -1) {
      printf("%.5d %d %d\n", p->address, p->data, p->next_address);
    } else {
      printf("%.5d %d %.5d\n", p->address, p->data, p->next_address);
    }
  }
}

PNODE reverseList(PNODE head) {
  PNODE p = head;
  PNODE q = head->next;
  PNODE tmp = NULL;

  p->next = NULL;
  p->next_address = -1;
  while (q) {
    tmp = q->next;
    q->next = p;
    q->next_address = p->address;
    p = q;
    q = tmp;
  }

  return p;
}

PNODE subRevList(PNODE head, int revCount) {
  PNODE p = head;
  int count = 0;
  PNODE curHead = p;
  PNODE prevTail = NULL;

  while (p) {
    count += 1;
    if (count%revCount == 0) {
      if (prevTail) {
        prevTail->next = p;
        prevTail->next_address = p->address;
      } else {
        head = p;
      }

      PNODE nextHead = p->next;
      p->next = NULL;
      p->next_address = -1;
      reverseList(curHead);
      prevTail = curHead;
      curHead = nextHead;
      p = nextHead;
    } else {
      p = p->next;
    }
  }
  if (count%revCount && prevTail) {
    prevTail->next = curHead;
    prevTail->next_address = curHead->address;
  }

  return head;
}

PNODE generateTestList () {
  int count = 10;
  Node *memory = malloc(sizeof(Node)*count);
  for (int i = 0; i < count; i++) {
    memory[i].data = i;
    memory[i].next = memory+i+1;
    memory[i].address = i;
    memory[i].next_address = i+1;
  }
  memory[count-1].next = NULL;
  memory[count-1].next_address = -1;
  return memory;
}

void testReverse () {
  PNODE memory = generateTestList();
  PNODE head = reverseList(memory);
  PNODE p = head;
  for (int i = 10; i >= 0; i--) {
    if (p->data != i) {
      printf("Fail");
      break;
    }
    p = p->next;
  }
  free(memory);
}

void testSubReverse () {
  PNODE memory = generateTestList();
  int subCount = 10;
  PNODE head = subRevList(memory, subCount);
  PNODE p = head;
  for (int i = 0; i < 10; i++) {
    int expect = (i/subCount+1)*subCount - i%subCount - 1;
    if (expect >= 10) break;
    if (p->data != expect) {
      printf("Fail");
      break;
    }
    p = p->next;
  }
  printList(head);
  free(memory);
}

void test() {
  printf("Test Reverse List\n"); testReverse();
  printf("Test SubReverse List\n"); testSubReverse();
}

int main() {
  Node memory[MAX_ADDR];

  int startAddress, totalCount, revCount;
  scanf("%d %d %d", &startAddress, &totalCount, &revCount);

  int address, data, nextAddress;
  for (int i = 0; i < totalCount; i++) {
    scanf("%d %d %d", &address, &data, &nextAddress);
    memory[address].data = data;
    memory[address].next = memory+nextAddress;
    memory[address].address = address;
    memory[address].next_address = nextAddress;
    if (nextAddress == -1) memory[address].next = NULL;
  }

  PNODE head = memory+startAddress;
  PNODE result = subRevList(head, revCount);

  printList(result);
}
