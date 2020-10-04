#include "linked_lists.h"

int main(int argc, char** argv) {
    int_list_t* list = create_empty_int_list();
    for (int i = 0; i <= 100; i++) {
        append_int_list(i, list);
    }
    print_int_list(list);
}