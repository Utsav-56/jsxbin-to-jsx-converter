import 'dart:convert';
import 'package:jsbin_conv/src/jsxbin_decoding/decoders_registry.dart';
import 'package:jsbin_conv/src/jsxbin_decoding/const_declaration_info.dart';
import 'package:jsbin_conv/src/jsxbin_decoding/constants.dart';
import 'package:jsbin_conv/src/jsxbin_decoding/function_signature.dart';
import 'package:jsbin_conv/src/jsxbin_decoding/inode.dart';
import 'package:jsbin_conv/src/jsxbin_decoding/ireference_decoder.dart';
import 'package:jsbin_conv/src/jsxbin_decoding/line_info.dart';
import 'package:jsbin_conv/src/jsxbin_decoding/logical_exp_info.dart';
import 'package:jsbin_conv/src/jsxbin_decoding/node_type.dart';
import 'package:jsbin_conv/src/jsxbin_decoding/reference_decoder_version1.dart';
import 'package:jsbin_conv/src/jsxbin_decoding/reference_decoder_version2.dart';
import 'package:jsbin_conv/src/jsxbin_decoding/root_node.dart';
import 'package:jsbin_conv/src/jsxbin_decoding/scan_state.dart';
import 'dart:typed_data';

/// Define a function type for creating INode instances.
typedef NodeFactory = INode Function();

/// Base class for all JSXBIN syntax tree nodes. Provides utility functions for decoding common structures.
abstract class AbstractNode implements INode {
  static const double allVersions = 0.0;
  static const String _alphabetLower = 'ghijklmn';
  static const String _alphabetUpper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdef';
  static ScanState? _scanState;
  static IReferenceDecoder? _referenceDecoder;
  static final RegExp _validIdentifier = RegExp(r"^[a-zA-Z_$][0-9a-zA-Z_$]*$");

  /// A registry mapping markers to factories that create Node instances.
  static final Map<String, NodeFactory> decoders = {};

  @override
  bool printStructure = false;

  @override
  int indentLevel = 0;

  @override
  double get jsxbinVersion => allVersions;

  /// Grants access to the internal [ScanState].
  ScanState get scanState => _scanState!;

  /// Checks if a string is a valid JavaScript identifier.
  bool isValidIdentifier(String identifier) {
    return _validIdentifier.hasMatch(identifier);
  }

  /// Sets up the internal registry mapping a marker to a node decoding instance.
  static void registerDecoder(
    String marker,
    double version,
    double requestedVersion,
    NodeFactory factory,
  ) {
    if (version == allVersions || version == requestedVersion) {
      decoders[marker] = factory;
    }
  }

  /// Initiates the overall document decoding.
  /// Uses a basic text cleanup regex to identify JSXBIN version and initialize the [ScanState].
  static String decodeJsxbin(String jsxbin, bool printStructure) {
    final normalized = jsxbin
        .replaceAll("\n", "")
        .replaceAll("\r", "")
        .replaceAll("\\", "");
    final versionMatch = RegExp(r"^@JSXBIN@ES@([\d.]+)@").firstMatch(normalized);
    double version = allVersions;

    if (versionMatch != null) {
      version = double.parse(versionMatch.group(1)!);
    }

    final noheader = normalized.replaceFirst(RegExp(r"^@JSXBIN@ES@[\d.]+@"), "");
    _scanState = ScanState(noheader);

    _initializeDecoders(_scanState!, version);

    final root = RootNode();
    root.printStructure = printStructure;
    root.decode();

    final jsx = root.prettyPrint();
    // Assuming RootNode's prettyPrint returns a single string with the whole document.
    return jsx;
  }

  /// Evaluates and decodes numeric expressions out of the input stream.
  String decodeNumber() {
    final cur = getCurrentAndAdvanceCore(_scanState!.clone());
    String number = "";

    if (isHexState(cur, Constants.markerNumber8Bytes)) {
      getCurrentAndAdvanceCore(_scanState!);
      number = decodeNumberCore(8, false);
    } else {
      number = decodeLiteral(true, false) ?? "0";
    }

    return number;
  }

  @override
  bool decodeBool() {
    final str = getCurrentAndAdvanceCore(_scanState!);
    if (str.codeUnitAt(0) == Constants.boolFalse) {
      return false;
    } else if (str.codeUnitAt(0) == Constants.boolTrue) {
      return true;
    } else {
      throw Exception("unexpected bool value $str");
    }
  }

  /// Manually populates the decoders registry with factory callbacks.
  static void _initializeDecoders(ScanState scanState, double version) {
    decoders.clear();
    registerAllDecoders(version);

    if (version == 1.0) {
      _referenceDecoder = ReferenceDecoderVersion1();
    } else {
      _referenceDecoder = ReferenceDecoderVersion2();
    }
  }

  /// Reads a single node recursively.
  INode? decodeNode() {
    final markerStr = getCurrentAndAdvance(_scanState!);
    if (markerStr.isEmpty) return null;

    if (isHexState(markerStr, Constants.markerHasNoVariant)) {
      return null;
    } else if (decoders.containsKey(markerStr)) {
      final factory = decoders[markerStr]!;
      final INode node = factory();

      bool ignoreHeaderFunction = nodeType == NodeType.root;

      if (printStructure && !ignoreHeaderFunction) {
        final padding = List.filled(4 * indentLevel, ' ').join('');
        print("$padding${node.nodeType.name}");
        node.indentLevel = indentLevel + 1;
      }

      node.printStructure = printStructure;
      node.decode();
      return node;
    } else {
      throw Exception("No decoder found for marker $markerStr");
    }
  }

  /// Fetches the character from scanner while optionally updating inner levels.
  String getCurrentAndAdvance(ScanState scanState) {
    return getCurrentAndAdvanceCore(scanState);
  }

  /// Low level character advancement logic inside the scanner.
  String getCurrentAndAdvanceCore(ScanState scanState) {
    final cur = scanState.getCur();
    scanState.inc();
    return cur;
  }

  /// Returns whether parser is currently within a nested context.
  bool isNested() {
    return scanState.getNestingLevels() > 0;
  }

  /// Exits a nested section.
  void decrementNesting() {
    scanState.decrementNestingLevels();
  }

  /// Decodes a standard JS logical expression.
  LogicalExpInfo decodeLogicalExp() {
    final info = LogicalExpInfo();
    info.opName = decodeId();
    info.leftExpr = decodeNode();
    info.rightExpr = decodeNode();
    info.leftLiteral = decodeVariant();
    info.rightLiteral = decodeVariant();
    return info;
  }

  /// Parses variants of data, like booleans, numbers, or strings.
  String? decodeVariant() {
    final chr = getCurrentAndAdvance(scanState.clone());
    if (chr.isEmpty) return null;
    if (isHexState(chr, Constants.markerHasNoVariant)) {
      getCurrentAndAdvance(scanState);
      return null;
    } else {
      return decodeVariantCore();
    }
  }

  /// Compares string value to a hex number representation byte-by-byte.
  bool isHexState(String src, int num) {
    if (src.isEmpty) return false;
    return src.codeUnitAt(0) == num;
  }

  @override
  String decodeId() {
    final marker = getCurrentAndAdvanceCore(scanState.clone());
    if (!isHexState(marker, Constants.markerIdReference)) {
      final id = decodeLength().toString();
      return scanState.getSymbol(id) ?? '';
    } else {
      getCurrentAndAdvanceCore(scanState); // type
      final name = decodeString();
      final id = decodeLength().toString();
      scanState.addSymbol(id, name);
      return name;
    }
  }

  /// Internal handler mapping generic values into known AST representation parts.
  String decodeVariantCore() {
    final strChar = getCurrentAndAdvanceCore(scanState);
    if (strChar.isEmpty) return "null";
    final int typ = strChar.codeUnitAt(0) - 0x61; // 0x61 is 'a'

    String val = "";
    switch (typ) {
      case 2:
        val = decodeBool().toString().toLowerCase();
        break;
      case 3:
        val = decodeNumber();
        break;
      case 4:
        val = decodeString();
        // Mimic C# replacement behavior
        val = val.replaceAll("\\", "\\\\");
        val = val.replaceAll("\"", "\\\"");
        val = '"$val"';
        val = val.replaceAll("\n", "\\n").replaceAll("\t", "\\t").replaceAll("\r", "\\r");
        break;
      case 0:
      case 1:
        val = "null";
        break;
      default:
        throw Exception("Unexpected Variant type: $typ");
    }
    return val;
  }

  /// Reads a stream of bytes composing a string length out of the scanner.
  String decodeString() {
    final strLen = decodeLiteral(true, false);
    final length = strLen == null ? 0 : int.parse(strLen);
    if (length == 0) {
      return "";
    }

    final buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      buffer.write(decodeLiteral(false, true));
    }
    return buffer.toString();
  }

  /// Extracts numeric values out of the sequence according to defined byte intervals.
  String decodeNumberCore(int numberLength, bool twosComplement) {
    List<int> bytes = [];
    for (int i = 0; i < numberLength; i++) {
      bytes.add(decodeByte());
    }

    String decryptedNumber = "";
    if (numberLength == 4) {
      // Little-endian Uint32
      final byteData = ByteData(4);
      for (int i = 0; i < 4; i++) {
        byteData.setUint8(i, bytes[i]);
      }
      decryptedNumber = byteData.getUint32(0, Endian.little).toString();
    } else if (numberLength == 2) {
      final byteData = ByteData(2);
      for (int i = 0; i < 2; i++) {
        byteData.setUint8(i, bytes[i]);
      }
      decryptedNumber = byteData.getUint16(0, Endian.little).toString();
    } else if (numberLength == 8) {
      final byteData = ByteData(8);
      for (int i = 0; i < 8; i++) {
        byteData.setUint8(i, bytes[i]);
      }
      decryptedNumber = byteData.getFloat64(0, Endian.little).toString();
    } else {
      throw Exception("Unknown number length found: $numberLength");
    }

    if (twosComplement) {
      return "-$decryptedNumber";
    }
    return decryptedNumber;
  }

  /// Represents literal text values back to their target unicode sequences.
  String convertToUnicodeString(String codePoint) {
    int code = int.parse(codePoint);
    return String.fromCharCode(code);
  }

  /// Helper converting literal encoding structures back into readable components.
  String? decodeLiteral(bool isNumber, bool isUnicodeString) {
    if (isNested()) {
      decrementNesting();
      return null;
    }

    bool twosComplement = false;
    if (scanState.isHex(Constants.markerNegativeNumber)) {
      twosComplement = true;
      getCurrentAndAdvanceCore(scanState);
    }

    if (scanState.isHex(Constants.markerNumber4Bytes)) {
      getCurrentAndAdvanceCore(scanState);
      String nr = decodeNumberCore(4, twosComplement);
      if (isUnicodeString) {
        nr = convertToUnicodeString(nr);
      }
      return nr;
    } else if (scanState.isHex(Constants.markerNumber2Bytes)) {
      getCurrentAndAdvanceCore(scanState);
      String nr = decodeNumberCore(2, twosComplement);
      if (isUnicodeString) {
        nr = convertToUnicodeString(nr);
      }
      return nr;
    } else {
      int bz = decodeByte();
      String str = "";
      if (twosComplement) {
        int nr = -1 * bz;
        str = nr.toString();
      } else {
        if (isNumber) {
          str = bz.toString();
        } else {
          try {
            // ISO-8859-1 conversion
            str = latin1.decode([bz]);
          } catch (_) {
            // fallback if needed
            str = String.fromCharCode(bz);
          }
        }
      }
      return str;
    }
  }

  /// Extracts a packed byte block inside JSXBIN strings.
  int decodeByte() {
    if (isNested()) {
      decrementNesting();
      return 0;
    }

    final firstChar = getCurrentAndAdvanceCore(scanState);
    if (firstChar.isEmpty) return 0;
    final first = firstChar.codeUnitAt(0);

    int decrypt = 0;
    int minus41 = first - 0x41; // 'A'
    if (minus41 <= 0x19) {
      decrypt = minus41;
    } else {
      int n = _alphabetLower.indexOf(firstChar);
      final secondChar = getCurrentAndAdvanceCore(scanState);
      int rest = _alphabetUpper.indexOf(secondChar);
      decrypt = (n * 32 + rest);
    }
    return decrypt;
  }

  /// Provides properties matching a JS constant declaration field block.
  ConstDeclarationInfo decodeConstDeclaration() {
    final info = ConstDeclarationInfo();
    info.name = decodeId();
    info.length = decodeLength();
    info.expr = decodeNode();
    info.literal = decodeVariant();
    info.boolVal1 = decodeBool();
    info.boolVal2 = decodeBool();
    return info;
  }

  /// Calculates component lengths inside the compiled binary.
  int decodeLength() {
    final strLen = decodeLiteral(true, false);
    return strLen == null ? 0 : int.parse(strLen).abs();
  }

  /// Captures associated line formatting metadata.
  LineInfo decodeLineInfo() {
    final info = LineInfo();
    info.lineNumber = decodeLength();
    info.child = decodeNode();
    int length = decodeLength();

    for (int i = 0; i < length; i++) {
      info.labels.add(decodeId());
    }
    return info;
  }

  /// Attempts to use registered ReferenceDecoders to resolve current ID.
  (String, bool) decodeReference() {
    return _referenceDecoder!.decode(this);
  }

  /// Interprets block body sequences containing line tracking info.
  LineInfo decodeBody() {
    return decodeLineInfo();
  }

  /// Loops decoding dynamically loaded recursive children of abstract nodes.
  List<INode> decodeChildren() {
    int length = decodeLength();
    if (length == 0) return [];

    List<INode> res = [];
    for (int i = 0; i < length; i++) {
      final child = decodeNode();
      if (child != null) {
        res.add(child);
      }
    }
    return res;
  }

  /// Triggers a function repeatedly for child tracking records matching decoded values.
  void forEachChild(void Function() action) {
    int length = decodeLength();
    if (length == 0) return;

    for (int i = 0; i < length; i++) {
      action();
    }
  }

  /// Decodes JS Function declarations components.
  FunctionSignature decodeSignature() {
    final sig = FunctionSignature();
    int length = decodeLength();
    if (length > 0) {
      for (int i = 0; i < length; i++) {
        final paramName = decodeId();
        final paramLength = decodeLength();
        sig.parameter.add((paramName, paramLength));
      }
    }

    sig.header1 = decodeLength();
    sig.type = decodeLength();
    sig.header3 = decodeLength();
    sig.name = decodeId();
    sig.header5 = decodeLiteralNumber2();
    return sig;
  }

  /// Extracts literal metadata properties encoded differently.
  int decodeLiteralNumber2() {
    String? number = decodeLiteral(true, false);
    return number == null ? 0 : int.parse(number);
  }

  /// Gathers combination component blocks handling AST variables.
  ((String, bool), INode?) decodeRefAndNode() {
    final refa = decodeReference();
    final node = decodeNode();
    return (refa, node);
  }

  /// Identifies named ID parameters connected to Node fields.
  (String, INode?) decodeIdAndNode() {
    String id = decodeId();
    final node = decodeNode();
    return (id, node);
  }

  @override
  String toString() {
    throw Exception("Call prettyPrint() instead.");
  }
}
