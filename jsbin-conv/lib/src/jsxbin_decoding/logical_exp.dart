import 'abstract_node.dart';
import 'logical_exp_info.dart';
import 'node_type.dart';

/// Represents logical expressions like (A && B) or (A || B) in JSX.
class LogicalExp extends AbstractNode {
  late LogicalExpInfo _info;

  @override
  String get marker => String.fromCharCode(0x55);

  @override
  NodeType get nodeType => NodeType.logicalExp;

  @override
  void decode() {
    _info = decodeLogicalExp();
  }

  @override
  String prettyPrint() {
    return "${_info.getLeftExp()} ${_info.opName} ${_info.getRightExp()}";
  }
}
