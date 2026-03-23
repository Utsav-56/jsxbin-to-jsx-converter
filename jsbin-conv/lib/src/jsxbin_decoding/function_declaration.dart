import 'abstract_node.dart';
import 'function_signature.dart';
import 'istatement.dart';
import 'line_info.dart';
import 'node_type.dart';

/// Represents a function declaration in JSX.
class FunctionDeclaration extends AbstractNode implements IStatement {
  late LineInfo _bodyInfo;
  late FunctionSignature _signature;
  late int _type;

  @override
  int get lineNumber => _bodyInfo.lineNumber;

  @override
  String get marker => String.fromCharCode(0x4D);

  @override
  NodeType get nodeType => NodeType.functionDeclaration;

  @override
  void decode() {
    _bodyInfo = decodeLineInfo();
    _signature = decodeSignature();
    _type = decodeLength();
  }

  @override
  String prettyPrint() {
    final bool isHeader = _signature.header5 == 1;
    final body = _bodyInfo.createBody();

    // Header wrappers are omitted as per C# logic.
    if (isHeader) {
      return body;
    }

    // Parameters with lengths in this magic range are genuine function parameters.
    final paramList = _signature.parameter
        .where((p) => p.$2 > 536870000 && p.$2 < 540000000)
        .toList();
    // Sort parameters by their assigned length/ID if needed, matching C# OrderBy.
    paramList.sort((a, b) => a.$2.compareTo(b.$2));

    final paramNames = paramList.map((p) => p.$1).join(", ");
    final buffer = StringBuffer();
    buffer.writeln("function ${_signature.name}($paramNames) {");
    buffer.writeln(body);
    buffer.write("}");
    return buffer.toString();
  }
}
