/// Represents a node that is a statement and has a line number.
abstract class IStatement {
  /// The line number in the source where this statement appears.
  int get lineNumber;
}
