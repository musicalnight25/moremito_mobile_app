import 'dart:io';

void main() async {
  final file = File('lib/utils/app_translations.dart');
  if (!await file.exists()) {
    print('File not found');
    return;
  }
  
  final content = await file.readAsString();
  final lines = content.split('\n');
  final result = <String>[];
  
  bool skip = false;
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    
    // Skip multiline broken string starting with ".tr,"
    if (line.contains('".tr,') && line.contains('style:')) {
      skip = true;
    }
    
    if (skip) {
      if (line.contains('title: ",')) {
        skip = false;
        continue;
      }
      if (line.contains('title:  (zh)",')) {
        skip = false;
        continue;
      }
      if (line.contains('value ?? ",')) {
        skip = false;
        continue;
      }
      if (line.contains('value ??  (zh)",')) {
        skip = false;
        continue;
      }
      continue;
    }
    
    if (line.contains('@\${user.username ?? "')) {
      continue;
    }
    
    result.add(line);
  }
  
  await file.writeAsString(result.join('\n'));
  print('Fixed translations');
}
