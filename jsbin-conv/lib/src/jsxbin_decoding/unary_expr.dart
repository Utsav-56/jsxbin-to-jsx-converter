import 'abstract_node.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents a unary expression (+, -, !, ~, typeof, etc.) in JSX.
class UnaryExpr extends AbstractNode {
  late String _op;
  late INode? _expr;

  @override
  String get marker => String.fromCharCode(0x68);

  @override
  NodeType get nodeType => NodeType.unaryExpr;

  @override
  void decode() {
    _op = decodeId();
    _expr = decodeNode();
  }

  @override
  String prettyPrint() {
    final exprNode = _expr;
    if (exprNode == null) return _op;

    // Check if adding parentheses around the expression is necessary.
    final bool requiresParens =
        exprNode.nodeType != NodeType.idNode &&
        exprNode.nodeType != NodeType.idRefExpr &&
        exprNode.nodeType != NodeType.functionCallExpr &&
        exprNode.nodeType != NodeType.memberExpr &&
        exprNode.nodeType != NodeType.arrayIndexingExpr;

    final exprStr = exprNode.prettyPrint();
    final exprWithParens = requiresParens ? "($exprStr)" : exprStr;

    return "$_op$exprWithParens";
  }
}
