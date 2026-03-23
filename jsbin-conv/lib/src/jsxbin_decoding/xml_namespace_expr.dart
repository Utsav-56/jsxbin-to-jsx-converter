import 'abstract_node.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents E4X XML namespace expressions (e.g., xml.ns::tag) in JSX.
class XMLNamespaceExpr extends AbstractNode {
  late (String, bool)? _namespaceObj;
  late INode? _obj;
  late String _xmlId;

  @override
  String get marker => String.fromCharCode(0x70);

  @override
  NodeType get nodeType => NodeType.xmlNamespaceExpr;

  @override
  void decode() {
    _namespaceObj = decodeReference();
    _obj = decodeNode();
    // Consume extra tokens.
    decodeNode();
    decodeNode();
    _xmlId = decodeId();
  }

  @override
  String prettyPrint() {
    final nsInfo = _namespaceObj;
    if (nsInfo == null) return "${_obj?.prettyPrint() ?? ""}::$_xmlId";

    final bool isQualified = nsInfo.$2;
    final ns = isQualified ? "@${nsInfo.$1}" : nsInfo.$1;
    final objStr = _obj?.prettyPrint() ?? "";

    return "$objStr.$ns::$_xmlId";
  }
}
