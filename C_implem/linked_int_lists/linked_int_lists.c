#include <stdio.h>
#include <stdlib.h>

/* STRUCTURES */

typedef struct int_cell_t {
    int head;
    struct int_cell_t* tail;
} int_cell_t;

typedef struct int_list_t {
    struct int_cell_t* cell;
    int length;
} int_list_t;

/* FUNCTIONS */

// Construction

int_list_t* create_empty_int_list(void) {
    int_list_t* l = (int_list_t*)malloc(sizeof(int_list_t));
    l->cell = NULL;
    l->length = 0;
    return l;
}

static int_cell_t* create_int_cell(int val) {
    int_cell_t* cell = (int_cell_t*)malloc(sizeof(int_cell_t));
    cell->head = val;
    cell->tail = NULL;
    return cell;
}

// Modification

int pop_int_list(int_list_t* list) {  //list has to not be empty
    int hd = list->cell->head;
    int_cell_t* old_cell = list->cell;
    list->cell = list->cell->tail;
    free(old_cell);
    list->length -= 1;
    return hd;
}

void insert_head_int_list(int val, int_list_t* list) {
    int_cell_t* new_cell = create_int_cell(val);
    new_cell->tail = list->cell;
    list->cell = new_cell;
    list->length += 1;
}

void append_int_list(int val, int_list_t* list) {
    int_cell_t* new_cell = create_int_cell(val);
    int_cell_t* current_cell = list->cell;
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

static void destroy_int_cells(int_cell_t* cell) {
    if (cell != NULL) {
        destroy_int_cells(cell->tail);
        free(cell);
    }
}

void destroy_int_list(int_list_t* list) {
    destroy_int_cells(list->cell);
    free(list);
}

void empty_int_list(int_list_t* list) {
    destroy_int_cells(list->cell);
    list->cell = NULL;
    list->length = 0;
}

// Function with return

int head_int_list(int_list_t* list) {
    return list->cell->head;
}

int_list_t* tail_int_list(int_list_t* list) { //list has to not be empty
    int_list_t* l_aux = create_empty_int_list();
    l_aux->length = list->length - 1;
    l_aux->cell = list->cell->tail;
    return l_aux;
}

int length_int_list(int_list_t* list) {
    return list->length;
}

// Test

int is_empty_int_list(int_list_t* list) {
    return (list->length <= 0);
}

int mem_int_list(int val, int_list_t* list) {
    int_cell_t* current_cell = list->cell;
    while (current_cell != NULL) {
        if (current_cell->head == val) {
            return 1;
        }
        current_cell = current_cell->tail;
    }
    return 0;
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