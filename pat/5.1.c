#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct _Vertex {
  struct _Edge *edges;
  int visited;
  int id;
  struct _Vertex *next;
} Vertex, *PVertex;

typedef struct _Edge {
  struct _Vertex *vertex;
  struct _Edge *next;
} Edge, *PEdge;

void addEdge(PVertex vertex, PEdge edge) {
  PEdge *ppEdge = &vertex->edges;
  PEdge p = vertex->edges;

  while (p) {
    if (p->vertex->id > edge->vertex->id) break;
    ppEdge = &p->next;
    p = p->next;
  }
  
  edge->next = *ppEdge;
  *ppEdge = edge;
}

void _dfs(PVertex vertex) {
  vertex->visited = 1;
  for (PEdge p = vertex->edges; p; p = p->next) {
    if (p->vertex->visited) continue;
    printf("%d ", p->vertex->id);
    _dfs(p->vertex);
  }
}

void dfs(PVertex vertices, int count) {
  for (int i = 0; i < count; i++) { vertices[i].visited = 0; }
  for (int i = 0; i < count; i++) {
    if (vertices[i].visited) continue;
    printf("{ %d ", i);
    _dfs(vertices+i);
    printf("}\n");
  }
}
typedef PVertex QueueNodeType;
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
void _bfs(PVertex vertex) {
  vertex->visited = 1;
  Queue _queue; PQueue queue = &_queue;
  Queue_init(queue);
  while (vertex) {
    for (PEdge p = vertex->edges; p; p = p->next) {
      if (p->vertex->visited) continue;
      p->vertex->visited = 1;
      Queue_insert(queue, p->vertex);
      printf("%d ", p->vertex->id);
    }
    vertex = Queue_shift(queue);
  }
}

void bfs(PVertex vertices, int count) {
  for (int i = 0; i < count; i++) { vertices[i].visited = 0; }
  for (int i = 0; i < count; i++) {
    if (vertices[i].visited) continue;
    printf("{ %d ", i);
    _bfs(vertices+i);
    printf("}\n");
  }
}

int main() {
  int N, E;
  scanf("%d %d", &N, &E);

  Vertex vertices[N];
  for (int i = 0; i < N; i++) {
    vertices[i].visited = 0;
    vertices[i].edges = NULL;
    vertices[i].id = i;
  }

  Edge edges[E*2];
  for (int i = 0; i < E; i++) {
    int v1, v2;
    scanf("%d %d", &v1, &v2);
    edges[i].vertex = vertices+v1;
    addEdge(vertices+v2, edges+i);
    edges[i+E].vertex = vertices+v2;
    addEdge(vertices+v1, edges+i+E);
  }
  dfs(vertices, N);
  bfs(vertices, N);

  return 0;
}
