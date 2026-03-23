/// Holds a function's parameters and various JSXBIN header segments.
class FunctionSignature {
  /// The collection of function parameters (name, length).
  final List<(String, int)> parameter = [];

  /// The name of the function.
  String name = '';

  /// Various headers containing metadata for the function.
  int header1 = 0;

  /// Various headers containing metadata for the function.
  int type = 0;

  /// Various headers containing metadata for the function.
  int header3 = 0;

  /// Various headers containing metadata for the function.
  int header5 = 0;
}
