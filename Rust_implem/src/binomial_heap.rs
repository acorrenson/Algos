use std::collections::{linked_list::CursorMut, LinkedList};
use std::mem::swap;

/// Min binomial heap.
pub struct BinomialHeap<K: Ord, V> {
    sub_trees: LinkedList<BinomialTree<K, V>>,
}

/// Binomial tree used by the [BinomialHeap] implementation.
pub enum BinomialTree<K: Ord, V> {
    Node(K, V, Vec<BinomialTree<K, V>>),
    Nil,
}

/// Inserts a newly merged tree in its correct place
/// within the tree list.
fn reinsert_tree<K: Ord, V>(
    cursor: &mut CursorMut<BinomialTree<K, V>>,
    mut tree: BinomialTree<K, V>,
) {
    let mut forward_moves = 0;
    while let Some(current) = cursor.current() {
        if current.order() < tree.order() {
            cursor.move_next();
            forward_moves += 1;
        } else if current.order() == tree.order() {
            let current = cursor.remove_current().unwrap();
            tree.merge(current);
        } else {
            break;
        }
    }

    cursor.insert_before(tree);

    // Rewind the cursor
    // This is awful but an unfortunate consequence
    // of LinkedList being a third class citizen in
    // the Rust standard library.
    for _ in 0..forward_moves {
        cursor.move_prev();
    }
}

impl<K: Ord, V> BinomialHeap<K, V> {
    pub fn new() -> Self {
        Self {
            sub_trees: LinkedList::new(),
        }
    }

    pub fn insert(&mut self, key: K, value: V) {
        let new_tree = BinomialTree::Node(key, value, vec![]);
        self.insert_tree(new_tree);
    }

    fn insert_tree(&mut self, tree: BinomialTree<K, V>) {
        let mut sub_trees = LinkedList::new();
        sub_trees.push_front(tree);
        self.merge(BinomialHeap { sub_trees });
    }

    pub fn merge(&mut self, mut other: BinomialHeap<K, V>) {
        let mut c1 = self.sub_trees.cursor_front_mut();
        let mut c2 = other.sub_trees.cursor_front_mut();

        while c1.current().is_some() && c2.current().is_some() {
            let e1 = c1.current().unwrap();
            let e2 = c2.current().unwrap();

            if e1.order() < e2.order() {
                c1.move_next();
            } else if e1.order() > e2.order() {
                let e2 = c2.remove_current().unwrap();
                c1.insert_before(e2);
            } else if e1.order() == e2.order() {
                let mut e1 = c1.remove_current().unwrap();
                let e2 = c2.remove_current().unwrap();

                e1.merge(e2);
                reinsert_tree(&mut c1, e1)
            }
        }

        if c2.current().is_some() {
            // This is O(1) thanks to doubly-linked lists, nice!
            self.sub_trees.append(&mut other.sub_trees);
        }
    }

    pub fn peek_min(&self) -> Option<(&K, &V)> {
        self.sub_trees
            .iter()
            .filter_map(|tree| tree.peek_min())
            .min_by(|(k1, _), (k2, _)| k1.cmp(k2))
    }

    pub fn pop_min(&mut self) -> Option<(K, V)> {
        if self.sub_trees.is_empty() {
            return None;
        }

        let mut cursor = self.sub_trees.cursor_front();
        let mut min_index = 0;
        let mut min_opt = cursor.current().unwrap().peek_min();
        cursor.move_next();
        while let Some(current_index) = cursor.index() {
            let current_value_opt = cursor.current().unwrap().peek_min();
            if let Some(min) = min_opt {
                if let Some(current_value) = current_value_opt {
                    if current_value.0 < min.0 {
                        min_opt = current_value_opt;
                        min_index = current_index;
                    }
                }
            }
            cursor.move_next();
        }

        let mut cursor = self.sub_trees.cursor_front_mut();

        for _ in 0..min_index {
            cursor.move_next();
        }

        cursor
            .remove_current()
            .map(|tree| tree.pop_min())
            .flatten()
            .map(|(min, children)| {
                children.into_iter().for_each(|tree| self.insert_tree(tree));
                min
            })
    }
}

impl<K: Ord, V> BinomialTree<K, V> {
    fn merge(&mut self, mut other: BinomialTree<K, V>) {
        match (&self, &mut other) {
            (_, BinomialTree::Nil) => (),
            (BinomialTree::Nil, _) => *self = other,
            (BinomialTree::Node(k1, _, _), BinomialTree::Node(k2, _, _)) => {
                if k1 > k2 {
                    swap(self, &mut other);
                    self.insert_as_child(other);
                } else {
                    self.insert_as_child(other);
                }
            }
        }
    }

    fn insert_as_child(&mut self, other: BinomialTree<K, V>) {
        match self {
            BinomialTree::Nil => (),
            BinomialTree::Node(_, _, c) => c.push(other),
        }
    }

    fn peek_min(&self) -> Option<(&K, &V)> {
        match self {
            BinomialTree::Nil => None,
            BinomialTree::Node(k, v, _) => Some((&k, &v)),
        }
    }

    fn pop_min(self) -> Option<((K, V), Vec<Self>)> {
        match self {
            BinomialTree::Nil => None,
            BinomialTree::Node(k, v, c) => Some(((k, v), c)),
        }
    }

    fn order(&self) -> usize {
        match self {
            BinomialTree::Nil => 0,
            BinomialTree::Node(_, _, c) => c.len() + 1,
        }
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn binomial_sort() {
        // This is a dumb use of binomial trees.
        // We are trained professionals, do not attempt at home.

        let to_sort = [25, 15, 46, 0, 37, 82, 1, 54];

        let mut heap = super::BinomialHeap::new();

        for x in to_sort.iter() {
            heap.insert(*x, ());
        }

        let mut sorted = Vec::with_capacity(to_sort.len());

        while let Some((k, _)) = heap.pop_min() {
            sorted.push(k);
        }

        assert_eq!(sorted.as_ref(), [0, 1, 15, 25, 37, 46, 54, 82]);
    }
}
