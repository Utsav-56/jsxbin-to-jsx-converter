import 'package:interact/interact.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  final answers = MultiSelect(
    prompt: 'Let me know your answers',
    options: ['A', 'B', 'C'],
    defaults: [false, true, false], // optional, will be all false by default
  ).interact();
}
