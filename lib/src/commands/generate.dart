import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;

import '../../code2docs.dart';

class GenerateCommand extends Command {
  GenerateCommand() {
    argParser.addOption('input', abbr: 'i', mandatory: true);
    argParser.addOption('output', abbr: 'o', mandatory: true);
    argParser.addOption('language', abbr: 'l', defaultsTo: 'dart');
  }

  @override
  String get name => 'generate';

  @override
  String get description => 'Generate the documentation';

  @override
  void run() {
    final args = argResults!;

    final input = args['input'];
    final output = args['output'];
    final language = args['language'];

    final inputDir = Directory(input);
    final outputDir = Directory(path.absolute(output));

    if (!inputDir.existsSync()) {
      throw Exception('Directory $input does not exist');
    }

    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    final fileList = inputDir.listSync();
    for (final fileEntity in fileList) {
      final file = File(fileEntity.absolute.path);
      final fileContents = file.readAsStringSync();

      final generator = SourceCodeSampleToMarkdown(language: language);
      final markdown = generator.generate(fileContents);

      final outputPath = path.join(outputDir.path, '${path.basename(fileEntity.path)}.md');
      final outputFile = File(outputPath);

      outputFile.writeAsStringSync(markdown);
    }
  }
}
