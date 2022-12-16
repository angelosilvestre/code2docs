final multipleBlocksSample = """
/// TITLE: Multiple blocks sample.
/// STEPS:
/// 1: Declare the methods.
/// 2: Implement the methods.
//>step:1
void method1() {
//>step:2 Add this inside method1()
  print('implementation).
//<step:2
}

void method2() {
//>step:2 Add this inside method2()
  print('implementation).
//<step:2
}
//<step:1
""";

final multipleBlocksMarkdown = """
# Multiple blocks sample.


Declare the methods.
``` 
void method1() {
}

void method2() {
}
```

Implement the methods.
``` 
  print('implementation).
```
>Add this inside method1()
``` 
  print('implementation).
```
>Add this inside method2()
""";
