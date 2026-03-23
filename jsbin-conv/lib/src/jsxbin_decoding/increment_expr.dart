import 'abstract_node.dart';
import 'node_type.dart';

/// Represents increment (++) or decrement (--) operations in JSX.
class IncrementExpr extends AbstractNode {
  late String _id;
  late int _p2;
  late String _addOrSubtract;
  late bool _isPostFix;

  @override
  String get marker => String.fromCharCode(0x54);

  @override
  NodeType get nodeType => NodeType.incrementExpr;

  @override
  void decode() {
    _id = decodeId();
    _p2 = decodeLength();
    _addOrSubtract = decodeNumber();
    _isPostFix = decodeBool();
  }

  @override
  String prettyPrint() {
    String op = "";
    if (_addOrSubtract == "1") {
      op = "++";
    } else {
      op = "--";
    }

    if (_isPostFix) {
      return "$_id$op";
    } else {
      return "$op$_id";
    }
  }
}
