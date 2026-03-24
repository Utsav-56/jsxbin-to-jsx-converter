import 'dart:io';
import 'package:interact/interact.dart';
import 'package:path/path.dart' as p;
import 'package:jsbin_conv/src/converter.dart';

class InteractiveMode {
  Future<void> start() async {
    final selection = Select(
      prompt: 'Choose an option',
      options: ['Choose Files manually', 'Convert all files in cwd', 'Change dir'],
    ).interact();

    switch (selection) {
      case 0:
        await _chooseFilesManually();
        break;
      case 1:
        await _convertAllInCwd();
        break;
      case 2:
        _changeDir();
        break;
    }
  }

  Future<void> _chooseFilesManually() async {
    final cwd = Directory.current;
    final files = cwd.listSync().whereType<File>().toList();

    // User said "ends with the extension of jsx" but I'll assume they meant jsxbin or both.
    // I'll stick to their requirement: "ends with the extension of jsx".
    final jsxFiles = files.where((f) => f.path.endsWith('.jsx')).toList();

    if (jsxFiles.isEmpty) {
      print('No .jsx files found in ${cwd.path}');
      return;
    }

    final selectedIndices = MultiSelect(
      prompt: 'Select files to convert',
      options: jsxFiles.map((f) => p.basename(f.path)).toList(),
    ).interact();

    final converter = Converter();
    final outputDir = Directory(p.join(cwd.path, 'jsxbin-converted'));
    if (!outputDir.existsSync()) {
      outputDir.createSync();
    }

    for (final index in selectedIndices) {
      final file = jsxFiles[index];
      final filename = p.basenameWithoutExtension(file.path);
      final destPath = Converter.getNonCollidingPath(outputDir.path, '$filename.jsx');
      await converter.decode(file.path, destPath);
    }
  }

  Future<void> _convertAllInCwd() async {
    final cwd = Directory.current;
    final files = cwd
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.jsxbin'))
        .toList();

    if (files.isEmpty) {
      print('No .jsxbin files found in ${cwd.path}');
      return;
    }

    final outputDir = Directory(p.join(cwd.path, 'jsxbin-converted'));
    if (!outputDir.existsSync()) {
      outputDir.createSync();
    }

    final converter = Converter();
    for (final file in files) {
      final filename = p.basenameWithoutExtension(file.path);
      final destPath = Converter.getNonCollidingPath(outputDir.path, '$filename.jsx');
      await converter.decode(file.path, destPath);
    }
  }

  void _changeDir() {
    final newPath = Input(prompt: 'Enter new directory path').interact();
    final newDir = Directory(newPath);
    if (newDir.existsSync()) {
      Directory.current = newDir;
      print('Current directory changed to ${Directory.current.path}');
    } else {
      print('Directory does not exist: $newPath');
    }
  }
}
