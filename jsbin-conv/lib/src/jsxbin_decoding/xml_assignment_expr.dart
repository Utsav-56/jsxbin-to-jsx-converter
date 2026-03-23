import 'abstract_node.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents assignment/interpolation within XML literals in JSX.
class XMLAssignmentExpr extends AbstractNode {
  late String _expr;

  @override
  String get marker => String.fromCharCode(0x6F);

  @override
  NodeType get nodeType => NodeType.xmlAssignmentExpr;

  @override
  void decode() {
    const int typeNormal = 0;
    // Other types represent placeholders/interpolations.

    final buffer = StringBuffer();
    forEachChild(() {
      final child = decodeNode();
      final type = decodeLength();

      if (child != null) {
        if (type == typeNormal) {
          buffer.write(child.prettyPrint());
        } else {
          // Wrap placeholder values in a way that implies string concatenation.
          buffer.write(" + ${child.prettyPrint()} + ");
        }
      }
    });
    _expr = buffer.toString();
  }

  @override
  String prettyPrint() {
    return _expr;
  }
}
