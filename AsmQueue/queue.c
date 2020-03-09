#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>

typedef struct node {
    int data;
    struct node *next;
} Node;

typedef struct {
    Node *front, *back;
} Queue;

extern void queue_enqueue(Queue *queue, int data);
extern int queue_dequeue(Queue *queue);
extern int queue_front(const Queue *queue);
extern bool queue_is_empty(const Queue *queue);

Queue *new_queue() {
    Queue *queue = malloc(sizeof(Queue));
    queue->front = queue->back = NULL;
    return queue;
}

int main() {
    Queue *queue = new_queue();
    printf("%d\n", queue_is_empty(queue));
    queue_enqueue(queue, 1);
    queue_enqueue(queue, 2);
    int x = queue_dequeue(queue);
    int y = queue_dequeue(queue);

    return 0;
}
