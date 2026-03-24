import 'abstract_node.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'node_type.dart';

/// Represents a 'with' statement in JSX.
class WithStatement extends AbstractNode implements IStatement {
  late LineInfo _bodyInfo;
  late String _objName;

  @override
  int get lineNumber => _bodyInfo.lineNumber;

  @override
  String get marker => String.fromCharCode(0x6D);

  @override
  NodeType get nodeType => NodeType.withStatement;

  @override
  void decode() {
    _bodyInfo = decodeLineInfo();
    _objName = decodeNode()?.prettyPrint() ?? "";
  }

  @override
  String prettyPrint() {
    final label = _bodyInfo.createLabelStmt();
    final body = _bodyInfo.createBody();
    final buffer = StringBuffer();
    buffer.writeln(
      "$label"
      "with ($_objName) {",
    );
    buffer.writeln(body);
    buffer.write("}");
    return buffer.toString();
  }
}
