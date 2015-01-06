#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct _Vertex {
  struct _EdgeList *edges;
  int listLength;
  int id;
  int visited;
} Vertex, *PVertex;

typedef struct _Edge {
  struct _Vertex *vertex_a;
  struct _Vertex *vertex_b;
  int length;
} Edge, *PEdge;

typedef struct _EdgeList {
  PEdge edge;
  struct _EdgeList *next;
} EdgeList, *PEdgeList;

void addEdgeTo(PVertex vertex, PEdge edge) {
  PEdgeList *ppEdge = &vertex->edges;
  PEdgeList p = vertex->edges;
  PEdgeList node = malloc(sizeof(EdgeList));

  node->edge = edge;
  node->next = *ppEdge;
  //printf("Add %p %p\n", node, node->next);
  *ppEdge = node;
  vertex->listLength += 1;
  //printf("AddEdgeTo %d %d\n", vertex->id, vertex->listLength);
}

void addEdge(PVertex vertex1, PVertex vertex2, PEdge edges, int M, int length) {
  if (length > 6) return ;
  PEdge edge = NULL;
  PVertex tmp = vertex1;
  if (vertex1->id < vertex2->id) {
    vertex1 = vertex2;
    vertex2 = tmp;
  }
  int index = (vertex1->id*(vertex1->id+1)/2 + vertex2->id - vertex1->id);
  edge = edges+index;
  //printf("Edge: %d %d %d\n", vertex1->id, vertex2->id, index);
  //printf("AddEdge: %d %d %p %d\n", vertex1->id, vertex2->id, edge, edge->length);
  if (edge->length == -1) {
    edge->vertex_a = vertex1;
    edge->vertex_b = vertex2;
    addEdgeTo(vertex1, edge);
    addEdgeTo(vertex2, edge);
    edge->length = length;
  } else if (length < edge->length) {
    edge->length = length;
  }
}
#define getOtherVertex(theEdge, theVertex) (theVertex==theEdge->vertex_a)?theEdge->vertex_b:theEdge->vertex_a
void bridgeThisVertex(PVertex vertex, PEdge edges, int M) {
  PEdgeList p = vertex->edges;
  while (p) {
    PEdge edge_a = p->edge;
    PEdgeList q = p->next;

    while (q) {
      PEdge edge_b = q->edge;
      PVertex vertex1 = getOtherVertex(edge_a, vertex);
      PVertex vertex2 = getOtherVertex(edge_b, vertex);
      addEdge(vertex1, vertex2, edges, M, edge_a->length+edge_b->length);
      q = q->next;
    }
    p = p->next;
  }
}

int main() {
  int N, M, i;
  scanf("%d %d", &N, &M);

  PVertex vertices = malloc(sizeof(Vertex)*N);
  for (i = 0; i < N; i++) {
    vertices[i].visited = 0;
    vertices[i].edges = NULL;
    vertices[i].id = i;
    vertices[i].listLength = 1;
  }

  int count = N*(N-1)/2;
  PEdge edges = malloc(sizeof(Edge)*count);
  for (i = 0; i < count; i++) {
    edges[i].length = -1;
  }

  for (i = 0; i < M; i++) {
    int v1, v2;
    scanf("%d %d", &v1, &v2);
    v1 -= 1;
    v2 -= 1;
    addEdge(vertices+v1, vertices+v2, edges, M, 1);
  }

  for (i = 0; i < N; i++) {
    PEdgeList p = vertices[i].edges;
    bridgeThisVertex(vertices+i, edges, M);
  }

  for (i = 0; i < N; i++) {
    printf("%d: %.2f%%\n", i+1, ((float)vertices[i].listLength/N)*100);
  }
  //printf("Done");

  return 0;
}
