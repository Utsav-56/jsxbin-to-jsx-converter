import 'inode.dart';

/// Information about a logical expression containing operands and associated literal parts.
class LogicalExpInfo {
  late String opName;
  INode? leftExpr;
  String? leftLiteral;
  INode? rightExpr;
  String? rightLiteral;

  /// Returns the string representation of the left side operand.
  String getLeftExp() {
    return _getExpr(leftExpr, leftLiteral);
  }

  /// Returns the string representation of the right side operand.
  String getRightExp() {
    return _getExpr(rightExpr, rightLiteral);
  }

  /// Resolves which representational field should be used for the operand (Node AST vs literal text).
  String _getExpr(INode? expr, String? literal) {
    return expr?.prettyPrint() ?? literal ?? "";
  }
}
