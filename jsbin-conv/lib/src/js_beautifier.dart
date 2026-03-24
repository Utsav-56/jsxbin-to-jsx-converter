import 'dart:convert';
import 'dart:io';

/// Provides a wrapper around the clang-format based beautifier.
class JSBeautifier {
  /// Beautifies the provided [source] string using the embedded 'jsxbin-conv-makeup-man' binary.
  Future<String> beautify(String source) async {
    // Determine the command based on the OS.
    final command = Platform.isWindows
        ? 'jsxbin-conv-makeup-man.exe'
        : 'jsxbin-conv-makeup-man';

    // Clang-format configuration style.
    const styleConfig =
        '{Language: JavaScript, BasedOnStyle: Google, IndentWidth: 2, JavaScriptQuotes: Single, ColumnLimit: 100}';

    try {
      // Start the process with the style configuration.
      final process = await Process.start(command, [
        '-style=$styleConfig',
        '--assume-filename=output.js',
      ]);

      // Write the source code to the process's stdin.
      process.stdin.write(source);
      await process.stdin.close();

      // Collect the formatted output from stdout.
      final output = await process.stdout.transform(utf8.decoder).join();
      final error = await process.stderr.transform(utf8.decoder).join();

      final exitCode = await process.exitCode;
      if (exitCode != 0) {
        stderr.writeln("jsxbin-conv-makeup-man failed with exit code $exitCode: $error");
        return source;
      }

      return output;
    } catch (e) {
      stderr.writeln(
        "Could not run $command. Please ensure it is bundled correctly. Error: $e",
      );
      return source;
    }
  }

  /// Checks if the beautifier binary is available.
  bool isAvailable() {
    final command = Platform.isWindows
        ? 'jsxbin-conv-makeup-man.exe'
        : 'jsxbin-conv-makeup-man';
    try {
      final process = Process.runSync(command, ['--version']);
      return process.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  /// Returns the version of the beautifier binary.
  static String getVersion() {
    final command = Platform.isWindows
        ? 'jsxbin-conv-makeup-man.exe'
        : 'jsxbin-conv-makeup-man';
    try {
      final process = Process.runSync(command, ['--version']);
      if (process.exitCode == 0) {
        return process.stdout.toString().trim();
      }
      return 'Unknown (exit code ${process.exitCode})';
    } catch (e) {
      return 'Not found ($e)';
    }
  }
}
