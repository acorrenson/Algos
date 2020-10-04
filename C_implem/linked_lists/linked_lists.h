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

int_list_t* create_empty_int_list(void);

int_cell_t* create_int_cell(int val);

// Modification

int pop_int_list(int_list_t* list);

void append_int_list(int val, int_list_t* list);

void destroy_int_list(int_list_t* list);
// Visualisation

void print_int_list(int_list_t* list);