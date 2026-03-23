import 'abstract_node.dart';
import 'argument_list.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents an array literal in JSX.
class ArrayExpr extends AbstractNode {
  late INode? _arguments;

  @override
  String get marker => String.fromCharCode(0x41);

  @override
  NodeType get nodeType => NodeType.arrayExpr;

  @override
  void decode() {
    _arguments = decodeNode();
  }

  @override
  String prettyPrint() {
    final args = _arguments as ArgumentList?;
    if (args == null) {
      return "[]";
    }
    return "[${args.arguments.map((a) => a.prettyPrint()).join(", ")}]";
  }
}
