const a = 'a';
const b = 'b';

void main() {
  //switch
  var num = 1;
  switch (num) {
    case 1:
      print('1');
    case 2:
      print('2');
  }

  var obj = ['a', 'b'];
  switch (obj) {
    case [a, b]:
      print('a  b $obj');
    case ['c', 'd']:
      print('c  d $obj');
  }

  //解构
  var nums = [1, 2, 3];
  var [num1, num2, num3] = nums;
  print('sum = ${num1 + num2 + num3}');
}
