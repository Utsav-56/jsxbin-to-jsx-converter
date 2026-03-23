import 'abstract_node.dart';
import 'inode.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'node_type.dart';

/// Represents a 'for' loop in JSX.
class ForStatement extends AbstractNode implements IStatement {
  late LineInfo _bodyInfo;
  late INode? _loopVarInfo;
  late String _initExpr;
  late INode? _upperBoundInfo;
  late String _stepSize;
  late int _part6;
  late String _compOp;

  @override
  int get lineNumber => _bodyInfo.lineNumber;

  @override
  String get marker => String.fromCharCode(0x61);

  @override
  NodeType get nodeType => NodeType.forStatement;

  @override
  void decode() {
    _bodyInfo = decodeBody();
    _loopVarInfo = decodeNode();
    _initExpr = decodeNumber();
    _upperBoundInfo = decodeNode();
    _stepSize = decodeNumber();
    _part6 = decodeLength();
    _compOp = decodeId();
  }

  @override
  String prettyPrint() {
    final label = _bodyInfo.createLabelStmt();
    final body = _bodyInfo.createBody();
    final loopVarName = _loopVarInfo?.prettyPrint() ?? "";
    final upperBound = _upperBoundInfo?.prettyPrint() ?? "";

    final buffer = StringBuffer();
    buffer.writeln(
      "$label"
      "for (var $loopVarName = $_initExpr; $loopVarName $_compOp $upperBound; $loopVarName += $_stepSize) {",
    );
    buffer.writeln(body);
    buffer.write("}");
    return buffer.toString();
  }
}
