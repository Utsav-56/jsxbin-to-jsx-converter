import 'abstract_node.dart';
import 'node_type.dart';

/// Represents a variable identifier for JSXBIN version 1.0.
class IdNodeVersion1 extends AbstractNode {
  late String _id;

  @override
  String get marker => String.fromCharCode(0x6A);

  @override
  NodeType get nodeType => NodeType.idNode;

  @override
  double get jsxbinVersion => 1.0;

  @override
  void decode() {
    _id = decodeId();
  }

  @override
  String prettyPrint() {
    return _id;
  }
}
