build : test.c linked_lists.c
	@ mkdir -p ../build/linked_lists
	gcc -Wall -Wextra -o ../build/linked_lists/test_linked_lists test.c linked_lists.c

runtest :
	cd ../build/linked_lists && ./test_linked_lists

clean :
	cd ../build/linked_lists && find . ! -name .gitkeep -type f -delete