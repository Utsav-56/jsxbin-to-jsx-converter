import 'dart:io';
import 'package:jsbin_conv/src/converter.dart';
import 'package:jsbin_conv/src/directory_list/dir_ls.dart';
import 'package:jsbin_conv/src/js_beautifier.dart';
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
    if (_parseCommandLine(args, parsedArgs)) {
      return; // Version printed, exit
    }
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
  print("Usage: jsxbin-conv [FLAGS] JSXBIN [JSX]");
  print("Example: jsxbin-conv --verbose encoded.jsxbin decoded.jsx");
  print("Flags:");
  print("-v, --version  Print version information");
  print("--verbose      Print tree structure to stdout");

  print(
    "\nThe output path is optional. If not provided, it will be saved in 'jsxbin-converted' directory.",
  );
}

void _printVersion() {
  print("==========Made with love by Utsav-56 ==========");
  print("visit https://github.com/utsav-56/jsxbin-to-jsx-converter");
  print("");
  print("Decoder version: 1.2.0");
  print("");
  print("Makeup-man (Powered by clang-formatter)");
  print("version: ${JSBeautifier.getVersion()}");
  print("");
  print("=========================================");
}

/// Parses the command line arguments provided.
/// Returns true if it should exit immediately (e.g. after printing version).
bool _parseCommandLine(List<String> args, DecodeArgs decoderArgs) {
  int flagOffset = 0;

  for (final arg in args) {
    if (arg == "-v" || arg == "--version") {
      _printVersion();
      return true;
    } else if (arg == "--verbose") {
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
  return false;
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
