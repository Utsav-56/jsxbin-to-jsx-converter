import 'nesting.dart';
import 'symbol_table.dart';

/// Tracks the current position and state during JSXBIN decoding.
class ScanState {
  int _index = 0;
  final String _input;
  late final Nesting nesting;
  final SymbolTable _table = SymbolTable();

  /// Creates a new [ScanState] with the provided input string.
  ScanState(this._input) {
    nesting = Nesting(this);
  }

  /// Private constructor used by [clone].
  ScanState._internal(this._input, this._index) {
    nesting = Nesting(this);
  }

  /// Records a symbol mapping in the symbol table.
  void addSymbol(String key, String value) {
    _table.add(key, value);
  }

  /// Retrieves a symbol by its key/ID.
  String? getSymbol(String key) {
    return _table.getSymbol(key);
  }

  /// Advances the scanning index by one.
  void inc() {
    _index++;
  }

  /// Returns the character at the current index.
  String getCur() {
    if (_index >= _input.length) return '';
    return _input[_index];
  }

  /// Checks if the character at the current index matches the given ASCII hex value.
  bool isHex(int num) {
    final cur = getCur();
    if (cur.isEmpty) return false;
    return cur.codeUnitAt(0) == num;
  }

  /// Creates a clone of the current [ScanState] for backtracking or looking ahead.
  ScanState clone() {
    return ScanState._internal(_input, _index);
  }

  /// Calculates or retrieves the current nesting levels.
  int getNestingLevels() {
    if (nesting.levels == 0) {
      nesting.parseLevels();
    }
    return nesting.levels;
  }

  /// Decreases the recorded nesting level.
  void decrementNestingLevels() {
    if (nesting.levels == 0) {
      return;
    }
    nesting.decrementLevel();
  }

  /// Debugging utility showing current position and context in the input string.
  String get progress {
    const marker = '****';
    final buffer = StringBuffer();
    buffer.write(_input.substring(0, _index));
    buffer.write(marker);
    if (_index < _input.length) {
      buffer.write(_input[_index]);
      buffer.write(marker);
      buffer.write(_input.substring(_index + 1));
    } else {
      buffer.write(marker);
    }
    return buffer.toString();
  }

  /// Resolves or registers an identifier based on listed component parts.
  String getAndOrAddId(List<String> id) {
    if (id.length == 3) {
      final name = id[1];
      addSymbol(id[2], name);
      return name;
    } else if (id.isNotEmpty) {
      return getSymbol(id[0]) ?? '';
    }
    return '';
  }
}
