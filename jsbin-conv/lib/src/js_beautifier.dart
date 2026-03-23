import 'dart:io';
import 'package:path/path.dart' as p;

/// Provides a wrapper around the Jsbeautify external binary.
class JSBeautifier {
  /// Beautifies the provided [source] string using the external 'Jsbeautify' command.
  /// This implementation writes to a temporary file as the binary works on files directly.
  Future<String> beautify(String source) async {
    // Determine the command based on the OS.
    final command = Platform.isWindows ? 'Jsbeautify.exe' : 'Jsbeautify';

    final tempDir = Directory.systemTemp.createTempSync('jsbin-conv-');
    final tempFile = File(p.join(tempDir.path, 'output.js'));

    try {
      await tempFile.writeAsString(source);

      // We assume the binary is in the PATH or in the relative directory.
      // Note: In production, the user would provide the path or have it in PATH.
      final process = await Process.run(command, [tempFile.path]);

      if (process.exitCode != 0) {
        stderr.writeln(
          "Jsbeautify failed with exit code ${process.exitCode}: ${process.stderr}",
        );
        return source;
      }

      final formattedCode = await tempFile.readAsString();
      return formattedCode;
    } catch (e) {
      stderr.writeln(
        "Could not run $command. Please ensure it is installed and in your PATH. Error: $e",
      );
      return source;
    } finally {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    }
  }
}
