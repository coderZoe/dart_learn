//类型
typedef IntList = List<int>;
//删除
typedef Compare<T> = int Function(T a, T b);

int intCompare(int a, int b) => a - b;

void main() {
  IntList list = [1, 2, 3];
  print(intCompare is Compare<int>);
}
