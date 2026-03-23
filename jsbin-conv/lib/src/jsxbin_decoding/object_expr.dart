import 'abstract_node.dart';
import 'inode.dart';
import 'node_type.dart';

/// Represents an object literal in JSX (e.g., { a: 1, b: "hi" }).
class ObjectExpr extends AbstractNode {
  late String _objId;
  late List<(String, INode)> _props;

  @override
  String get marker => String.fromCharCode(0x57);

  @override
  NodeType get nodeType => NodeType.objectExpr;

  @override
  void decode() {
    _objId = decodeId();
    _props = [];
    forEachChild(() {
      final id = decodeId();
      final val = decodeNode();
      if (val != null) {
        _props.add((id, val));
      }
    });
  }

  @override
  String prettyPrint() {
    if (_props.isEmpty) {
      return "{}";
    }

    final propValuesCombined = _props.map((t) {
      String key = t.$1;
      if (!isValidIdentifier(key)) {
        key = '"$key"';
      }
      return "$key: ${t.$2.prettyPrint()}";
    });

    final buffer = StringBuffer();
    buffer.writeln("{");
    buffer.writeln(propValuesCombined.join(",\n"));
    buffer.write("}");
    return buffer.toString();
  }
}
