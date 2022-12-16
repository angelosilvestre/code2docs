final multipleBlocksSample = """
// code2docs:TITLE: Multiple blocks sample.
// code2docs:STEPS:
// code2docs:1: Declare the methods.
// code2docs:2: Implement the methods.
// code2docs:>step:1
void method1() {
// code2docs:>step:2 Add this inside method1()
  print('implementation).
// code2docs:<step:2
}

void method2() {
// code2docs:>step:2 Add this inside method2()
  print('implementation).
// code2docs:<step:2
}
// code2docs:<step:1
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
