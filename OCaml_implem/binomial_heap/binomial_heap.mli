type 'a binomial_tree
and 'a binomial_heap

val insert_tree : 'a binomial_tree -> 'a binomial_heap -> 'a binomial_heap

val merge_tree : 'a binomial_tree -> 'a binomial_tree -> 'a binomial_tree

val merge_heap : 'a binomial_heap-> 'a binomial_heap -> 'a binomial_heap

val find_min : 'a binomial_heap -> 'a binomial_tree

val pop_min : 'a binomial_heap -> 'a * 'a binomial_heap

val singleton : 'a -> 'a binomial_tree

val empty : 'a binomial_heap

val insert : 'a -> 'a binomial_heap -> 'a binomial_heap

val insert_list : 'a list -> 'a binomial_heap -> 'a binomial_heap