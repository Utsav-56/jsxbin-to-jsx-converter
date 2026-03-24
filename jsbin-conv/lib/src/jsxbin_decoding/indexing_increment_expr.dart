import 'abstract_node.dart';
import 'node_type.dart';

/// Represents increment/decrement on an indexed member (e.g., arr[i]++).
class IndexingIncrementExpr extends AbstractNode {
  late String _varName;
  late int _addOrSubtract;
  late bool _isPostfix;

  @override
  String get marker => String.fromCharCode(0x50);

  @override
  NodeType get nodeType => NodeType.indexingIncrementExpr;

  @override
  void decode() {
    _varName = decodeNode()?.prettyPrint() ?? "";
    _addOrSubtract = decodeLiteralNumber2();
    _isPostfix = decodeBool();
  }

  @override
  String prettyPrint() {
    final op = _addOrSubtract == 1 ? "++" : "--";
    return _isPostfix ? "$_varName$op" : "$op$_varName";
  }
}
