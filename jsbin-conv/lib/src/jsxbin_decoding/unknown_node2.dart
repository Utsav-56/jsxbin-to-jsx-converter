import 'abstract_node.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents an currently unhandled/unknown node in JSXBIN.
class UnknownNode2 extends AbstractNode {
  late (String, INode?) _idAndNode;

  @override
  String get marker => String.fromCharCode(0x73);

  @override
  NodeType get nodeType => NodeType.unknownNode2;

  @override
  void decode() {
    _idAndNode = decodeIdAndNode();
  }

  @override
  String prettyPrint() {
    throw UnsupportedError("UnknownNode2 prettyPrint is not defined.");
  }
}
