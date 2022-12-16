import 'package:code2docs/code2docs.dart';
import 'package:test/test.dart';

import 'examples/nested_sample.dart';
import 'examples/super_editor_sample.dart';

void main() {
  group('parser', () {
    test('parses a snippet description', () {
      final input = """
// code2docs:TITLE: a
// code2docs:STEPS:
// code2docs:1: step 2
// code2docs:>step:1 The description can have
// multiple lines
code
// code2docs:<step
void main() {}
""";
      final parser = StepByStepSourceParser(input);
      final sample = parser.parse();
      expect(sample.steps.first.codeBlocks.first.description, "The description can have\nmultiple lines");
    });

    test('parses nested steps', () {
      final parser = StepByStepSourceParser(nestedSample);
      final sample = parser.parse();

      expect(
        sample,
        StepByStepCodeSample(
          title: 'Creating a test',
          startingCode: CodeBlock(segments: []),
          steps: [
            CodeSampleStep(
              number: 1,
              description: 'Import the test package.',
              codeBlocks: [
                CodeBlock(segments: [0])
              ],
            ),
            CodeSampleStep(
              number: 2,
              description: 'Create the main function.',
              codeBlocks: [
                CodeBlock(segments: [1, 5])
              ],
            ),
            CodeSampleStep(
              number: 3,
              description: 'Create a test group.',
              codeBlocks: [
                CodeBlock(segments: [2, 4])
              ],
            ),
            CodeSampleStep(
              number: 4,
              description: 'Create a test method.',
              codeBlocks: [
                CodeBlock(segments: [3])
              ],
            ),
          ],
          codeSegments: [
            CodeSegment(lines: ["import 'package:test/test.dart';"]),
            CodeSegment(lines: ["  void main() {"]),
            CodeSegment(lines: ["    group('my test group', () {"]),
            CodeSegment(
                lines: """
      test('my test method', () {

      });"""
                    .split('\n')),
            CodeSegment(lines: ["    });"]),
            CodeSegment(lines: ["  }"]),
          ],
        ),
      );
    });
    test('parses steps without nesting', () {
      final parser = StepByStepSourceParser(superEditorSample);

      final doc = parser.parse();

      final expectedSource = StepByStepCodeSample(
        title: 'Creating an unselectable HR.',
        startingCode: CodeBlock(segments: [0, 2]),
        steps: [
          CodeSampleStep(
            number: 1,
            description: "Create a component that returns a `BoxComponent` in the build method.",
            codeBlocks: [
              CodeBlock(segments: [4])
            ],
          ),
          CodeSampleStep(
            number: 2,
            description: "Create a `ComponentBuilder` that returns the custom component.",
            codeBlocks: [
              CodeBlock(segments: [3])
            ],
          ),
          CodeSampleStep(
            number: 3,
            description: "Add the custom `ComponentBuilder` to the editor's componentBuilders.",
            codeBlocks: [
              CodeBlock(
                description: 'Add this code in the end of the `SuperEditor` creation.',
                segments: [1],
              )
            ],
          ),
        ],
        codeSegments: [
          CodeSegment(
            lines: """
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

/// Example of a horizontal rule component that is not directly selectable.
///
/// The user can select around the horizontal rule, but cannot select it, specifically.
class UnselectableHrDemo extends StatefulWidget {
  @override
  _UnselectableHrDemoState createState() => _UnselectableHrDemoState();
}

class _UnselectableHrDemoState extends State<UnselectableHrDemo> {
  late MutableDocument _doc;
  late DocumentEditor _docEditor;

  @override
  void initState() {
    super.initState();
    _doc = _createDocument();
    _docEditor = DocumentEditor(document: _doc);
  }

  @override
  void dispose() {
    _doc.dispose();
    super.dispose();
  }

  MutableDocument _createDocument() {
    return MutableDocument(
      nodes: [
        ParagraphNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText(
            text:
                "Below is a horizontal rule (HR). Normally in a SuperEditor, the user can tap to select an HR. In this case, you can't select the HR. You can only select around it. Try and find out:",
          ),
        ),
        HorizontalRuleNode(id: DocumentEditor.createNodeId()),
        ParagraphNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText(
            text:
                "Duis mollis libero eu scelerisque ullamcorper. Pellentesque eleifend arcu nec augue molestie, at iaculis dui rutrum. Etiam lobortis magna at magna pellentesque ornare. Sed accumsan, libero vel porta molestie, tortor lorem eleifend ante, at egestas leo felis sed nunc. Quisque mi neque, molestie vel dolor a, eleifend tempor odio.",
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SuperEditor(
      editor: _docEditor,
      stylesheet: defaultStylesheet.copyWith(
        documentPadding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
      ),"""
                .split('\n'),
          ),
          CodeSegment(
            lines: """
      
      // Add a new component builder that creates an unselectable
      // horizontal rule, instead of creating the usual selectable kind.
      componentBuilders: [
        const UnselectableHrComponentBuilder(),
        ...defaultComponentBuilders,
      ],"""
                .split('\n'),
          ),
          CodeSegment(
            lines: """
    );
  }
}
"""
                .split('\n'),
          ),
          CodeSegment(
            lines: """
/// SuperEditor [ComponentBuilder] that builds a horizontal rule that is
/// not selectable.
class UnselectableHrComponentBuilder implements ComponentBuilder {
  const UnselectableHrComponentBuilder();

  @override
  SingleColumnLayoutComponentViewModel? createViewModel(Document document, DocumentNode node) {
    // This builder can work with the standard horizontal rule view model, so
    // we'll defer to the standard horizontal rule builder.
    return null;
  }

  @override
  Widget? createComponent(
      SingleColumnDocumentComponentContext componentContext, SingleColumnLayoutComponentViewModel componentViewModel) {
    if (componentViewModel is! HorizontalRuleComponentViewModel) {
      return null;
    }

    return _UnselectableHorizontalRuleComponent(
      componentKey: componentContext.componentKey,
    );
  }
}"""
                .split('\n'),
          ),
          CodeSegment(
            lines: """
class _UnselectableHorizontalRuleComponent extends StatelessWidget {
  const _UnselectableHorizontalRuleComponent({
    Key? key,
    required this.componentKey,
  }) : super(key: key);

  final GlobalKey componentKey;

  @override
  Widget build(BuildContext context) {
    return BoxComponent(
      key: componentKey,
      isVisuallySelectable: false,
      child: const Divider(
        color: Color(0xFF000000),
        thickness: 1.0,
      ),
    );
  }
}"""
                .split('\n'),
          ),
        ],
      );

      expect(doc, expectedSource);
    });

    test("rejects when step doesn't start with one", () {
      final input = """
// code2docs:TITLE: a
// code2docs:STEPS:
// code2docs:2: step 2
void main() {}
""";
      final parser = StepByStepSourceParser(input);
      expect(() => parser.parse(), throwsA(isA<ParserException>()));
    });

    test('rejects steps out of order', () {
      final input = """
// code2docs:TITLE: a
// code2docs:STEPS:
// code2docs:1: step 1
// code2docs:3: step 3
// code2docs:2: step 2
void main() {}
""";
      final parser = StepByStepSourceParser(input);
      expect(() => parser.parse(), throwsA(isA<ParserException>()));
    });
  });
}
