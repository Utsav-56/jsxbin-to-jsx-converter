import 'abstract_node.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents a binary expression (e.g., a + b, x * y) in JSX.
class BinaryExpr extends AbstractNode {
  late String _opName;
  late INode? _left;
  late INode? _right;
  late String? _literalLeft;
  late String? _literalRight;

  /// The operator name string (e.g., "+", "*").
  late String opName;

  /// The full formatted expression string.
  late String op;

  @override
  String get marker => String.fromCharCode(0x43);

  @override
  NodeType get nodeType => NodeType.binaryExpr;

  @override
  void decode() {
    _opName = decodeId();
    _left = decodeNode();
    _right = decodeNode();
    _literalLeft = decodeVariant();
    _literalRight = decodeVariant();

    final leftExpr = _createExpr(_literalLeft, _left);
    final rightExpr = _createExpr(_literalRight, _right);

    final isUpdateExpr =
        (leftExpr != "" && rightExpr == "") || (leftExpr == "" && rightExpr != "");
    if (isUpdateExpr) {
      final finalOp = leftExpr + rightExpr;
      opName = _opName;
      op = finalOp;
    } else {
      opName = _opName;
      op = "$leftExpr $_opName $rightExpr";
    }
  }

  @override
  String prettyPrint() {
    return op;
  }

  String _createExpr(String? literal, INode? expr) {
    bool requiresParens = false;
    String actualExpr;

    if (expr != null && expr.nodeType == NodeType.binaryExpr) {
      final binaryExpr = expr as BinaryExpr;
      actualExpr = binaryExpr.op;
      requiresParens = true;
      final isAssociativeOp =
          (binaryExpr._opName == "*" && _opName == "*") ||
          (binaryExpr._opName == "+" && _opName == "+");
      if (isAssociativeOp) {
        requiresParens = false;
      }
    } else {
      actualExpr = expr == null ? (literal ?? "") : expr.prettyPrint();
    }

    return requiresParens ? "($actualExpr)" : actualExpr;
  }
}
