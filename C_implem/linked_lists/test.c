#include "linked_lists.h"
#include <stdio.h>
#include <stdlib.h>


int main(int argc, char** argv) {
    list_t* list1 = create_empty_list();
    list_t* list2 = create_empty_list();
    list_t* list3 = create_empty_list();

    for (int i = 0; i <= 100; i++) {
        void* val = malloc(sizeof(int));
        *((int*) val) = i;
        insert_head_list(val, list1);
        insert_head_list(val, list2);
        append_list(val, list3);
    }
    // destroy_int_list(list1);
    empty_list(list2);
    printf("Length of list 1, 2 and 3 : %d, %d, %d\n", length_list(list1), length_list(list2), length_list(list3));

    print_list_of_int(list1);  // Should print [ 100; 99; ... ; 0 ]
    print_list_of_int(list2);  // Should print [ ]
    print_list_of_int(list3);  // Should print [ 0; 1; ... ; 100 ]
    destroy_list(list1);
    destroy_list(list2);
    destroy_list(list3);

}