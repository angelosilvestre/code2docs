import 'package:code2docs/code2docs.dart';

void main() {
  final generator = SourceCodeSampleToMarkdown(language: 'dart');

  final markdown = generator.generate(_sourceCode);

  print(markdown);
}

final _sourceCode =
    """
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
