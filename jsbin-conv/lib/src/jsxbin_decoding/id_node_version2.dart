import 'abstract_node.dart';
import 'node_type.dart';

/// Represents a variable identifier for JSXBIN version 2.0.
class IdNodeVersion2 extends AbstractNode {
  late String _id;
  late bool _boolVal;

  @override
  String get marker => String.fromCharCode(0x6A);

  @override
  NodeType get nodeType => NodeType.idNode;

  @override
  double get jsxbinVersion => 2.0;

  @override
  void decode() {
    _id = decodeId();
    _boolVal = decodeBool();
  }

  @override
  String prettyPrint() {
    return _id;
  }
}
