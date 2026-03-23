import 'abstract_node.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'node_type.dart';

/// Represents a 'debugger' statement in JSX.
class DebuggerStatement extends AbstractNode implements IStatement {
  late LineInfo _lineInfo;

  @override
  int get lineNumber => _lineInfo.lineNumber;

  @override
  String get marker => String.fromCharCode(0x48);

  @override
  NodeType get nodeType => NodeType.debuggerStatement;

  @override
  void decode() {
    _lineInfo = decodeLineInfo();
  }

  @override
  String prettyPrint() {
    final label = _lineInfo.createLabelStmt();
    return "$label"
        "debugger";
  }
}
