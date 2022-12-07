import 'parser.dart';
import 'step_by_step_code_sample.dart';

class SourceCodeSampleToMarkdown {
  SourceCodeSampleToMarkdown({this.language});
  final String? language;

  String generate(String content) {
    StringBuffer buffer = StringBuffer();
    final parser = StepByStepSourceParser(content);

    final sample = parser.parse();

    buffer.writeln('# ${sample.title}\n');

    _generateStartingCode(buffer, sample.startingCode, sample.codeSegments);

    for (final step in sample.steps) {
      _generateStep(buffer, step, sample.codeSegments);
    }

    return buffer.toString();
  }

  void _generateStartingCode(StringBuffer buffer, CodeBlock startingCode, List<CodeSegment> segments) {
    if (startingCode.segments.isEmpty) {
      return;
    }

    buffer.writeln('Starting Code');

    buffer.writeln('```dart');
    final parts = startingCode.segments.map((e) => segments[e]).toList();
    for (final part in parts) {
      for (final line in part.lines) {
        buffer.writeln(line);
      }
    }

    buffer.writeln('```');
  }

  void _generateStep(StringBuffer buffer, CodeSampleStep step, List<CodeSegment> segments) {
    buffer.writeln();
    buffer.writeln(step.description);

    for (final block in step.codeBlocks) {
      buffer.writeln('``` ${language ?? ''}');
      final parts = block.segments.map((e) => segments[e]).toList();
      for (final part in parts) {
        for (final line in part.lines) {
          buffer.writeln(line);
        }
      }
      buffer.writeln('```');
      if (block.description.isNotEmpty) {
        buffer.writeln('>${block.description}');
      }
    }
  }
}
