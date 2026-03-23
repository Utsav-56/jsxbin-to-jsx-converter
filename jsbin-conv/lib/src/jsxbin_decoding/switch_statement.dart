import 'abstract_node.dart';
import 'argument_list.dart';
import 'inode.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'node_type.dart';

/// Represents a 'switch' statement with case/default branches in JSX.
class SwitchStatement extends AbstractNode implements IStatement {
  late LineInfo _labelInfo;
  late INode? _test;
  late List<INode> _cases;
  late List<INode> _bodies;

  @override
  int get lineNumber => _labelInfo.lineNumber;

  @override
  String get marker => String.fromCharCode(0x63);

  @override
  NodeType get nodeType => NodeType.switchStatement;

  @override
  void decode() {
    _labelInfo = decodeBody();
    _test = decodeNode();
    _cases = [];
    forEachChild(() {
      final r = decodeNode();
      if (r != null) {
        _cases.add(r);
      }
    });

    _bodies = [];
    forEachChild(() {
      final q = decodeNode();
      if (q != null) {
        _bodies.add(q);
      }
    });
  }

  @override
  String prettyPrint() {
    final buffer = StringBuffer();
    final testStr = _test?.prettyPrint() ?? "";
    buffer.writeln("switch ($testStr) {");

    for (int i = 0; i < _cases.length; i++) {
      final caseArgs = (_cases[i] as ArgumentList).arguments;
      String caseStmt = "";
      if (caseArgs.isNotEmpty) {
        caseStmt = caseArgs.map((c) => "case ${c.prettyPrint()}:").join("\n");
      } else {
        caseStmt = "default:";
      }
      buffer.writeln(caseStmt);
      String bodyStmt = "";
      if (i < _bodies.length) {
        bodyStmt = _bodies[i].prettyPrint();
      }
      buffer.writeln(bodyStmt);
    }
    buffer.write("}");
    return buffer.toString();
  }
}
