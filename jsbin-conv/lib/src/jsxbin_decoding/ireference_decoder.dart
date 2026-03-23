import 'inode.dart';

/// Define a contract for decoding various types of references in JSXBIN.
abstract class IReferenceDecoder {
  /// The JSXBIN version this decoder supports.
  double get jsxbinVersion;

  /// Decodes a reference and returns its name and its type (boolean).
  (String, bool) decode(INode node);
}
