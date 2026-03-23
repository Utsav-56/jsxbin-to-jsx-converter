import 'abstract_node.dart';
import 'node_type.dart';

/// Represents a simple literal value node in JSX.
class ValueNode extends AbstractNode {
  late String _value;

  @override
  String get marker => String.fromCharCode(0x46);

  @override
  NodeType get nodeType => NodeType.valueNode;

  @override
  void decode() {
    _value = decodeVariantCore();
  }

  @override
  String prettyPrint() {
    return _value;
  }
}
