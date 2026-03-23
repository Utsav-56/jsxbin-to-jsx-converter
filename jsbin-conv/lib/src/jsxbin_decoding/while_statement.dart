import 'abstract_node.dart';
import 'inode.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'node_type.dart';

/// Represents a 'while' loop in JSX.
class WhileStatement extends AbstractNode implements IStatement {
  late LineInfo _bodyInfo;
  late INode? _condInfo;

  @override
  int get lineNumber => _bodyInfo.lineNumber;

  @override
  String get marker => String.fromCharCode(0x6C);

  @override
  NodeType get nodeType => NodeType.whileStatement;

  @override
  void decode() {
    _bodyInfo = decodeBody();
    _condInfo = decodeNode();
  }

  @override
  String prettyPrint() {
    final cond = _condInfo == null ? "true" : _condInfo?.prettyPrint() ?? "";
    final label = _bodyInfo.createLabelStmt();
    final body = _bodyInfo.createBody();
    final buffer = StringBuffer();
    buffer.writeln(
      "$label"
      "while ($cond) {",
    );
    buffer.writeln(body);
    buffer.write("}");
    return buffer.toString();
  }
}
