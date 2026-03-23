import 'abstract_node.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents a member access expression (e.g., obj.prop, obj["prop"]).
class MemberExpr extends AbstractNode {
  late (String, bool)? _memberInfo;
  late INode? _objInfo;

  @override
  String get marker => String.fromCharCode(0x58);

  @override
  NodeType get nodeType => NodeType.memberExpr;

  @override
  void decode() {
    _memberInfo = decodeReference();
    _objInfo = decodeNode();
  }

  @override
  String prettyPrint() {
    final obj = _objInfo?.prettyPrint() ?? "";
    final memberName = _memberInfo?.$1 ?? "";
    String member = "";

    if (isValidIdentifier(memberName)) {
      member = ".$memberName";
    } else {
      // Use bracket notation if it's not a valid identifier.
      final numericalIndex = int.tryParse(memberName);
      if (numericalIndex != null) {
        member = "[$memberName]";
      } else {
        member = "[\"$memberName\"]";
      }
    }
    return "$obj$member";
  }
}
