import 'abstract_node.dart';
import 'argument_list.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents a function call or a 'new' constructor call in JSX.
class FunctionCallExpr extends AbstractNode {
  late INode? _functionName;
  late INode? _argsInfo;
  late bool _isConstructorCall;

  @override
  String get marker => String.fromCharCode(0x45);

  @override
  NodeType get nodeType => NodeType.functionCallExpr;

  @override
  void decode() {
    _functionName = decodeNode();
    _argsInfo = decodeNode();
    _isConstructorCall = decodeBool();
  }

  @override
  String prettyPrint() {
    final args = _argsInfo as ArgumentList?;
    final ctor = _isConstructorCall ? "new " : "";
    final name = _functionName?.prettyPrint() ?? "";
    final argsStr = args == null
        ? ""
        : args.arguments.map((a) => a.prettyPrint()).join(", ");

    return "$ctor$name($argsStr)";
  }
}
