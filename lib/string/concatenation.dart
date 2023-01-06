//LC 30
void main() {
  print(Solution().findSubstring('barfoothefoobarman', ["foo", "bar"]));
}
//{ foo : 1,
//  bar : 1, }

class Solution {
  List<int> findSubstring(String s, List<String> words) {
    List<int> ans = [];

    int len = words[0].length;

    Map<String, int> map = {};

    setMap(map, words);

    for (int i = 0; i <= s.length - len * words.length; i++) {
      Map<String, int> copyMap = {...map};

      for (int j = 0; j < words.length; j++) {
        String str = s.substring(i + j * len, i + j * len + len);
        if (copyMap.containsKey(str)) {
          int count = copyMap[str]!;
          if (count == 1)
            copyMap.remove(str);
          else
            copyMap.putIfAbsent(str, () => (count - 1));

          if (copyMap.isEmpty) {
            ans.add(i);
            break;
          }
        } else {
          break;
        }
      }
    }
    return ans;
  }

  void setMap(Map<String, int> lookUp, List<String> words) {
    words.forEach((element) {
      lookUp.addAll({element: 1});
    });
  }
}
