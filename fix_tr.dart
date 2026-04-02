import 'dart:io';

void main() async {
  final directory = Directory('lib');
  if (!await directory.exists()) return;

  final files = directory.listSync(recursive: true).whereType<File>().where((file) {
    return file.path.endsWith('.dart');
  }).toList();

  for (final file in files) {
    String content = await file.readAsString();
    if (content.contains('.tr.tr')) {
      content = content.replaceAll('.tr.tr', '.tr');
      await file.writeAsString(content);
      print('Fixed \${file.path}');
    }
  }
}
