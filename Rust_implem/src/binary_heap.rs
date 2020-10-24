pub struct BinaryHeapVec<K: Ord, V> {
    data: Vec<(K, V)>,
}

impl<K: Ord, V> BinaryHeapVec<K, V> {
    pub fn new() -> Self {
        Self { data: Vec::new() }
    }

    pub fn insert(&mut self, key: K, value: V) {
        let index = self.data.len();
        self.data.push((key, value));
        self.fix_at(index);
    }

    fn fix_at(&mut self, index: usize) {
        if index != 0 {
            let (k, _) = self.data.get(index).expect("invalid index to fix at");

            let parent = (index - 1) / 2;
            let (parent_k, _) = self.data.get(parent).unwrap();
            if k < parent_k {
                self.data.swap(index, parent);
                self.fix_at(parent);
            }
        }
    }

    fn fix_down_at(&mut self, index: usize) {
        if let Some((k_self, _)) = self.data.get(index) {
            let c1 = 2 * index + 1;
            let c2 = 2 * index + 2;

            if let Some((k1, _)) = self.data.get(c1) {
                if let Some((k2, _)) = self.data.get(c2) {
                    // The current index has two children
                    if k_self > k1 || k_self > k2 {
                        if k1 < k2 {
                            self.data.swap(index, c1);
                            self.fix_down_at(c1);
                        } else {
                            self.data.swap(index, c2);
                            self.fix_down_at(c2);
                        }
                    }
                } else {
                    // The current index only has one child
                    if k_self > k1 {
                        self.data.swap(index, c1);
                        self.fix_down_at(c1);
                    }
                }
            }
        }
    }

    pub fn peek_min(&self) -> Option<(&K, &V)> {
        self.data.get(0).map(|x| (&x.0, &x.1))
    }

    pub fn pop_min(&mut self) -> Option<(K, V)> {
        if self.data.len() > 0 {
            let last = self.data.len() - 1;
            self.data.swap(0, last);
            let res = self.data.pop();
            self.fix_down_at(0);
            res
        } else {
            None
        }
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn heap_sort() {
        let to_sort = [25, 15, 46, 0, 37, 82, 1, 54];

        let mut heap = super::BinaryHeapVec::new();

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
