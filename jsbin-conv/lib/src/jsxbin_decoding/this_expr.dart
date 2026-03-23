import 'abstract_node.dart';
import 'node_type.dart';

/// Represents 'this' or other self-referencing keyword expressions in JSX.
class ThisExpr extends AbstractNode {
  late (String, bool)? _info;

  @override
  String get marker => String.fromCharCode(0x65);

  @override
  NodeType get nodeType => NodeType.thisExpr;

  @override
  void decode() {
    _info = decodeReference();
  }

  @override
  String prettyPrint() {
    return _info?.$1 ?? "";
  }
}
