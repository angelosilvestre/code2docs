import 'step_by_step_code_sample.dart';

class StepByStepSourceParser {
  StepByStepSourceParser(String content) {
    _lines = content.split('\n');
  }

  /// A [CodeBlock] that doesn't belong to any step.
  ///
  /// Instead, this block should be used as the starting point.
  final _startingCode = CodeBlock(
    segments: [],
  );

  /// The code segments extracted from the input.
  final _sourceSegments = <CodeSegment>[];

  /// The title of the sample.
  String _title = '';

  /// List of the steps that were parsed.
  final _steps = <CodeSampleStep>[];

  /// Lines of the content being parsed.
  late List<String> _lines;

  /// Index of the current line being parsed.
  int _currentLineIndex = 0;

  /// Indicates whether or not we are at the end of the input.
  bool get _isDone => _currentLineIndex >= _lines.length;

  /// Text of the current line being parsed.
  String get _current => _lines[_currentLineIndex];

  /// Matches the string `// STEPS:`
  final _stepStartRegex = RegExp(r'//\sSTEPS:');

  /// Matches the definition of a step.
  ///
  /// For example: `// 1: Create the main function.`
  final _stepRegex = RegExp(r'//\s(\d+):(.+)');

  /// Matches the title definition.
  ///
  /// For example: `// TITLE: First sample.`
  final _titleRegex = RegExp(r'\s*//\sTITLE:\s?(.*)');

  /// Matches the start of a code block that belongs to a step.
  ///
  /// For example: `//>step:1 Description of the code block.`
  final _blockStartRegex = RegExp(r'\s*//>step:(\d+)(.*)?');

  /// Matches the end of a code block that belongs to a step.
  ///
  /// For example: `//<step:1`
  final _blockEndRegex = RegExp(r'\s*//<step:(\d+)');

  /// Matches a comment.
  final _commentRegex = RegExp(r'//\s*(.*)');

  StepByStepCodeSample parse() {
    if (_isDone) {
      throw Exception('Parsing already done');
    }
    _parseTitle();
    _parseStepList();
    _parseBody();

    return StepByStepCodeSample(
      title: _title,
      startingCode: _startingCode,
      steps: _steps,
      codeSegments: _sourceSegments,
    );
  }

  /// Advances the parser to the next line.
  void _advance() {
    _currentLineIndex += 1;
  }

  /// Parses the title of the sample.
  ///
  /// The title must be in the first line of the source file.
  void _parseTitle() {
    final match = _titleRegex.firstMatch(_current);
    if (match == null) {
      throw Exception('The source must start with a title');
    }

    _title = match.group(1)!.trim();

    // Consume the title line.
    _advance();
  }

  /// Parses the step definitions that are present after the title.
  void _parseStepList() {
    if (!_stepStartRegex.hasMatch(_current)) {
      throw Exception('The code must have a STEPS token');
    }

    // Consume the STEPS line.
    _advance();

    // Parse the lines while we found new steps.
    while (!_isDone) {
      final step = _parseStepDefinition();
      if (step == null) {
        break;
      }

      _steps.add(step);
    }
  }

  /// Parses a step definition.
  ///
  /// A step definition is a comment which starts with the step number, followed by its description.
  /// The description can contain multiple lines.
  CodeSampleStep? _parseStepDefinition() {
    final match = _stepRegex.firstMatch(_current);

    if (match == null) {
      return null;
    }

    // We are at the start of a new step definition.
    // The regex ensures we have a step number and a step description.
    final stepNumber = int.parse(match.group(1)!);
    if (stepNumber <= 0) {
      throw Exception('Step number should be greater than zero');
    }

    final descriptionLines = [match.group(2)!.trim()];

    // Consume the first line of the description.
    _advance();

    // Consume the following lines as description until we find
    // another step or a line which isn't a comment.
    while (!_stepRegex.hasMatch(_current) && !_blockStartRegex.hasMatch(_current)) {
      final match = _commentRegex.firstMatch(_current);
      if (match == null) {
        break;
      }

      descriptionLines.add(match.group(1)!.trim());
      _advance();
    }

    // TODO: validate that the steps are in order.

    return CodeSampleStep(
      number: stepNumber,
      description: descriptionLines.join("\n"),
      codeBlocks: [],
    );
  }

  /// Parses the body of the source file.
  ///
  /// The body starts after the step definitions.
  void _parseBody() {
    while (!_isDone) {
      if (_blockStartRegex.hasMatch(_current)) {
        // We found the start of a block that belongs to a step.
        _parseStepCodeBlock();
      }

      // The current line doesn't belong to a step.
      // Consider it as belonging to the starting code.
      _parseStartingCodeBlock();
    }
  }

  /// Parses a code block that belongs to a specific step.
  ///
  /// This code block starts with a `//step:` followed by a step number
  /// and an optional description.
  void _parseStepCodeBlock() {
    final blockStartMatch = _blockStartRegex.firstMatch(_current);
    // If we are in this method, we must have a block start.
    assert(blockStartMatch != null);

    final stepNumber = int.parse(blockStartMatch!.group(1)!);
    final blockDescription = blockStartMatch.group(2) ?? '';

    if (stepNumber > _steps.length) {
      throw Exception('Step $stepNumber not found');
    }
    final step = _steps[stepNumber - 1];

    final currentCodeBlock = CodeBlock(
      description: blockDescription,
      segments: [],
    );
    step.codeBlocks.add(currentCodeBlock);

    // Consume the step number line.
    _advance();

    // Hold the lines that belong to the current source segment.
    List<String> lines = <String>[];

    while (!_isDone) {
      if (_blockEndRegex.hasMatch(_current)) {
        // We reached the end of the step.
        // Consume the end of step line.
        _advance();
        break;
      }

      // TODO: validate the step number.

      if (_blockStartRegex.hasMatch(_current)) {
        // We found a code block that belongs to another step.
        if (lines.isNotEmpty) {
          currentCodeBlock.segments.add(_sourceSegments.length);
          _sourceSegments.add(CodeSegment(lines: lines));
          // Reset the lines.
          // When we finish parsing the nested code block we create another segment
          // for the remaining lines of the current step.
          lines = <String>[];
        }

        _parseStepCodeBlock();
      }

      lines.add(_current);
      _advance();
    }

    currentCodeBlock.segments.add(_sourceSegments.length);
    _sourceSegments.add(CodeSegment(lines: lines));
  }

  /// Parses the lines that belongs to the starting code until we find
  /// the start of a block that belongs to a step.
  void _parseStartingCodeBlock() {
    final lines = <String>[];
    while (!_isDone && !_blockStartRegex.hasMatch(_current)) {
      lines.add(_current);

      _advance();
    }

    // Ignore a segment if it's empty or contain only empty lines.
    if (lines.isNotEmpty && lines.any((e) => e.isNotEmpty)) {
      _startingCode.segments.add(_sourceSegments.length);
      _sourceSegments.add(CodeSegment(lines: lines));
    }
  }
}
