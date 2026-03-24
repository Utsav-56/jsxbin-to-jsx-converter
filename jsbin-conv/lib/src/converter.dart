import 'dart:io';
import 'package:jsbin_conv/jsbin_conv.dart';
import 'package:jsbin_conv/src/js_beautifier.dart';
import 'package:path/path.dart' as p;

class Converter {
  final bool printStructure;

  Converter({this.printStructure = false});

  Future<void> decode(String jsxbinFilepath, String jsxFilepath) async {
    try {
      print("Decoding $jsxbinFilepath");

      final jsxbinFile = File(jsxbinFilepath);
      if (!await jsxbinFile.exists()) {
        stderr.writeln("File $jsxbinFilepath not found.");
        return;
      }

      final jsxbin = await jsxbinFile.readAsString();
      final jsxRaw = AbstractNode.decodeJsxbin(jsxbin, printStructure);

      final beautifier = JSBeautifier();
      final jsxBeautified = await beautifier.beautify(jsxRaw);

      final outputFile = File(jsxFilepath);
      // Ensure directory exists
      final outputDir = outputFile.parent;
      if (!outputDir.existsSync()) {
        outputDir.createSync(recursive: true);
      }

      await outputFile.writeAsString(jsxBeautified);

      print("Jsxbin successfully decoded to $jsxFilepath");
    } catch (e, stack) {
      stderr.writeln(
        "Decoding failed. If this problem persists, please raise an issue on github.\nError message: $e.\nStacktrace: $stack.",
      );
    }
  }

  static String getNonCollidingPath(String dir, String filename) {
    var path = p.join(dir, filename);
    if (!File(path).existsSync()) return path;

    final nameOnly = p.basenameWithoutExtension(filename);
    final ext = p.extension(filename);
    var index = 1;
    while (true) {
      path = p.join(dir, '$nameOnly-($index)$ext');
      if (!File(path).existsSync()) return path;
      index++;
    }
  }
}
