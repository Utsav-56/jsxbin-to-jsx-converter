import 'abstract_node.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents the top-level node in a JSXBIN AST.
class RootNode extends AbstractNode {
  late INode? _child;

  /// The static marker used for root nodes, not appearing in binary.
  static const String rootMarker = "ROOT";

  @override
  String get marker => rootMarker;

  @override
  NodeType get nodeType => NodeType.root;

  @override
  void decode() {
    _child = decodeNode();
  }

  @override
  String prettyPrint() {
    return _child?.prettyPrint() ?? "";
  }
}
