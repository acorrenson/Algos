build : test.c linked_int_lists.c
	@ mkdir -p ../build/linked_int_lists
	gcc -Wall -Wextra -o ../build/linked_int_lists/test_linked_int_lists test.c linked_int_lists.c

runtest :
	cd ../build/linked_int_lists && ./test_linked_int_lists

clean :
	cd ../build/linked_int_lists && find . ! -name .gitkeep -type f -delete