import 'abstract_node.dart';
import 'inode.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'node_type.dart';

/// Represents an 'if-else-if-else' logic branch in JSX.
class IfStatement extends AbstractNode implements IStatement {
  late LineInfo body;
  late INode? test;
  late INode? tail;

  @override
  int get lineNumber => body.lineNumber;

  @override
  String get marker => String.fromCharCode(0x4F);

  @override
  NodeType get nodeType => NodeType.ifStatement;

  @override
  void decode() {
    body = decodeLineInfo();
    test = decodeNode();
    tail = decodeNode();
  }

  @override
  String prettyPrint() {
    final buffer = StringBuffer();
    _buildIf(buffer);
    if (!_hasElse()) {
      return buffer.toString();
    }
    _buildTail(buffer);
    return buffer.toString();
  }

  void _buildIf(StringBuffer output) {
    final label = body.createLabelStmt();
    final bodyExpr = body.createBody();
    final testExpr = test?.prettyPrint() ?? "";
    output.writeln(
      "$label"
      "if ($testExpr) {",
    );
    output.writeln(bodyExpr);
    output.write("}");
  }

  void _buildTail(StringBuffer output) {
    var currentTail = tail;
    while (_isElseIf(currentTail)) {
      final elseIf = currentTail as IfStatement;
      _buildElseIf(elseIf, output);
      currentTail = elseIf.tail;
    }
    if (currentTail != null) {
      _buildElse(currentTail, output);
    }
  }

  void _buildElseIf(IfStatement node, StringBuffer output) {
    output.writeln(
      " ${node.body.createLabelStmt()}else if (${node.test?.prettyPrint() ?? ""}) {",
    );
    output.writeln(node.body.createBody());
    output.write("}");
  }

  void _buildElse(INode node, StringBuffer output) {
    output.writeln(" else {");
    output.writeln(node.prettyPrint());
    output.write("}");
  }

  bool _isElseIf(INode? node) {
    return node != null &&
        node.nodeType == NodeType.ifStatement &&
        (node as IfStatement).tail != null;
  }

  bool _hasElse() {
    return tail != null;
  }
}
