import 'abstract_node.dart';
import 'const_declaration_info.dart';
import 'node_type.dart';

/// Represents a constant variable declaration in JSX.
class ConstDeclaration extends AbstractNode {
  late ConstDeclarationInfo _info;

  @override
  String get marker => String.fromCharCode(0x47);

  @override
  NodeType get nodeType => NodeType.constDeclaration;

  @override
  void decode() {
    _info = decodeConstDeclaration();
  }

  @override
  String prettyPrint() {
    final name = _info.name;
    final value = _info.getValue();
    return "const $name = $value";
  }
}
