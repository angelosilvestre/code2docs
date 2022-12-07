import 'package:code2docs/code2docs.dart';
import 'package:test/test.dart';

import 'examples/multiple_blocks_sample.dart';
import 'examples/nested_sample.dart';
import 'examples/super_editor_sample.dart';

void main() {
  group('markdown generator', () {
    test('serializes nested sample', () {
      final generator = SourceCodeSampleToMarkdown();

      final markdown = generator.generate(nestedSample);

      expect(nestedSampleMarkdown, markdown);
    });

    test('serializes sample without nesting', () {
      final generator = SourceCodeSampleToMarkdown();

      final markdown = generator.generate(superEditorSample);

      expect(markdown, superEditorSampleMarkdown);
    });

    test('serializes sample with multiple blocks', () {
      final generator = SourceCodeSampleToMarkdown();

      final markdown = generator.generate(multipleBlocksSample);

      expect(markdown, multipleBlocksMarkdown);
    });
  });
}
