import 'abstract_node.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents accessing a member of an XML object in JSX.
class XMLAccessorExpr extends AbstractNode {
  late (String, bool)? _reference;
  late INode? _obj;
  late INode? _member;

  @override
  String get marker => String.fromCharCode(0x72);

  @override
  NodeType get nodeType => NodeType.xmlAccessorExpr;

  @override
  void decode() {
    _reference = decodeReference();
    _obj = decodeNode();
    _member = decodeNode();
  }

  @override
  String prettyPrint() {
    final objStr = _obj?.prettyPrint() ?? "";
    final memberStr = _member?.prettyPrint() ?? "";
    return "$objStr.$memberStr";
  }
}
