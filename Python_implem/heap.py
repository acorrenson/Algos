class Heap:
    """
      Class implementing MinHeap
    """

    def __init__(self):
        self.__values = []

    def __parent(self, i: int):
        """Get the parent of a index"""
        return (i - 1)//2

    def __left(self, i: int):
        """Get the left son of a index"""
        return 2*i + 1

    def __right(self, i: int):
        """Get the right son of a index"""
        return 2*i + 2

    def __val(self, i: int):
        """Get the value stored at a given index"""
        return self.__values[i]

    def __swap(self, i1: int, i2: int):
        """Swap 2 values"""
        tmp = self.__values[i1]
        self.__values[i1] = self.__values[i2]
        self.__values[i2] = tmp

    def __heapify_up(self):
        """
          Requires  : is_heap(self.__values[:-1])
          Ensures   : is_heap(self.__values[::])
          Heapify from the bottom up
        """
        i = len(self.__values) - 1
        while i > 0:
            iparent = self.__parent(i)
            if self.__val(iparent) > self.__val(i):
                self.__swap(i, iparent)
                i = iparent
            else:
                break

    def __heapify_down(self):
        """
          Requires  :     is_heap(self.__values[0::self.__right(0)]) 
                      &&  is_heap(self.__values[self.__right(0)::])
          Ensures   : is_heap(self.__values)
          Heapify from the top down
        """
        i = 0
        while (i_left := self.__left(i)) < self.size():
            i_min = i_left
            if (i_right := self.__right(i)) < self.size():
                if (self.__val(i_right) <= self.__val(i_min)):
                    i_min = i_right
            if self.__val(i) < self.__val(i_min):
                break
            self.__swap(i, i_min)
            i = i_min

    def add(self, value: int):
        """Store a new value in a Heap"""
        self.__values.append(value)
        self.__heapify_up()

    def peek(self):
        """Pop the smallest value in a Heap"""
        self.__swap(0, self.size() - 1)
        ret = self.__values.pop()
        self.__heapify_down()
        return ret

    def size(self):
        """Get the size of the Heap"""
        return len(self.__values)

    def __str__(self):
        return str(self.__values)

    def check(self):
        """Check the Heap invariant"""
        cond = True
        for i in range(self.size()):
            v = self.__val(i)
            if (il := self.__left(i)) < self.size():
                cond = cond and self.__val(il) >= v
            if (ir := self.__right(i)) < self.size():
                cond = cond and self.__val(ir) >= v
        assert cond, "Not A Heap!"


h = Heap()
for i in range(10)[::-1]:
    h.add(i)
    print(h)
    h.check()

for i in range(10):
    print(h.peek(), end=' => ')
    print(h)
    h.check()
