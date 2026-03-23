import 'inode.dart';
import 'ireference_decoder.dart';

/// Decodes references for JSXBIN version 2.0.
class ReferenceDecoderVersion2 implements IReferenceDecoder {
  @override
  double get jsxbinVersion => 2.0;

  @override
  (String, bool) decode(INode node) {
    final id = node.decodeId();
    final flag = node.decodeBool();
    return (id, flag);
  }
}
