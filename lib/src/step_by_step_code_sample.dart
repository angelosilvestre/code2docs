import 'package:collection/collection.dart';

/// A code sample separated by steps.
///
/// The source code is stored in [codeSegments] and a [CodeBlock] represents a block of code
/// that points to one or more [CodeSegment]s.
class StepByStepCodeSample {
  StepByStepCodeSample({
    required this.title,
    required this.codeSegments,
    required this.steps,
    required this.startingCode,
  });

  /// Title of the code sample.
  final String title;

  /// A [CodeBlock] that must be used as the starting point.
  final CodeBlock startingCode;

  /// Holds the sample code separed in segments.
  ///
  /// Each start or end of a step creates a new segment. Consider the following code:
  ///
  /// ```
  /// void main() {
  ///   //>step:1
  ///   print('hello world');
  ///   //<step:1
  /// }
  /// ```
  /// Here we have three code segments:
  /// 1. `void main() {`
  /// 2. `  print('hello world');`
  /// 3. `}`
  ///
  /// But only two code blocks:
  /// ```
  /// void main() {
  /// }
  /// ```
  /// and
  /// ```
  /// print('hello world');
  /// ```
  final List<CodeSegment> codeSegments;

  /// The steps of this sample.
  ///
  /// Each step has one or more code blocks, which reference [codeSegments] by index.
  final List<CodeSampleStep> steps;

  @override
  String toString() {
    return '[title=$title startingCode=$startingCode segments=$codeSegments steps=$steps]';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepByStepCodeSample &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          startingCode == other.startingCode &&
          const DeepCollectionEquality().equals(steps, other.steps) &&
          const DeepCollectionEquality().equals(codeSegments, other.codeSegments);

  @override
  int get hashCode => title.hashCode ^ steps.hashCode ^ codeSegments.hashCode ^ startingCode.hashCode;
}

/// Represents a step in a step by step code sample.
///
/// A [CodeSampleStep] may have many code blocks.
class CodeSampleStep {
  CodeSampleStep({
    required this.number,
    required this.description,
    required this.codeBlocks,
  });

  final int number;
  final String description;
  final List<CodeBlock> codeBlocks;

  @override
  String toString() {
    return '[number=$number description=$description blocks=$codeBlocks]';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CodeSampleStep &&
          number == other.number &&
          description == other.description &&
          const DeepCollectionEquality().equals(codeBlocks, other.codeBlocks);

  @override
  int get hashCode => number.hashCode ^ description.hashCode ^ codeBlocks.hashCode;
}

/// A block of source code.
///
/// Doesn't store the contents of the block. Instead, it references the code segments by index.
class CodeBlock {
  CodeBlock({
    required this.segments,
    this.description = '',
  });

  /// Description of this code block.
  final String description;

  /// Code segments that are part of this code block.
  ///
  /// Each item in this list represents an index of a code segment.
  final List<int> segments;

  @override
  String toString() {
    return '[description:$description segments:$segments]';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || //
      other is CodeBlock && DeepCollectionEquality().equals(segments, other.segments);

  @override
  int get hashCode => segments.hashCode;
}

/// A list of contiguous lines in a source file.
///
/// A [CodeSegment] holds the actual content.
class CodeSegment {
  CodeSegment({
    required this.lines,
  });

  /// The lines that belong to this segment.
  final List<String> lines;

  @override
  String toString() {
    return '[lines= ${lines.toString()}]';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || //
      other is CodeSegment && const DeepCollectionEquality().equals(lines, other.lines);

  @override
  int get hashCode => lines.hashCode;
}
