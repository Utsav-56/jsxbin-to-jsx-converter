import 'abstract_node.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents a node containing an expression that acts as a statement.
class ExprNode extends AbstractNode implements IStatement {
  late LineInfo _lineInfo;
  late INode? _expr;

  @override
  int get lineNumber => _lineInfo.lineNumber;

  @override
  String get marker => String.fromCharCode(0x4A);

  @override
  NodeType get nodeType => NodeType.exprNode;

  /// The expression associated with this node.
  INode? get expr => _expr;

  @override
  void decode() {
    _lineInfo = decodeLineInfo();
    _expr = decodeNode();
  }

  @override
  String prettyPrint() {
    final labels = _lineInfo.createLabelStmt();
    return "$labels${_expr?.prettyPrint() ?? ""}";
  }
}
