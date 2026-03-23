import 'abstract_node.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents a comma-separated list of arguments in a function call.
class ArgumentList extends AbstractNode {
  /// The collection of argument nodes.
  late List<INode> arguments;
  late bool _boolVal;

  @override
  String get marker => String.fromCharCode(0x52);

  @override
  NodeType get nodeType => NodeType.argumentList;

  @override
  void decode() {
    arguments = decodeChildren();
    _boolVal = decodeBool();
  }

  @override
  String prettyPrint() {
    return arguments.map((a) => a.prettyPrint()).join(", ");
  }
}
