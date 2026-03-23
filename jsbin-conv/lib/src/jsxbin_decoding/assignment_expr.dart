import 'abstract_node.dart';
import 'binary_expr.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents an assignment operation in JSX.
class AssignmentExpr extends AbstractNode {
  late String _varName;
  late bool _isDeclaration;
  late bool _isShorthand;
  late INode? _expr;
  late String? _literal;

  @override
  String get marker => String.fromCharCode(0x53);

  @override
  NodeType get nodeType => NodeType.assignmentExpr;

  @override
  void decode() {
    _varName = decodeId();
    decodeLength(); // consume Type/Length info
    _expr = decodeNode();
    _literal = decodeVariant();
    _isShorthand = decodeBool();
    _isDeclaration = decodeBool();
  }

  @override
  String prettyPrint() {
    final varKeyword = _isDeclaration ? "var " : "";
    String result = "";

    if (_isShorthand) {
      final binaryExpr = _expr as BinaryExpr;
      final assignExpr = _literal ?? binaryExpr.op;
      final opName = binaryExpr.opName;
      result = "$varKeyword$_varName $opName= $assignExpr";
    } else {
      final assignExpr = _literal ?? (_expr?.prettyPrint() ?? "");
      result = "$varKeyword$_varName = $assignExpr";
    }

    return result;
  }
}
