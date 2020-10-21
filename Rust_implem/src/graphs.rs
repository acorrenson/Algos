type NodeId = usize;

/// A fundamental graph data structure for further
/// implementations.
pub struct Graph<V> {
    values: Vec<V>,
    neighbors: Vec<Vec<NodeId>>,
}

impl<V> Graph<V> {
    pub fn new() -> Self {
        Self {
            values: Vec::new(),
            neighbors: Vec::new(),
        }
    }

    pub fn node(&mut self, value: V) -> NodeId {
        let id = self.values.len();
        self.values.push(value);
        self.neighbors.push(Vec::new());
        id
    }

    pub fn edge(&mut self, start: NodeId, finish: NodeId) {
        if !self.neighbors[start].contains(&finish) {
            self.neighbors[start].push(finish);
        }
    }

    pub fn len(&self) -> usize {
        self.values.len()
    }

    pub fn neighbors(&self, node: NodeId) -> &Vec<NodeId> {
        &self.neighbors[node]
    }

    pub fn dfs<S>(
        &self,
        node: NodeId,
        state: &mut S,
        pre: impl Fn(NodeId, &V, &mut S),
        post: impl Fn(NodeId, &V, &mut S),
    ) {
        fn rec_dfs<V, S>(
            graph: &Graph<V>,
            node: NodeId,
            state: &mut S,
            seen: &mut Vec<bool>,
            pre: &impl Fn(NodeId, &V, &mut S),
            post: &impl Fn(NodeId, &V, &mut S),
        ) {
            seen[node] = true;
            pre(node, &graph.values[node], state);
            for x in graph.neighbors(node) {
                if !seen[*x] {
                    rec_dfs(graph, *x, state, seen, pre, post);
                }
            }
            post(node, &graph.values[node], state);
        };

        rec_dfs(
            self,
            node,
            state,
            &mut self.values.iter().map(|_| false).collect(),
            &pre,
            &post,
        );
    }
}
