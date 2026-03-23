import 'dart:io';
import 'package:jsbin_conv/jsbin_conv.dart';
import 'package:jsbin_conv/src/js_beautifier.dart';

/// Entry point for the JSXBIN to JSX converter CLI application.
Future<void> main(List<String> args) async {
  if (args.length < 2) {
    printHelp();
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

  await _decode(parsedArgs);
}

/// Prints usage help in the terminal.
void printHelp() {
  print("Usage: [-v] jsxbin_to_jsx JSXBIN JSX");
  print("Example: -v jsxbin_to_jsx encoded.jsxbin decoded.jsx");
  print("Flags:");
  print("-v print tree structure to stdout");
}

/// Orchestrates the Overall decoding process.
Future<void> _decode(DecodeArgs decoderArgs) async {
  try {
    print("Decoding ${decoderArgs.jsxbinFilepath}");

    final jsxbinFile = File(decoderArgs.jsxbinFilepath);
    if (!await jsxbinFile.exists()) {
      stderr.writeln("File ${decoderArgs.jsxbinFilepath} not found.");
      return;
    }

    final jsxbin = await jsxbinFile.readAsString();
    final jsxRaw = AbstractNode.decodeJsxbin(jsxbin, decoderArgs.printStructure);

    final beautifier = JSBeautifier();
    final jsxBeautified = await beautifier.beautify(jsxRaw);

    final outputFile = File(decoderArgs.jsxFilepath);
    await outputFile.writeAsString(jsxBeautified);

    print("Jsxbin successfully decoded to ${decoderArgs.jsxFilepath}");
  } catch (e, stack) {
    stderr.writeln(
      "Decoding failed. If this problem persists, please raise an issue on github.\nError message: $e.\nStacktrace: $stack.",
    );
  }
}

/// Parses the command line arguments provided into a [DecodeArgs] configuration object.
void _parseCommandLine(List<String> args, DecodeArgs decoderArgs) {
  int flagOffset = 0;

  if (args.length > 2) {
    if (args[0] == "-v") {
      flagOffset++;
      decoderArgs.printStructure = true;
    } else {
      throw Exception("Flag ${args[0]} is not valid.");
    }
  }

  if (args.length < flagOffset + 2) {
    throw Exception("Expected input and output file paths.");
  }

  decoderArgs.jsxbinFilepath = args[flagOffset];
  decoderArgs.jsxFilepath = args[flagOffset + 1];
}

/// Configuration arguments for the [decode] logic.
class DecodeArgs {
  late String jsxFilepath;
  late String jsxbinFilepath;
  bool printStructure = false;
}
