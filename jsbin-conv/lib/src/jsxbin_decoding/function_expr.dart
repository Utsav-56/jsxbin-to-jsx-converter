import 'abstract_node.dart';
import 'inode.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'node_type.dart';

/// Represents a function expression as a statement.
class FunctionExpr extends AbstractNode implements IStatement {
  late LineInfo _lineInfo;
  late INode? _expr;

  @override
  int get lineNumber => _lineInfo.lineNumber;

  @override
  String get marker => String.fromCharCode(0x4E);

  @override
  NodeType get nodeType => NodeType.functionExpr;

  @override
  void decode() {
    _lineInfo = decodeLineInfo();
    _expr = decodeNode();
  }

  @override
  String prettyPrint() {
    return _expr?.prettyPrint() ?? "";
  }
}
