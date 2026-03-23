import 'abstract_node.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents E4X XML descendant access (e.g., xml..descendant) in JSX.
class XMLDoubleDotDescendantsExpr extends AbstractNode {
  late (String, bool)? _descendants;
  late INode? _obj;

  @override
  String get marker => String.fromCharCode(0x71);

  @override
  NodeType get nodeType => NodeType.xmlDoubleDotDescendantsExpr;

  @override
  void decode() {
    _descendants = decodeReference();
    _obj = decodeNode();
    // Consume extra nodes as in original C# decoder.
    decodeNode();
    decodeNode();
  }

  @override
  String prettyPrint() {
    final objStr = _obj?.prettyPrint() ?? "";
    final descName = _descendants?.$1 ?? "";
    return "$objStr..$descName";
  }
}
