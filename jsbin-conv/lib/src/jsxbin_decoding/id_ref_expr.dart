import 'abstract_node.dart';
import 'node_type.dart';

/// Represents a reference to an identifier (variable) by its name or ID.
class IdRefExpr extends AbstractNode {
  late (String, bool)? _val;
  late int _type;

  @override
  String get marker => String.fromCharCode(0x56);

  @override
  NodeType get nodeType => NodeType.idRefExpr;

  @override
  void decode() {
    _val = decodeReference();
    _type = decodeLength();
  }

  @override
  String prettyPrint() {
    return _val?.$1 ?? "";
  }
}
