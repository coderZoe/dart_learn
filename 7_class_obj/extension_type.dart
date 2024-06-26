void main() {}

///dart中的扩展类型和扩展方法都是编译时抽象
///什么是编译时抽象，举个例子：
// extension BetterInt on int {
//   int double() => this * this;
// }
//var a = 12; print(a.double);

///如上例子中，我们表面上像是扩展了int类型的方法，但实际这是一种语法糖，在编译阶段，dart就将上述源码改为了：
///int double(int a){return a*a}; var a = 12; print(double(a));
///如上的这种静态方法调用，这就是编译时抽象，也即源码级别抽象，编译时候还原，算是编译时的语法糖
///扩展类型其实也是同理，比如：
// extension type MyInt(int id) {
//   int double() {
//     return id * id;
//   }
// }
///如上代码我们可以通过print(MyInt(23).double());调用，看起来MyInt就像个包装类
///但dart官方文档写了：扩展类型是一种编译时抽象，用不同的静态接口 "包装 "现有类型
///扩展类型的作用与封装类相同，但不需要创建额外的运行时对象，而当需要封装大量对象时，创建额外的运行时对象的成本会很高。由于扩展类型是只静态的，并在运行时编译，因此基本上是零成本
///上面这段话是什么意思呢？以刚才的扩展类型demo为例，上述代码在编译阶段其实也会被编译为类似如下内容：
///int double(int a){return a*a}; var a = 12; print(double(a));
///相当于你在扩展类型里定义的方法也会被变为静态函数，这样的好处是，并不真实存在扩展类型这个类，
///也不会真实的创建扩展类型这个包装对象，所有的调用其实都是静态调用，由于不需要创建运行时对象，所以基本是零成本
///但扩展类型还不同于扩展方法，扩展类型其实提供了一个“视图”的概念，以基础类型为原型，提供视图，重新定义基础类型的方法和属性
///比如上例中，MyInt类型只能调用double方法，调不了int其他的方法
extension type MyInt(int id) {
  int double() {
    return id * id;
  }
}
