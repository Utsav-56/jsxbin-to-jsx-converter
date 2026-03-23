import 'abstract_node.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents a 'delete' expression in JSX.
class DeleteExpr extends AbstractNode {
  late (String, INode?) _idAndNode;

  @override
  String get marker => String.fromCharCode(0x69);

  @override
  NodeType get nodeType => NodeType.deleteExpr;

  @override
  void decode() {
    _idAndNode = decodeIdAndNode();
  }

  @override
  String prettyPrint() {
    final name = _idAndNode.$1;
    final arg = _idAndNode.$2?.prettyPrint() ?? "";
    return "$name $arg";
  }
}
