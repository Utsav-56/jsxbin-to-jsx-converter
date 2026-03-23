import 'abstract_node.dart';
import 'inode.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'node_type.dart';

/// Represents a 'throw' statement in JSX.
class ThrowStatement extends AbstractNode implements IStatement {
  late LineInfo _lineInfo;
  late INode? _exprInfo;

  @override
  int get lineNumber => _lineInfo.lineNumber;

  @override
  String get marker => String.fromCharCode(0x66);

  @override
  NodeType get nodeType => NodeType.throwStatement;

  @override
  void decode() {
    _lineInfo = decodeLineInfo();
    _exprInfo = decodeNode();
  }

  @override
  String prettyPrint() {
    final body = _exprInfo?.prettyPrint() ?? "";
    return "throw $body";
  }
}
