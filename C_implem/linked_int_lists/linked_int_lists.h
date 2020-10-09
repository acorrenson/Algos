/* STRUCTURES */

typedef struct int_cell_t {
    int head;
    struct int_cell_t* tail;
} int_cell_t;

typedef struct int_list_t {
    struct int_cell_t* cell;
} int_list_t;

/* FUNCTIONS */

// Construction

int_list_t* create_empty_int_list(void);

// Modification

int pop_int_list(int_list_t* list);

void insert_head_int_list(int val, int_list_t* list);

void append_int_list(int val, int_list_t* list);

void destroy_int_list(int_list_t* list);

void empty_int_list(int_list_t* list);

// Function with return

int head_int_list(int_list_t* list);

int_list_t* tail_int_list(int_list_t* list);

int length_int_list(int_list_t* list);

// Test

int is_empty_int_list(int_list_t* list);

int mem_int_list(int val, int_list_t* list);

// Visualisation

void print_int_list(int_list_t* list);