import 'abstract_node.dart';
import 'inode.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'node_type.dart';

/// Represents a standard three-part 'for' loop in JSX.
class ForStatement2 extends AbstractNode implements IStatement {
  late LineInfo _bodyInfo;
  late INode? _initInfo;
  late INode? _testInfo;
  late INode? _updateInfo;

  @override
  int get lineNumber => _bodyInfo.lineNumber;

  @override
  String get marker => String.fromCharCode(0x4B);

  @override
  NodeType get nodeType => NodeType.forStatement2;

  @override
  void decode() {
    _bodyInfo = decodeBody();
    _initInfo = decodeNode();
    _testInfo = decodeNode();
    _updateInfo = decodeNode();
  }

  @override
  String prettyPrint() {
    final label = _bodyInfo.createLabelStmt();
    final body = _bodyInfo.createBody();
    final init = _initInfo?.prettyPrint() ?? "";
    final test = _testInfo?.prettyPrint() ?? "";
    final update = _updateInfo?.prettyPrint() ?? "";

    final buffer = StringBuffer();
    buffer.writeln(
      "$label"
      "for ($init; $test; $update) {",
    );
    buffer.writeln(body);
    buffer.write("}");
    return buffer.toString();
  }
}
