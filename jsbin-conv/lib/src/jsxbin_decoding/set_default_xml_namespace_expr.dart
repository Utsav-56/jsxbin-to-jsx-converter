import 'abstract_node.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents a 'default xml namespace = ...' statement in JSX.
class SetDefaultXMLNamespaceExpr extends AbstractNode {
  late INode? _setDefaultNamespaceFunctionCall;

  @override
  String get marker => String.fromCharCode(0x6B);

  @override
  NodeType get nodeType => NodeType.setDefaultXMLNamespaceExpr;

  @override
  void decode() {
    _setDefaultNamespaceFunctionCall = decodeNode();
  }

  @override
  String prettyPrint() {
    return _setDefaultNamespaceFunctionCall?.prettyPrint() ?? "";
  }
}
