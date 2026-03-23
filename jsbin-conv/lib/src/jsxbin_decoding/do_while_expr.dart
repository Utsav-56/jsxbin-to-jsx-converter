import 'abstract_node.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'node_type.dart';

/// Represents a 'do-while' loop in JSX.
class DoWhileExpr extends AbstractNode implements IStatement {
  late LineInfo _body;
  late String _test;

  @override
  int get lineNumber => _body.lineNumber;

  @override
  String get marker => String.fromCharCode(0x49);

  @override
  NodeType get nodeType => NodeType.doWhileExpr;

  @override
  void decode() {
    _body = decodeBody();
    _test = decodeNode()?.prettyPrint() ?? "";
  }

  @override
  String prettyPrint() {
    final label = _body.createLabelStmt();
    final bodyExpr = _body.createBody();
    final buffer = StringBuffer();
    buffer.writeln(
      "$label"
      "do {",
    );
    buffer.writeln("  $bodyExpr");
    buffer.write("} while ($_test)");
    return buffer.toString();
  }
}
