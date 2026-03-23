import 'inode.dart';
import 'ireference_decoder.dart';

/// Decodes references for JSXBIN version 1.0.
class ReferenceDecoderVersion1 implements IReferenceDecoder {
  @override
  double get jsxbinVersion => 1.0;

  @override
  (String, bool) decode(INode node) {
    final id = node.decodeId();
    return (id, false);
  }
}
