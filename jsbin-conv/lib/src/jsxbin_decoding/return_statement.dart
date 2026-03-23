import 'abstract_node.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents a 'return' statement in a function.
class ReturnStatement extends AbstractNode implements IStatement {
  late LineInfo _lineInfo;
  late INode? _exprInfo;

  @override
  int get lineNumber => _lineInfo.lineNumber;

  @override
  String get marker => String.fromCharCode(0x5A);

  @override
  NodeType get nodeType => NodeType.returnStatement;

  @override
  void decode() {
    _lineInfo = decodeLineInfo();
    _exprInfo = decodeNode();
  }

  @override
  String prettyPrint() {
    final returnExprStr = _exprInfo == null ? "" : " ${_exprInfo?.prettyPrint() ?? ""}";
    final label = _lineInfo.createLabelStmt();
    return "$label"
        "return$returnExprStr;";
  }
}
