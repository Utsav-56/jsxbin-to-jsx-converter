import 'inode.dart';

/// Holds line number information and labels for a specific node in the AST.
class LineInfo {
  int lineNumber = 0;
  INode? child;
  List<String> labels = [];

  /// Formats all labels into a string of JavaScript label statements.
  String createLabelStmt() {
    if (labels.isEmpty) return "";
    return labels.map((s) => "$s: ").join("\n");
  }

  /// Returns the pretty-printed content of the associated [child] node.
  String createBody() {
    return child?.prettyPrint() ?? "";
  }
}
