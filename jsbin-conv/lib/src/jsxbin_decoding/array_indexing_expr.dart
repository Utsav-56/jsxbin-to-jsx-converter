import 'abstract_node.dart';
import 'node_type.dart';

/// Represents accessing an array element by index (e.g., arr[i]).
class ArrayIndexingExpr extends AbstractNode {
  late String _arrayName;
  late String _expr;

  @override
  String get marker => String.fromCharCode(0x51);

  @override
  NodeType get nodeType => NodeType.arrayIndexingExpr;

  @override
  void decode() {
    final array = decodeRefAndNode();
    final exprInfo = decodeNode();
    _arrayName = array.$2?.prettyPrint() ?? array.$1.$1;
    _expr = exprInfo?.prettyPrint() ?? "";
  }

  @override
  String prettyPrint() {
    return "$_arrayName[$_expr]";
  }
}
