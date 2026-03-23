import 'inode.dart';

/// Metadata about a constant declaration in JSXBIN.
class ConstDeclarationInfo {
  late String name;
  late int length;
  INode? expr;
  String? literal;
  late bool boolVal1;
  late bool boolVal2;

  /// Returns the assigned variable value as a string.
  String getValue() {
    return expr?.prettyPrint() ?? literal ?? "";
  }
}
