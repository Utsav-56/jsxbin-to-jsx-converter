import 'abstract_node.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents a ternary conditional expression (e.g., cond ? trueExpr : falseExpr).
class ConditionalExpr extends AbstractNode {
  late INode? _condition;
  late INode? _ifTrue;
  late INode? _ifFalse;

  @override
  String get marker => String.fromCharCode(0x64);

  @override
  NodeType get nodeType => NodeType.conditionalExpr;

  @override
  void decode() {
    _condition = decodeNode();
    _ifTrue = decodeNode();
    _ifFalse = decodeNode();
  }

  @override
  String prettyPrint() {
    final condStr = _condition?.prettyPrint() ?? "";
    final trueStr = _requiresParens(_ifTrue)
        ? "(${_ifTrue?.prettyPrint()})"
        : (_ifTrue?.prettyPrint() ?? "");
    final falseStr = _requiresParens(_ifFalse)
        ? "(${_ifFalse?.prettyPrint()})"
        : (_ifFalse?.prettyPrint() ?? "");

    return "$condStr ? $trueStr : $falseStr";
  }

  bool _requiresParens(INode? node) {
    if (node == null) return false;
    return node.nodeType == NodeType.conditionalExpr ||
        node.nodeType == NodeType.argumentList;
  }
}
