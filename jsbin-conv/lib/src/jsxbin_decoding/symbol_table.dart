/// Stores and retrieves symbol names mapped to their JSXBIN IDs.
class SymbolTable {
  final Map<String, String> _table = {};

  /// Adds a new symbol name for the given key/ID.
  void add(String key, String value) {
    _table[key] = value;
  }

  /// Retrieves the symbol name associated with the given key/ID.
  String? getSymbol(String key) {
    return _table[key];
  }
}
