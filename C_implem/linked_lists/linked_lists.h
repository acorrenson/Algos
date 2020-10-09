/* STRUCTURES */

typedef struct cell_t {
    void* head;
    struct cell_t* tail;
} cell_t;

typedef struct list_t {
    struct cell_t* cell;
    int length;
} list_t;

/* FONCTIONS */

// Construction

list_t* create_empty_list(void);

// Modification

int pop_list(list_t* list); //list has to not be empty

void insert_head_list(void* val, list_t* list);

void append_list(void* val, list_t* list);

void destroy_list(list_t* list);

void empty_list(list_t* list);

// Function with return

int head_list(list_t* list);

list_t* tail_list(list_t* list); //list has to not be empty

int length_list(list_t* list);

// Test

int is_empty_list(list_t* list);

// Visualisation

void print_list_of_int(list_t* list);