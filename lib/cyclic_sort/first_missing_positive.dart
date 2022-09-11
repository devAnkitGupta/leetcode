void main() {
  print(firstMissingPositive([3,4,-1,1]));
}

int firstMissingPositive(List<int> nums) {
    int i = 0;
  while (i < nums.length) {
    int correct = nums[i] - 1;
    if ( nums[i] > 0 && nums[i] <= nums.length && nums[i] != nums[correct]) {
      int temp = nums[correct];
      nums[correct] = nums[i];
      nums[i] = temp;
    } else {
      i++;
    }
  }

  for (int index = 0; index < nums.length; index++) {
    if (nums[index] != index +1 ) {
      return index + 1;
    }
  }
  return nums.length + 1;
}
