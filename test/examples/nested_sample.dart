/// Simple test sample with nested steps.
///
/// For example:
/// Step 1
///
///   Step 2
///
/// Continuation of Step 1.
final nestedSample = """
// TITLE: Creating a test
// STEPS:
// 1: Import the test package.
// 2: Create the main function.
// 3: Create a test group.
// 4: Create a test method.
//>step:1
import 'package:test/test.dart';
//<step:1
//>step:2
  void main() {
    //>step:3 Add this to the main function.
    group('my test group', () {
      //>step:4 Add this inside the test group.
      test('my test method', () {

      });
      //<step:4
    });
    //<step:3
  }
//<step:2""";

final nestedSampleMarkdown = """
# Creating a test


Import the test package.
``` 
import 'package:test/test.dart';
```

Create the main function.
``` 
  void main() {
  }
```

Create a test group.
``` 
    group('my test group', () {
    });
```
> Add this to the main function.

Create a test method.
``` 
      test('my test method', () {

      });
```
> Add this inside the test group.
""";
