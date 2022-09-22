void main() {
  print(Solution().medianSlidingWindow([1, 3, -1, -3, 5, 3, 6, 7], 3));
}

class Solution {
  List<double> medianSlidingWindow(List<int> nums, int k) {
    final minHeap = HeapPriorityQueue<int>(
      (p0, p1) => p0.compareTo(p1),
    );
    final maxHeap = HeapPriorityQueue<int>(
      (p0, p1) => p1.compareTo(p0),
    );
    final List<double> _result = [];

    final numsMap = <int, int>{};

    for (int i = 0; i < nums.length; i++) {
      numsMap[i] = nums[i];
    }

    void add(int num) {
      if (maxHeap.isEmpty || maxHeap.first >= num) {
        maxHeap.add(num);
      } else {
        minHeap.add(num);
      }
    }

    void normalize() {
      final maxSize = maxHeap.length;
      final minSize = minHeap.length;
      if (maxSize - minSize > 1) {
        minHeap.add(maxHeap.removeFirst());
      } else if (maxSize < minSize) {
        maxHeap.add(minHeap.removeFirst());
      }
    }

    double findMedian() {
      if (maxHeap.length == minHeap.length) {
        return (maxHeap.first + minHeap.first) / 2;
      }
      return maxHeap.first.toDouble();
    }

    void remove(int num) {
      if (num <= maxHeap.first) {
        maxHeap.remove(num);
      } else {
        minHeap.remove(num);
      }
    }

    numsMap.forEach((key, value) {
      add(value);
      normalize();
      if (key - k + 1 > 0) {
        _result.add(findMedian());
      }
      remove(nums[key - k + 1]);
    });

    return _result;
  }
}

class HeapPriorityQueue<E> {
  static const int _initialCapacity = 7;
  final Comparator<E> comparison;
  List<E?> _queue = List<E?>.filled(_initialCapacity, null);
  int _length = 0;
  HeapPriorityQueue(int Function(E, E) comparison) : comparison = comparison;

  E _elementAt(int index) => _queue[index] ?? (null as E);

  void add(E element) {
    _add(element);
  }

  void addAll(Iterable<E> elements) {
    for (var element in elements) {
      _add(element);
    }
  }

  void clear() {
    _queue = const [];
    _length = 0;
  }

  bool contains(E object) => _locate(object) >= 0;

  E get first {
    if (_length == 0) throw StateError('No element');
    return _elementAt(0);
  }

  bool get isEmpty => _length == 0;

  bool get isNotEmpty => _length != 0;

  int get length => _length;

  bool remove(E element) {
    var index = _locate(element);
    if (index < 0) return false;
    var last = _removeLast();
    if (index < _length) {
      var comp = comparison(last, element);
      if (comp <= 0) {
        _bubbleUp(last, index);
      } else {
        _bubbleDown(last, index);
      }
    }
    return true;
  }

  Iterable<E> removeAll() {
    var result = _queue;
    var length = _length;
    _queue = const [];
    _length = 0;
    return result.take(length).cast();
  }

  E removeFirst() {
    if (_length == 0) throw StateError('No element');
    var result = _elementAt(0);
    var last = _removeLast();
    if (_length > 0) {
      _bubbleDown(last, 0);
    }
    return result;
  }

  @override
  String toString() {
    return _queue.take(_length).toString();
  }

  void _add(E element) {
    if (_length == _queue.length) _grow();
    _bubbleUp(element, _length++);
  }

  int _locate(E object) {
    if (_length == 0) return -1;
    var position = 1;
    do {
      var index = position - 1;
      var element = _elementAt(index);
      var comp = comparison(element, object);
      if (comp <= 0) {
        if (comp == 0 && element == object) return index;
        var leftChildPosition = position * 2;
        if (leftChildPosition <= _length) {
          position = leftChildPosition;
          continue;
        }
      }
      do {
        while (position.isOdd) {
          position >>= 1;
        }
        position += 1;
      } while (position > _length);
    } while (position != 1);
    return -1;
  }

  E _removeLast() {
    var newLength = _length - 1;
    var last = _elementAt(newLength);
    _queue[newLength] = null;
    _length = newLength;
    return last;
  }

  void _bubbleUp(E element, int index) {
    while (index > 0) {
      var parentIndex = (index - 1) ~/ 2;
      var parent = _elementAt(parentIndex);
      if (comparison(element, parent) > 0) break;
      _queue[index] = parent;
      index = parentIndex;
    }
    _queue[index] = element;
  }

  void _bubbleDown(E element, int index) {
    var rightChildIndex = index * 2 + 2;
    while (rightChildIndex < _length) {
      var leftChildIndex = rightChildIndex - 1;
      var leftChild = _elementAt(leftChildIndex);
      var rightChild = _elementAt(rightChildIndex);
      var comp = comparison(leftChild, rightChild);
      int minChildIndex;
      E minChild;
      if (comp < 0) {
        minChild = leftChild;
        minChildIndex = leftChildIndex;
      } else {
        minChild = rightChild;
        minChildIndex = rightChildIndex;
      }
      comp = comparison(element, minChild);
      if (comp <= 0) {
        _queue[index] = element;
        return;
      }
      _queue[index] = minChild;
      index = minChildIndex;
      rightChildIndex = index * 2 + 2;
    }
    var leftChildIndex = rightChildIndex - 1;
    if (leftChildIndex < _length) {
      var child = _elementAt(leftChildIndex);
      var comp = comparison(element, child);
      if (comp > 0) {
        _queue[index] = child;
        index = leftChildIndex;
      }
    }
    _queue[index] = element;
  }

  void _grow() {
    var newCapacity = _queue.length * 2 + 1;
    if (newCapacity < _initialCapacity) newCapacity = _initialCapacity;
    var newQueue = List<E?>.filled(newCapacity, null);
    newQueue.setRange(0, _length, _queue);
    _queue = newQueue;
  }
}
