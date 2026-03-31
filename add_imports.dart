import 'dart:io';

void main() async {
  final files = [
    'lib/pages/setting/grief_relief_zoom_screen.dart',
    'lib/pages/setting/mitochondria_story_screen.dart',
    'lib/pages/setting/testimonials_screen.dart',
    'lib/utils/FcmTokenScreen.dart',
    'lib/utils/svg_handler.dart',
  ];

  for (final path in files) {
    var file = File(path);
    if (!await file.exists()) continue;
    var content = await file.readAsString();
    if (!content.contains("import 'package:get/get.dart';")) {
       content = "import 'package:get/get.dart';\n" + content;
       await file.writeAsString(content);
       print('Added to $path');
    }
  }
}
