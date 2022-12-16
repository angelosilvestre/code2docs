import 'package:args/command_runner.dart';
import 'package:code2docs/src/commands/generate.dart';

Future<void> main(List<String> arguments) async {
  final runner = CommandRunner("code2docs", "A tool to generate documentation based on source code")
    ..addCommand(GenerateCommand());

  try {
    await runner.run(arguments);
  } on UsageException catch (e) {
    print(e);
  }
}
