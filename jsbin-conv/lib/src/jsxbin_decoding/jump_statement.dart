import 'abstract_node.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'node_type.dart';

/// Represents 'break' and 'continue' statements in a loop.
class JumpStatement extends AbstractNode implements IStatement {
  late LineInfo _labelInfo;
  late String _jmpLocation;
  late bool _isBreakStatement;

  @override
  int get lineNumber => _labelInfo.lineNumber;

  @override
  String get marker => String.fromCharCode(0x44);

  @override
  NodeType get nodeType => NodeType.jumpStatement;

  @override
  void decode() {
    _labelInfo = decodeLineInfo();
    _jmpLocation = decodeId();
    _isBreakStatement = decodeBool();
  }

  @override
  String prettyPrint() {
    String jmp = _labelInfo.createLabelStmt();
    if (_isBreakStatement) {
      jmp += "break $_jmpLocation";
    } else {
      jmp += "continue $_jmpLocation";
    }
    jmp += ";";
    return jmp;
  }
}
