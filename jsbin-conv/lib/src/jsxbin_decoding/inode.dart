import 'node_type.dart';

/// Define the base contract for all decoder nodes in a JSXBIN tree.
abstract class INode {
  /// The specific type of the AST node.
  NodeType get nodeType;

  /// The marker character string representing the node in JSXBIN.
  String get marker;

  /// Decodes data from the input stream.
  void decode();

  /// Converts the node and its children into a human-readable JSX string.
  String prettyPrint();

  /// Whether or not to log the structure progress to standard output.
  abstract bool printStructure;

  /// The current indentation level for formatted results.
  abstract int indentLevel;

  /// The version for which this node is valid.
  double get jsxbinVersion;

  /// Decodes a string identifier from the input.
  String decodeId();

  /// Decodes a boolean value from the input.
  bool decodeBool();
}
