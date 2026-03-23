import 'abstract_node.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents a collection of statements, often within a block or function body.
class StatementList extends AbstractNode implements IStatement {
  late LineInfo _lineInfo;
  late int _length;
  late List<INode> _statements;

  @override
  int get lineNumber => _lineInfo.lineNumber;

  @override
  String get marker => String.fromCharCode(0x62);

  @override
  NodeType get nodeType => NodeType.statementList;

  @override
  void decode() {
    _lineInfo = decodeBody();
    _length = decodeLength();
    _statements = [];
    int i = _length;
    while (i > 0) {
      final node = decodeNode();
      if (node != null) {
        _statements.add(node);
      }
      i--;
    }
    _statements.addAll(decodeChildren());
  }

  @override
  String prettyPrint() {
    final labels = _lineInfo.createLabelStmt();

    // Sort statements by their line numbers.
    final statementsOrdered = List<INode>.from(_statements);
    statementsOrdered.sort((a, b) {
      final lineA = (a as IStatement).lineNumber;
      final lineB = (b as IStatement).lineNumber;
      return lineA.compareTo(lineB);
    });

    final statementsPretty = statementsOrdered.map((f) {
      final bool requiresSemicolon = f.nodeType == NodeType.exprNode;
      String expr = f.prettyPrint();
      if (requiresSemicolon) {
        expr = "$expr;";
      }
      return expr;
    }).toList();

    final block = statementsPretty.join("\n");
    return "$labels$block";
  }
}
