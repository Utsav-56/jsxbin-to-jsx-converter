import 'dart:io';
import 'package:jsbin_conv/src/converter.dart';
import 'package:jsbin_conv/src/directory_list/dir_ls.dart';
import 'package:path/path.dart' as p;

/// Entry point for the JSXBIN to JSX converter CLI application.
Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    final interactive = InteractiveMode();
    await interactive.start();
    return;
  }

  final parsedArgs = DecodeArgs();
  try {
    _parseCommandLine(args, parsedArgs);
  } catch (e) {
    stderr.writeln(e);
    printHelp();
    return;
  }

  final converter = Converter(printStructure: parsedArgs.printStructure);
  await converter.decode(parsedArgs.jsxbinFilepath, parsedArgs.jsxFilepath);
}

/// Prints usage help in the terminal.
void printHelp() {
  print("Usage: [-v] jsxbin_to_jsx JSXBIN [JSX]");
  print("Example: -v jsxbin_to_jsx encoded.jsxbin decoded.jsx");
  print("Flags:");
  print("-v print tree structure to stdout");

  print(
    "The output path is optional. If not provided, it will be saved in 'jsxbin-converted' directory.",
  );
}

/// Parses the command line arguments provided into a [DecodeArgs] configuration object.
void _parseCommandLine(List<String> args, DecodeArgs decoderArgs) {
  int flagOffset = 0;

  if (args.isNotEmpty) {
    if (args[0] == "-v" || args[0] == "--verbose") {
      flagOffset++;
      decoderArgs.printStructure = true;
    }
  }

  if (args.length <= flagOffset) {
    throw Exception("Expected input file path.");
  }

  decoderArgs.jsxbinFilepath = args[flagOffset];

  if (args.length > flagOffset + 1) {
    decoderArgs.jsxFilepath = args[flagOffset + 1];
  } else {
    // Output path is optional
    final inputFilename = p.basenameWithoutExtension(decoderArgs.jsxbinFilepath);
    final outputDir = p.join(Directory.current.path, 'jsxbin-converted');
    decoderArgs.jsxFilepath = Converter.getNonCollidingPath(
      outputDir,
      '$inputFilename.jsx',
    );
  }

  decoderArgs.validate();
}

/// Configuration arguments for the [decode] logic.
class DecodeArgs {
  late String jsxFilepath;
  late String jsxbinFilepath;
  bool printStructure = false;

  bool validate() {
    jsxbinFilepath = jsxbinFilepath.trim();
    jsxFilepath = jsxFilepath.trim();

    if (jsxbinFilepath.isEmpty) {
      throw Exception("The given input filename is empty");
    }

    if (jsxbinFilepath == jsxFilepath) {
      throw Exception("The given input and output filename is the same");
    }

    /// Check if the file is a jsxbin file
    if (!jsxbinFilepath.endsWith(".jsxbin")) {
      jsxbinFilepath = "$jsxbinFilepath.jsxbin";
    }

    /// Check if the file is a jsx file
    if (!jsxFilepath.endsWith(".jsx")) {
      jsxFilepath = "$jsxFilepath.jsx";
    }

    /// Check if input file exists
    final jsxbinFile = File(jsxbinFilepath);
    if (!jsxbinFile.existsSync()) {
      throw Exception("The given input filename does not exist: $jsxbinFilepath");
    }

    return true;
  }
}
