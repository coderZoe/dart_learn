void main() {
  const apple = Fruit.APPLE;
  print(apple);
  print(Fruit.APPLE.index);
  //返回的其实是List<Fruit>
  var list = Fruit.values;
  print(list);
}

///dart的枚举与其他语言如Java的枚举基本差不多，但dart增强型枚举有一些约束：
///1. 属性必须是final 构造函数必须是const
///2. 不能extend其他类(也不能被其他类扩展，implements或者mixin，这是因为枚举本身是sealed)
///3. 不能覆盖Object的hashCode == 和index函数
///4. 属性名不能是index和values 因为会和自动生成的静态 getter冲突
///5. 枚举的所有实例都必须在声明的开头声明，并且必须至少声明一个实例

enum Fruit {
  BANANA('香蕉'),
  APPLE('苹果'),
  ;

  final String name;
  const Fruit(this.name);
}
