#include "linked_lists.h"
#include <stdio.h>

int main(int argc, char** argv) {
    int_list_t* list1 = create_empty_int_list();
    int_list_t* list2 = create_empty_int_list();
    int_list_t* list3 = create_empty_int_list();

    for (int i = 0; i <= 100; i++) {
        insert_head_int_list(i, list1);
        insert_head_int_list(i, list2);
        append_int_list(i, list3);
    }
    // destroy_int_list(list1);
    empty_int_list(list2);
    printf("Length of list 1, 2 and 3 : %d, %d, %d\n", length_int_list(list1), length_int_list(list2), length_int_list(list3));

    print_int_list(list1);  // Should print [ 100; 99; ... ; 0 ]
    print_int_list(list2);  // Should print [ ]
    print_int_list(list3);  // Should print [ 0; 1; ... ; 100 ]
}