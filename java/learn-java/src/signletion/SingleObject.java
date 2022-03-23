package signletion;

// 保证一个类仅有一个实例，并提供一个访问它的全局访问点。
public class SingleObject {
  // 创建 singleObject
  private static SingleObject instance = new SingleObject();

  // 让构造函数为 private,这样类就不会实例化
  private SingleObject(){}

  // 获取唯一可用的对象
  public static SingleObject getInstance(){
    return instance;
  }
  
  public void showMessage(){
    System.out.println("hello world");
  }
}
