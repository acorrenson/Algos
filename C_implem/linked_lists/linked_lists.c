#include <stdio.h>
#include <stdlib.h>

/* STRUCTURES */

typedef struct cell_t {
    void* head;
    struct cell_t* tail;
} cell_t;

typedef struct list_t {
    struct cell_t* cell;
    int length;
} list_t;

/* FUNCTIONS */

// Construction

list_t* create_empty_list(void) {
    list_t* l = (list_t*)malloc(sizeof(list_t));
    l->cell = NULL;
    l->length = 0;
    return l;
}

static cell_t* create_cell(void* val) {
    cell_t* cell = (cell_t*)malloc(sizeof(cell_t));
    cell->head = val;
    cell->tail = NULL;
    return cell;
}

// Modification

void* pop_list(list_t* list) {  //list has to not be empty
    void* hd = list->cell->head;
    cell_t* old_cell = list->cell;
    list->cell = list->cell->tail;
    free(old_cell);
    list->length -= 1;
    return hd;
}

void insert_head_list(void* val, list_t* list) {
    cell_t* new_cell = create_cell(val);
    new_cell->tail = list->cell;
    list->cell = new_cell;
    list->length += 1;
}

void append_list(void* val, list_t* list) {
    cell_t* new_cell = create_cell(val);
    cell_t* current_cell = list->cell;
    if (current_cell == NULL) {
        list->cell = new_cell;
    } else {
        while (current_cell->tail != NULL) {
            current_cell = current_cell->tail;
        }
        current_cell->tail = new_cell;
    }
    list->length += 1;
}

static void destroy_cells(cell_t* cell) {
    if (cell != NULL) {
        cell_t* next = cell->tail;
        free(cell);
        destroy_cells(next);
    }
}

void destroy_list(list_t* list) {
    destroy_cells(list->cell);
    free(list);
}

void empty_list(list_t* list) {
    destroy_cells(list->cell);
    list->cell = NULL;
    list->length = 0;
}

// Function with return

void* head_list(list_t* list) {
    return list->cell->head;
}

list_t* tail_list(list_t* list) {  //list has to not be empty
    list_t* l_aux = create_empty_list();
    l_aux->length = list->length - 1;
    l_aux->cell = list->cell->tail;
    return l_aux;
}

int length_list(list_t* list) {
    return list->length;
}

// Test

int is_empty_list(list_t* list) {
    return (list->length <= 0);
}

// Visualisation

void print_list_of_int(list_t* list) {
    void* val;
    printf("[");
    while (list->cell != NULL) {
        val = pop_list(list);
        printf(" %d%s", *((int*) val), (list->cell != NULL) ? ";" : "");
    }
    printf(" ]\n");
}