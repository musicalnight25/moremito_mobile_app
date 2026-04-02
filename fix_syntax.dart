import 'dart:io';

void main() async {
  final analyzeFile = File('analyze.txt');
  if (!await analyzeFile.exists()) return;

  final lines = await analyzeFile.readAsLines();

  // Parse lines like: "  error - lib\pages\account\my_deep_link_screen.dart:26:16 - Extension methods can't be used in constant expressions. - const_eval_extension_method"
  final Map<String, List<int>> errorLinesMap = {};

  for (final line in lines) {
    if (line.contains('const_eval_extension_method') || line.contains('non_constant_list_element') || line.contains('invalid_assignment') || line.contains('non_constant_relational_pattern_expression')) {
      final parts = line.split(' - ');
      if (parts.length >= 2) {
        final locationInfo = parts[1].trim(); // e.g., "lib\pages\account\my_deep_link_screen.dart:26:16"
        final locParts = locationInfo.split(':');
        if (locParts.length >= 2) {
          final filePath = locParts[0];
          final lineNumber = int.tryParse(locParts[1]);
          if (lineNumber != null) {
            errorLinesMap.putIfAbsent(filePath, () => []).add(lineNumber);
          }
        }
      }
    }
  }

  for (final filePath in errorLinesMap.keys) {
    var errorLines = errorLinesMap[filePath]!;
    errorLines.sort(); // process from top to bottom
    final file = File(filePath);
    if (!await file.exists()) continue;

    List<String> contentLines = await file.readAsLines();
    bool modified = false;

    // We process each error line backwards up to 15 lines looking for `const `
    for (final errLine in errorLines) {
      if (errLine - 1 >= contentLines.length) continue;
      
      int searchStart = errLine - 1;
      int searchEnd = (searchStart - 20) < 0 ? 0 : (searchStart - 20);
      
      // Look for the closest `const ` above or on the line
      for (int i = searchStart; i >= searchEnd; i--) {
        if (contentLines[i].contains('const ')) {
          // Replace the last `const ` on that line
          final words = contentLines[i].split('const ');
          if (words.length > 1) {
            final prefix = words.sublist(0, words.length - 1).join('const ');
            final suffix = words.last;
            contentLines[i] = prefix + suffix;
            modified = true;
            break; // only remove one const
          }
        }
      }
    }

    if (modified) {
      await file.writeAsString(contentLines.join('\n'));
      print('Fixed \${filePath}');
    }
  }
}
