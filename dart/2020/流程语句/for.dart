void main() {
  final List arr = [1, 2, 3, 4];

  final Set set1 = {1, 2, 3, 5};

  int num1 = 5;

  for (int i = 0; i < arr.length; i++) {
    print(arr[i]);
  }

  for (var obj in set1) {
    print(obj);
  }

  while (set1.length < 10) {
    set1.add(num1 + 1);
  }

  print(set1);
}
