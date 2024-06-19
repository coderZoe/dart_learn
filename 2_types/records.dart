//dart的record类似于元组（元组是一组固定类型的元素集合）

//如下定义了一个元组，这个元组的类型是(String, String, {int a, bool b}) 其中a和b都是声明了元素名称
//也即dart的records(元组）的类型是 非命名数据类型+命名数据类型
var records = ('first', a: 2, b: true, 'last');
void main() {
  print(records.runtimeType);
  //对于非命名类型 通过$index访问 这里打印的是last
  print(records.$2);
  //对于命名类型 直接可以引用
  print(records.a);
  //元组不可更改
  // records.a = 13;

  //很明显 元组十分的方便 但元组的限制也比较明显 就是表达嵌套解构的时候有些不方便
  //使用命名类型要指定名称
  printPerson((name: 'Tom', age: 12));

  //这个例子中 可以看到dart的类型 有些像鸭子类型 或者说像结构化类型
  var person = ('Lee', 13);
  printPerson2(person);
  printPerson3(person);

  var result = swap((1, 2));
  print('${result.$1},${result.$2}');
  //或者 下面这种下发，这有些类似于解构 写起来还是很好的
  var (numx, numy) = swap((1, 2));
  print('$numx,$numy');

  //对于带命名的解构:
  var (:num1, :num2) = swap2((a: 1, b: 2));
  print('$num1,$num2');
}

//元组的更强势用法，可以简洁快速的构建一个数据类型。如：
//命名类型要用{}包围起来 且命名字段位于所有位置字段之后
//命名字段的名称是record定义或其形状的一部分。具有不同名称的命名字段的两个record具有不同的类型
void printPerson(({String name, int age}) person) {
  print('hello ${person.name}, your age is ${person.age}');
}

//或者我们使用typedef 定义一组由元组定义的类型  这样可以使元组类型复用
typedef MyPerson2 = (String, int);

typedef MyPerson3 = (String, int);

void printPerson2(MyPerson2 person) {
  print('hello ${person.$1}, your age is ${person.$2}');
}

void printPerson3(MyPerson3 person) {
  print('hello ${person.$1}, your age is ${person.$2}');
}

//利用元组 我们很容易实现类似golang中多返回值的功能
(int, int) swap((int, int) numTuple) {
  return (numTuple.$2, numTuple.$1);
}

({int num1, int num2}) swap2(({int a, int b}) numTuple) {
  return (num1: numTuple.b, num2: numTuple.a);
}
