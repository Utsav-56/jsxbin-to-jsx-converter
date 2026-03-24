import 'abstract_node.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'node_type.dart';

/// Represents a 'for-in' loop for JSXBIN version 1.0.
class ForInStatementVersion1 extends AbstractNode implements IStatement {
  late LineInfo _bodyInfo;
  late String _loopVarName;
  late String _objExpr;
  late int _part25;
  late String _part3;

  @override
  int get lineNumber => _bodyInfo.lineNumber;

  @override
  String get marker => String.fromCharCode(0x4C);

  @override
  NodeType get nodeType => NodeType.forInStatement;

  @override
  double get jsxbinVersion => 1.0;

  @override
  void decode() {
    _bodyInfo = decodeBody();
    _loopVarName = decodeNode()?.prettyPrint() ?? "";
    _objExpr = decodeNode()?.prettyPrint() ?? "";
    _part25 = decodeLength();
    _part3 = decodeId();
  }

  @override
  String prettyPrint() {
    final label = _bodyInfo.createLabelStmt();
    final body = _bodyInfo.createBody();
    final buffer = StringBuffer();
    buffer.writeln(
      "$label"
      "for (var $_loopVarName in $_objExpr) {",
    );
    buffer.writeln(body);
    buffer.write("}");
    return buffer.toString();
  }
}
