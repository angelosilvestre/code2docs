/// This sample shows the creation of a unselectable component in `SuperEditor`.
final superEditorSample = """
// code2docs:TITLE: Creating an unselectable HR.
// code2docs:STEPS:
// code2docs:1: Create a component that returns a `BoxComponent` in the build method.
// code2docs:2: Create a `ComponentBuilder` that returns the custom component.
// code2docs:3: Add the custom `ComponentBuilder` to the editor's componentBuilders.
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
      // code2docs:>step:3 Add this code in the end of the `SuperEditor` creation.
      
      // Add a new component builder that creates an unselectable
      // horizontal rule, instead of creating the usual selectable kind.
      componentBuilders: [
        const UnselectableHrComponentBuilder(),
        ...defaultComponentBuilders,
      ],
      // code2docs:<step:3
    );
  }
}

// code2docs:>step:2
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
// code2docs:<step:2

// code2docs:>step:1
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
// code2docs:<step:1
""";

final superEditorSampleMarkdown = """
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
``` 
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
``` 
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
``` 
      
      // Add a new component builder that creates an unselectable
      // horizontal rule, instead of creating the usual selectable kind.
      componentBuilders: [
        const UnselectableHrComponentBuilder(),
        ...defaultComponentBuilders,
      ],
```
>Add this code in the end of the `SuperEditor` creation.
""";
