void main() {
  print(deleteDuplicates(ListNode()));
}

ListNode? deleteDuplicates(ListNode? head) {
  ListNode? current = head;

  while (current != null && current.next != null) {
    if (current.val == current.next!.val) {
      current.next = current.next?.next;
    } else {
      current = current.next;
    }
  }
  return head;
}

class ListNode {
  int val;
  ListNode? next;
  ListNode([this.val = 0, this.next]);
}
