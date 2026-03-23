import 'abstract_node.dart';
import 'binary_expr.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents a property assignment in JSX (e.g., obj.prop = val, obj.prop += val).
class MemberAssignmentExpr extends AbstractNode {
  late INode? _varNode;
  late INode? _expr;
  late String? _literal;
  late bool _isShorthand;

  @override
  String get marker => String.fromCharCode(0x42);

  @override
  NodeType get nodeType => NodeType.memberAssignmentExpr;

  @override
  void decode() {
    _varNode = decodeNode();
    _expr = decodeNode();
    _literal = decodeVariant();
    _isShorthand = decodeBool();
  }

  @override
  String prettyPrint() {
    final varStr = _varNode?.prettyPrint() ?? "";

    if (_isShorthand) {
      final binaryExpr = _expr as BinaryExpr;
      final assignExpr = _literal ?? binaryExpr.op;
      final opName = binaryExpr.opName;
      return "$varStr $opName= $assignExpr";
    } else {
      final assignExpr = _literal ?? (_expr?.prettyPrint() ?? "");
      return "$varStr = $assignExpr";
    }
  }
}
