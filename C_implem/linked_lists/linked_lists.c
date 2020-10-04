#include <stdio.h>
#include <stdlib.h>

/* STRUCTURES */

typedef struct int_cell_t {
    int head;
    struct int_cell_t* tail;
} int_cell_t;

typedef struct int_list_t {
    struct int_cell_t* cell;
} int_list_t;

/* FONCTIONS */

// Construction

int_list_t* create_empty_int_list(void) {
    int_list_t* l = (int_list_t*)malloc(sizeof(int_list_t));
    l->cell = NULL;
    return l;
}

int_cell_t* create_int_cell(int val) {
    int_cell_t* cell = (int_cell_t*)malloc(sizeof(int_cell_t));
    cell->head = val;
    cell->tail = NULL;
    return cell;
}

// Modification

int pop_int_list(int_list_t* list) {  //list has to not be empty
    int hd = list->cell->head;
    list->cell = list->cell->tail;
    return hd;
}

void append_int_list(int val, int_list_t* list) {
    int_cell_t* new_cell = create_int_cell(val);
    new_cell->tail = list->cell;
    list->cell = new_cell;
}

// Visualisation

void print_int_list(int_list_t* list) {
    int element;
    printf("[");
    while (list->cell != NULL) {
        element = pop_int_list(list);
        printf(" %d%s", element, (list->cell != NULL) ? ";" : "");
    }
    printf(" ]\n");
}