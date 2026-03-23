/// Important markers and codes used for decoding JSXBIN content.
class Constants {
  /// Marker indicating a node with no variant.
  static const int markerHasNoVariant = 0x6E; // 'n'

  /// Marker indicating an ID reference.
  static const int markerIdReference = 0x7A; // 'z'

  /// Marker for a negative number.
  static const int markerNegativeNumber = 0x79; // 'y'

  /// Marker for an 8-byte number.
  static const int markerNumber8Bytes = 0x38; // '8'

  /// Marker for a 4-byte number.
  static const int markerNumber4Bytes = 0x34; // '4'

  /// Marker for a 2-byte number.
  static const int markerNumber2Bytes = 0x32; // '2'

  /// Marker for a boolean `true`.
  static const int boolTrue = 0x74; // 't'

  /// Marker for a boolean `false`.
  static const int boolFalse = 0x66; // 'f'
}
