#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct _Vertex {
  struct _Edge *edges;
  int visited;
  int id;
  int x;
  int y;
  int isStartPoint;
  int isFinishPoint;
  int hasSafePath;
  struct _Vertex *next;
} Vertex, *PVertex;

typedef struct _Edge {
  struct _Vertex *vertex;
  struct _Edge *next;
} Edge, *PEdge;

void addEdge(PVertex vertex, PEdge edge) {
  PEdge *ppEdge = &vertex->edges;
  PEdge p = vertex->edges;

  edge->next = *ppEdge;
  *ppEdge = edge;
}

int pointsAreClose(int x1, int y1, int x2, int y2, int distance) {
  return (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) <= distance * distance; 
}
int canJumpBetween(PVertex current, PVertex target, int distance) {
  return pointsAreClose(current->x, current->y, target->x, target->y, distance);
}
int canJumpFromIsland(PVertex target, int distance) {
  return pointsAreClose(target->x, target->y, 0, 0, distance+15);
}
int canJumpToSaftPlace(PVertex target, int distance) {
  if (target->x < 0 && target->x - distance <= -50) return 1;
  if (target->x >= 0 && target->x + distance >= 50) return 1;
  if (target->y < 0 && target->y - distance <= -50) return 1;
  if (target->y >= 0 && target->y + distance >= 50) return 1;
  return 0;
}

void addEdgeBetween(PVertex current, PVertex target) {
  PEdge edge1 = malloc(sizeof(Edge));
  edge1->next = NULL; edge1->vertex = current;
  PEdge edge2 = malloc(sizeof(Edge));
  edge2->next = NULL; edge2->vertex = target;
  addEdge(current, edge2);
  addEdge(target, edge1);
}
void buildGraph(PVertex vertices, int N, int distance) {
  int i, j;
  for (i = 0; i < N; i++) {
    PVertex current = vertices+i;
    current->visited = 1;
    for (j = 0; j < N; j++) {
      PVertex target = vertices+j;
      if (target->visited) continue;
      if (canJumpBetween(current, target, distance)) {
        addEdgeBetween(current, target);
      }
    }
    if (canJumpFromIsland(current, distance)) { current->isStartPoint = 1; }
    if (canJumpToSaftPlace(current, distance)) {  current->isFinishPoint = 1; }
  }
}

int hasSafePath(PVertex vertex) {
  if (vertex->hasSafePath != -1) return vertex->hasSafePath;
  if (vertex->isFinishPoint) return vertex->hasSafePath;
  if (vertex->visited) return 0;
  vertex->visited = 1;
  PEdge p;
  for (p = vertex->edges; p; p = p->next) {
    if (hasSafePath(p->vertex)) return 1;
  }
  return vertex->hasSafePath = 0;
}

int hasPath(PVertex vertices, int N) {
  int i;
  for (i = 0; i < N; i++) { (vertices+i)->visited = 0; }
  for (i = 0; i < N; i++) {
    PVertex v = vertices+i;
    //printf("Vertex %d %d %d %d\n", i, v->hasSafePath, v->isStartPoint, v->isFinishPoint);
    if (hasSafePath(vertices+i) && (vertices+i)->isStartPoint ) return 1;
  }
  return 0;
}

int main() {
  int N, D, i;
  scanf("%d %d", &N, &D);

  Vertex vertices[N];
  for (i = 0; i < N; i++) {
    int x, y;
    scanf("%d %d", &x, &y);
    vertices[i].visited = 0;
    vertices[i].x = x;
    vertices[i].y = y;
    vertices[i].edges = NULL;
    vertices[i].id = i;
    vertices[i].isStartPoint = 0;
    vertices[i].isFinishPoint = 0;
    vertices[i].hasSafePath = -1;
  }

  buildGraph(vertices, N, D);

  if (D >= 50-15) {
    printf("Yes");
  } else if (hasPath(vertices, N)) {
    printf("Yes");
  } else {
    printf("No");
  }


  return 0;
}
