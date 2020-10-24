use std::mem;

pub trait BinaryHeap<K, V> {
    fn insert(&mut self, key: K, value: V);
    fn peek_min(&self) -> Option<(&K, &V)>;
    fn pop_min(&mut self) -> Option<(K, V)>;
}

pub struct BinaryHeapVec<K: Ord, V> {
    data: Vec<(K, V)>,
}

impl<K: Ord, V> BinaryHeapVec<K, V> {
    pub fn new() -> Self {
        Self { data: Vec::new() }
    }

    fn heapify_up_at(&mut self, index: usize) {
        if index != 0 {
            let (k, _) = self.data.get(index).expect("invalid index to heapify at");

            let parent = (index - 1) / 2;
            let (parent_k, _) = self.data.get(parent).unwrap();
            if k < parent_k {
                self.data.swap(index, parent);
                self.heapify_up_at(parent);
            }
        }
    }

    fn heapify_down_at(&mut self, index: usize) {
        if let Some((k_self, _)) = self.data.get(index) {
            let c1 = 2 * index + 1;
            let c2 = 2 * index + 2;

            if let Some((k1, _)) = self.data.get(c1) {
                if let Some((k2, _)) = self.data.get(c2) {
                    // The current index has two children
                    if k_self > k1 || k_self > k2 {
                        if k1 < k2 {
                            self.data.swap(index, c1);
                            self.heapify_down_at(c1);
                        } else {
                            self.data.swap(index, c2);
                            self.heapify_down_at(c2);
                        }
                    }
                } else {
                    // The current index only has one child
                    if k_self > k1 {
                        self.data.swap(index, c1);
                        self.heapify_down_at(c1);
                    }
                }
            }
        }
    }

    pub fn peek_min(&self) -> Option<(&K, &V)> {
        self.data.get(0).map(|x| (&x.0, &x.1))
    }
}

impl<K: Ord, V> BinaryHeap<K, V> for BinaryHeapVec<K, V> {
    fn insert(&mut self, key: K, value: V) {
        let index = self.data.len();
        self.data.push((key, value));
        self.heapify_up_at(index);
    }

    fn peek_min(&self) -> Option<(&K, &V)> {
        self.data.get(0).map(|x| (&x.0, &x.1))
    }

    fn pop_min(&mut self) -> Option<(K, V)> {
        if self.data.len() > 0 {
            let last = self.data.len() - 1;
            self.data.swap(0, last);
            let res = self.data.pop();
            self.heapify_down_at(0);
            res
        } else {
            None
        }
    }
}

#[derive(Debug)]
pub enum BinaryHeapRec<K: Ord, V> {
    Node {
        key: K,
        value: V,
        // Explicit boxing requires us to be aware of
        // any indirection in type definitions
        left: Box<BinaryHeapRec<K, V>>,
        right: Box<BinaryHeapRec<K, V>>,
        size: u32,
    },
    Nil,
}

impl<K: Ord, V> BinaryHeapRec<K, V> {
    pub fn new() -> Self {
        Self::Nil
    }

    fn replace(&mut self, new_key: K, new_value: V) -> Option<(K, V)> {
        match self {
            Self::Node { key, value, .. } => {
                Some((mem::replace(key, new_key), mem::replace(value, new_value)))
            }
            Self::Nil => {
                *self = Self::Node {
                    key: new_key,
                    value: new_value,
                    left: box Self::Nil,
                    right: box Self::Nil,
                    size: 1,
                };
                None
            }
        }
    }

    fn swap(&mut self, other_key: &mut K, other_val: &mut V) {
        match self {
            Self::Nil => panic!("attempted to swap empty heap"),
            Self::Node { key, value, .. } => {
                mem::swap(key, other_key);
                mem::swap(value, other_val);
            }
        }
    }

    fn swap_last_and_pop(&mut self, other_key: &mut K, other_val: &mut V) -> Option<(K, V)> {
        match self {
            Self::Nil => panic!("attempted to swap empty heap"),

            Self::Node {
                left: box Self::Nil,
                ..
            } => {
                // The node has no left child so no children
                self.swap(other_key, other_val);
                self.destruct()
            }

            Self::Node {
                left: left @ box Self::Node { .. },
                right: box Self::Nil,
                size,
                ..
            } => {
                *size -= 1;
                left.swap_last_and_pop(other_key, other_val)
            }

            Self::Node {
                left: left @ box Self::Node { .. },
                right: right @ box Self::Node { .. },
                size,
                ..
            } => {
                *size -= 1;
                if left.is_complete() {
                    right.swap_last_and_pop(other_key, other_val)
                } else {
                    left.swap_last_and_pop(other_key, other_val)
                }
            }
        }
    }

    fn heapify_down(&mut self) {
        match self {
            Self::Nil => (),

            Self::Node {
                left: box Self::Nil,
                ..
            } => (), // The node has no left child so no children

            Self::Node {
                left: left @ box Self::Node { .. },
                right: box Self::Nil,
                key,
                value,
                ..
            } => {
                if left.is_key_smaller_than(key) {
                    left.swap(key, value);
                    left.heapify_down();
                }
            }

            Self::Node {
                left: left @ box Self::Node { .. },
                right: right @ box Self::Node { .. },
                key,
                value,
                ..
            } => {
                if left.is_key_smaller_than(key) || right.is_key_smaller_than(key) {
                    if left.is_smaller_than(right) {
                        left.swap(key, value);
                        left.heapify_down();
                    } else {
                        right.swap(key, value);
                        right.heapify_down();
                    }
                }
            }
        }
    }

    fn size(&self) -> u32 {
        match self {
            Self::Node { size, .. } => *size,
            Self::Nil => 0,
        }
    }

    fn is_key_smaller_than(&self, other_key: &K) -> bool {
        match self {
            Self::Node { key, .. } => *key < *other_key,
            Self::Nil => panic!("tried to compare nil node"),
        }
    }

    fn is_smaller_than(&self, other: &Self) -> bool {
        match (self, other) {
            (Self::Nil, _) | (_, Self::Nil) => panic!("tried to compare nil node"),
            (Self::Node { key: self_key, .. }, Self::Node { key: other_key, .. }) => {
                *self_key < *other_key
            }
        }
    }

    fn is_complete(&self) -> bool {
        (self.size() + 1).is_power_of_two()
    }

    fn destruct(&mut self) -> Option<(K, V)> {
        let node = mem::replace(self, Self::Nil);
        match node {
            Self::Node { key, value, .. } => Some((key, value)),
            Self::Nil => None,
        }
    }
}

impl<K: Ord, V> BinaryHeap<K, V> for BinaryHeapRec<K, V> {
    fn insert(&mut self, key: K, value: V) {
        match self {
            Self::Node {
                left: left @ box Self::Nil,
                key: self_key,
                value: self_value,
                size,
                ..
            } => {
                // The node has no left child so no children
                left.replace(key, value);

                if left.is_key_smaller_than(self_key) {
                    left.swap(self_key, self_value);
                }

                *size += 1;
            }

            Self::Node {
                left: box Self::Node { .. },
                right: right @ box Self::Nil,
                key: self_key,
                value: self_value,
                size,
                ..
            } => {
                // The node has no right child
                right.replace(key, value);

                if right.is_key_smaller_than(self_key) {
                    right.swap(self_key, self_value);
                }

                *size += 1;
            }

            Self::Node {
                left: left @ box Self::Node { .. },
                right: right @ box Self::Node { .. },
                key: self_key,
                value: self_value,
                size,
                ..
            } => {
                // The node has two children
                if left.is_complete() {
                    // The left tree is complete
                    if right.size() == left.size() {
                        left.insert(key, value);

                        if left.is_key_smaller_than(self_key) {
                            left.swap(self_key, self_value);
                        }
                    } else {
                        // Insert in the right tree
                        right.insert(key, value);

                        if right.is_key_smaller_than(self_key) {
                            right.swap(self_key, self_value);
                        }
                    }
                } else {
                    // Insert in the left tree
                    left.insert(key, value);

                    if left.is_key_smaller_than(self_key) {
                        left.swap(self_key, self_value);
                    }
                }

                *size += 1;
            }

            Self::Nil => {
                *self = Self::Node {
                    key,
                    value,
                    left: box Self::Nil,
                    right: box Self::Nil,
                    size: 0,
                };
            }
        }
    }

    fn peek_min(&self) -> Option<(&K, &V)> {
        match self {
            Self::Node { key, value, .. } => Some((key, value)),
            Self::Nil => None,
        }
    }

    // Makes the minimum go down the tree and pop it off
    fn pop_min(&mut self) -> Option<(K, V)> {
        let res = match self {
            Self::Nil => None,

            Self::Node {
                left: box Self::Nil,
                ..
            } => self.destruct(), // The node has no left child so no children

            Self::Node {
                left: left @ box Self::Node { .. },
                right: box Self::Nil,
                key,
                value,
                size,
                ..
            } => {
                *size -= 1;
                left.swap_last_and_pop(key, value)
            }

            Self::Node {
                left: left @ box Self::Node { .. },
                right: right @ box Self::Node { .. },
                key,
                value,
                size,
                ..
            } => {
                *size -= 1;
                if left.is_complete() {
                    right.swap_last_and_pop(key, value)
                } else {
                    left.swap_last_and_pop(key, value)
                }
            }
        };

        self.heapify_down();

        res
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn heap_sort() {
        use super::BinaryHeap;

        let to_sort = [25, 15, 46, 0, 37, 82, 1, 54];

        let mut heap = super::BinaryHeapRec::new();

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
