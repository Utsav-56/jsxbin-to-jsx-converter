import 'abstract_node.dart';
import 'node_type.dart';

/// Represents a regular expression literal in JSX.
class RegExpLiteral extends AbstractNode {
  late String _regex;
  late String _flags;

  @override
  String get marker => String.fromCharCode(0x59);

  @override
  NodeType get nodeType => NodeType.regExpLiteral;

  @override
  void decode() {
    _regex = decodeString();
    _flags = decodeString();
  }

  @override
  String prettyPrint() {
    return "/$_regex/$_flags";
  }
}
