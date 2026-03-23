import 'scan_state.dart';

/// Manages nesting levels during the JSXBIN parsing process.
class Nesting {
  final ScanState _scanState;

  /// The current nesting count.
  int levels = 0;

  /// Creates a new [Nesting] manager for the given [ScanState].
  Nesting(this._scanState);

  /// Decreases the nesting level.
  void decrementLevel() {
    levels--;
  }

  /// Parses the nesting levels from the current [ScanState] position.
  void parseLevels() {
    levels = _parseLevelsCore();
  }

  /// Recursively fetches the nesting level from the input stream.
  int _parseLevelsCore() {
    // 0x41 is 'A'
    if (_scanState.isHex(0x41)) {
      _scanState.inc();
      return 1;
    }
    // 0x30 is '0'
    if (_scanState.isHex(0x30)) {
      _scanState.inc();
      final lvlsCrypted = _scanState.getCur().codeUnitAt(0);
      final lvls = lvlsCrypted - 0x3F;
      _scanState.inc();

      if (lvls > 0x1B) {
        return lvls + _parseLevelsCore();
      } else {
        return lvls;
      }
    }
    return 0;
  }
}
