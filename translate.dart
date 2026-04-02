import 'dart:io';

void main() async {
  final directory = Directory('lib');
  if (!await directory.exists()) {
    print('lib directory not found');
    return;
  }

  final stringsDict = <String, String>{};

  final files = directory.listSync(recursive: true).whereType<File>().where((file) {
    return file.path.endsWith('.dart') && !file.path.endsWith('app_translations.dart');
  }).toList();

  for (final file in files) {
    if (await processFile(file, stringsDict)) {
      print('Updated ${file.path}');
    }
  }

  await generateTranslationFile(stringsDict);
}

Future<bool> processFile(File file, Map<String, String> stringsDict) async {
  String content = await file.readAsString();
  String newContent = content;

  // Pattern: getXSnackBar("title", "msg"
  final snackPattern = RegExp(r'CommonMethod\.getXSnackBar\(\s*["' + "'" + r']([^"' + "'" + r'\\]+)["' + "'" + r']\s*,\s*["' + "'" + r']([^"' + "'" + r'\\]+)["' + "'" + r']');
  newContent = newContent.replaceAllMapped(snackPattern, (match) {
    final s1 = match.group(1)!;
    final s2 = match.group(2)!;
    stringsDict[s1] = s1;
    stringsDict[s2] = s2;
    return 'CommonMethod.getXSnackBar("$s1".tr, "$s2".tr';
  });

  // Simple patterns with one group
  final patterns = [
    RegExp(r'Text\(\s*["' + "'" + r']([^"' + "'" + r'\\]+)["' + "'" + r']'),
    RegExp(r'hintText:\s*["' + "'" + r']([^"' + "'" + r'\\]+)["' + "'" + r']'),
    RegExp(r'labelText:\s*["' + "'" + r']([^"' + "'" + r'\\]+)["' + "'" + r']'),
    RegExp(r'title:\s*["' + "'" + r']([^"' + "'" + r'\\]+)["' + "'" + r']'),
    RegExp(r'label:\s*["' + "'" + r']([^"' + "'" + r'\\]+)["' + "'" + r']'),
    RegExp(r'PrimaryTextButton\(\s*title:\s*["' + "'" + r']([^"' + "'" + r'\\]+)["' + "'" + r']'),
    RegExp(r'ActionTextButton\(\s*title:\s*["' + "'" + r']([^"' + "'" + r'\\]+)["' + "'" + r']'),
    RegExp(r'CancelTextButton\(\s*title:\s*["' + "'" + r']([^"' + "'" + r'\\]+)["' + "'" + r']'),
  ];

  for (final pattern in patterns) {
    newContent = newContent.replaceAllMapped(pattern, (match) {
      final s = match.group(1)!;
      stringsDict[s] = s;
      final fullMatch = match.group(0)!;
      final replaceWithTr = fullMatch.replaceFirst('"$s"', '"$s".tr').replaceFirst("'$s'", '"$s".tr');
      return replaceWithTr;
    });
  }

  if (newContent != content) {
    await file.writeAsString(newContent);
    return true;
  }
  return false;
}

Future<void> generateTranslationFile(Map<String, String> stringsDict) async {
  final file = File('lib/utils/app_translations.dart');

  String keysStr = "";
  for (final k in stringsDict.keys) {
    final safeK = k.replaceAll('"', '\\"').replaceAll('\$', '\\\$').replaceAll('\n', '\\n');
    keysStr += '        "$safeK": "$safeK",\n';
  }

  String zhKeysStr = "";
  for (final k in stringsDict.keys) {
    final safeK = k.replaceAll('"', '\\"').replaceAll('\$', '\\\$').replaceAll('\n', '\\n');
    zhKeysStr += '        "$safeK": "$safeK (zh)",\n';
  }

  final content = '''import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
\$keysStr
        },
        'zh_CN': {
\$zhKeysStr
        },
      };
}
'''.replaceAll('\$keysStr', keysStr).replaceAll('\$zhKeysStr', zhKeysStr);

  await file.writeAsString(content);
  print('Generated \${file.path} with \${stringsDict.length} translations.');
}
