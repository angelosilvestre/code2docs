/// Simple test sample with nested steps.
///
/// For example:
/// Step 1
///
///   Step 2
///
/// Continuation of Step 1.
final nestedSample = """
// code2docs:TITLE: Creating a test
// code2docs:STEPS:
// code2docs:1: Import the test package.
// code2docs:2: Create the main function.
// code2docs:3: Create a test group.
// code2docs:4: Create a test method.
// code2docs:>step:1
import 'package:test/test.dart';
// code2docs:<step:1
// code2docs:>step:2
  void main() {
    // code2docs:>step:3 Add this to the main function.
    group('my test group', () {
      // code2docs:>step:4 Add this inside the test group.
      test('my test method', () {

      });
      // code2docs:<step:4
    });
    // code2docs:<step:3
  }
// code2docs:<step:2""";

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
>Add this to the main function.

Create a test method.
``` 
      test('my test method', () {

      });
```
>Add this inside the test group.
""";
