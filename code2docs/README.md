# This is a work in progress!

Generates step by step samples in markdown using source code delimited by specific comments.

## Defining a step by step sample

Create a source file containing the final code. For example:
```dart
void main() {
    print('hello,');
    print('world');
    print('The end.');
}
```
 At the start of the file, define a title for the sample code and the list of steps:

```dart
// TITLE: This is the sample code.
// STEPS:
// 1: Print hello.
// 2: Print world.
// The description can be multiline.
// 3: Describe step 3.
```

Delimit the start of a code block that belongs to a specific step by preceding the line with a comment containing `//>step:{step number} {block description}`:
```dart
void main() {
    //>step:1 Add this to the beginning of main.
    print('hello,');
    //>step:2 Add this after `print('hello,');`
    print('world');
    //>step:3 The description is optional.
    print('The end.');
}
```

Delimit the end of a code block that belongs to a specific step by following the line with a comment containing `//<step:{step number}`:
```dart
void main() {
    //>step:1 Add this to the beginning of main.
    print('hello,');
    //<step:1
    //>step:2 Add this after `print('hello,');`
    print('world');
    //<step:2
    //>step:3 The description is optional.
    print('The end.');
    //<step:3    
}
```
<details>
  <summary>View generated markdown</summary>

# This is the sample code.

Starting Code
```dart
void main() {
}

```

Print hello.
```dart
    print('hello,');
```
> Add this to the beginning of main.

Print world.
The description can be multiline.
```dart 
    print('world');
```
> Add this after `print('hello,');`

Describe step 3.
```dart 
    print('The end.');
```
> The description is optional.

</details>

## Using this library

```dart
import 'package:code2docs/code2docs.dart';

void main() {
    final generator = SourceCodeSampleToMarkdown(language: 'dart');
    final markdown = generator.generate('source code as string');
    print(markdown);
}
```

## Code sample from super_editor

<details>
  <summary>View source code</summary>

```dart
// TITLE: Creating an unselectable HR.
// STEPS:
// 1: Create a component that returns a `BoxComponent` in the build method.
// 2: Create a `ComponentBuilder` that returns the custom component.
// 3: Add the custom `ComponentBuilder` to the editor's componentBuilders.
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
      ),
      //>step:3 Add this code in the end of the `SuperEditor` creation.
      // Add a new component builder that creates an unselectable
      // horizontal rule, instead of creating the usual selectable kind.
      componentBuilders: [
        const UnselectableHrComponentBuilder(),
        ...defaultComponentBuilders,
      ],
      //<step:3
    );
  }
}

//>step:2
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
}
//<step:2

//>step:1
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
}
//<step:1
```
</details>

<details>
<summary>View Generated Markdown</summary>
 
 # Creating an unselectable HR.

Starting Code
```dart
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
      ),
    );
  }
}

```

Create a component that returns a `BoxComponent` in the build method.
``` dart
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
}
```

Create a `ComponentBuilder` that returns the custom component.
``` dart
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
}
```

Add the custom `ComponentBuilder` to the editor's componentBuilders.
``` dart
      // Add a new component builder that creates an unselectable
      // horizontal rule, instead of creating the usual selectable kind.
      componentBuilders: [
        const UnselectableHrComponentBuilder(),
        ...defaultComponentBuilders,
      ],
```
> Add this code in the end of the `SuperEditor` creation.

</details>