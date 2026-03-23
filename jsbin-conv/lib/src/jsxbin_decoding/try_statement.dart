import 'abstract_node.dart';
import 'inode.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'node_type.dart';

/// Represents a 'try-catch-finally' block in JSX.
class TryStatement extends AbstractNode implements IStatement {
  late LineInfo _tryBlock;
  late String _expr;

  @override
  int get lineNumber => _tryBlock.lineNumber;

  @override
  String get marker => String.fromCharCode(0x67);

  @override
  NodeType get nodeType => NodeType.tryStatement;

  @override
  void decode() {
    _tryBlock = decodeLineInfo();
    final length = decodeLength();
    final finallyBlock = decodeNode();
    final buffer = StringBuffer();
    final label = _tryBlock.createLabelStmt();
    final body = _tryBlock.createBody();

    buffer.writeln(
      "$label"
      "try {",
    );
    buffer.writeln(body);

    int i = length;
    while (i > 0) {
      final arg = decodeId();
      final exceptionFilter = decodeNode();
      final catchBlock = decodeNode();
      buffer.write("} catch ($arg");
      if (exceptionFilter != null) {
        buffer.write(" if ${exceptionFilter.prettyPrint()}");
      }
      buffer.writeln(") {");
      buffer.writeln(catchBlock?.prettyPrint() ?? "");
      i--;
    }

    if (finallyBlock != null) {
      buffer.writeln("} finally {");
      buffer.writeln(finallyBlock.prettyPrint());
    }
    buffer.write("}");
    _expr = buffer.toString();
  }

  @override
  String prettyPrint() {
    return _expr;
  }
}
