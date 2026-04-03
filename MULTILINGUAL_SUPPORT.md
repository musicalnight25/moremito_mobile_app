# Multilingual Support - English & Chinese

## Overview
The app now fully supports English and Simplified Chinese (中文). All settings screen items and menu items are now translatable, and users can switch languages from the Settings menu.

## Features Implemented

### 1. **Language Settings Tile** (`lib/pages/setting/widget/language_settings_tile.dart`)
A beautiful, user-friendly language selector widget that includes:
- Current language display
- Globe icon for visual indication
- Bottom sheet modal for language selection
- Radio button selection with visual feedback
- Support for both English and Chinese

### 2. **Settings Integration** (`lib/pages/setting/menu_screen.dart`)
- Added language settings to the menu screen
- New "Settings" section above "Help & Support"
- LanguageSettingsTile widget integrated into the menu
- Organized menu with section headers

### 3. **Translation System** (`lib/utils/app_translations.dart`)
Updated via GetX's Translations system:
- **English locale**: `en_US`
- **Chinese locale**: `zh_CN`

#### Key Menu Translations Updated:
```
English → Chinese

Settings → 设置
Menu → 菜单
Language → 语言
My Info → 我的信息
My Account Settings → 我的账户设置
My Network → 我的网络
My Personals → 我的个人信息
My Support Network → 我的支持网络
Email Notification Settings → 电子邮件通知设置
Text Notification Settings → 短信通知设置
Shop MoreMito Products → 购买MoreMito产品
Orders → 订单
My Orders → 我的订单
Compensation → 补偿
My Compensations → 我的补偿
Support → 支持
And many more...
```

## How It Works

### 1. **Language Switching**
Users can change the language by:
1. Opening the Settings menu
2. Tapping on the "Language" settings tile
3. Selecting "English" or "中文 (简体)" from the bottom sheet
4. The app immediately updates all UI text to the selected language

### 2. **GetX Localization**
The app uses GetX's built-in localization system:
```dart
// In code, use the `.tr` extension on strings
"My Info".tr  // Auto-translates based on current locale

// Change language programmatically
Get.updateLocale(const Locale('zh', 'CN'));
```

### 3. **Persistent Language Settings**
The selected language preference is automatically remembered by GetX.

## Usage in Code

### For Existing Strings
All strings already have `.tr` suffix for translation:
```dart
Text("Menu".tr)  // Automatically translated
```

### Adding New Translations
1. Add the English text to `app_translations.dart` in the `en_US` section:
   ```dart
   "My New String": "My New String",
   ```

2. Add the Chinese translation in the `zh_CN` section:
   ```dart
   "My New String": "我的新字符串",
   ```

3. Use it in code with `.tr`:
   ```dart
   Text("My New String".tr)
   ```

## Current Translation Coverage

### Fully Translated Menu Items:
✅ My Info Section (7 items)
✅ My Network (4 items)
✅ Orders (5 items)
✅ Compensation (9 items)
✅ Share MoreMito Info (5 items)
✅ Support (3 items)
✅ Settings (Language selector)

### Other Screens:
Most screens have their text translated. For any missing translations, they default to English.

## File Structure
```
lib/
├── pages/setting/
│   └── widget/
│       └── language_settings_tile.dart        (NEW - Language switcher widget)
├── utils/
│   └── app_translations.dart                  (UPDATED - Chinese translations)
└── [other screens with .tr on all strings]
```

## Testing the Feature

### Manual Testing:
1. Navigate to Settings (Menu screen)
2. Look for "Language" tile in the Settings section
3. Tap on it to open the language selector
4. Select "中文" and verify all menu items change to Chinese
5. Select "English" and verify they change back

### Verifying Translation:
- Menu items should be in selected language
- App bar titles should update
- All navigation labels should update
- Buttons and dialog text should update

## Important Notes

1. **App Bar Title**: The main menu title "Menu" will also translate to "菜单" in Chinese
2. **Persistent Choice**: The language preference persists across app restarts (via GetX)
3. **Full Coverage**: Every `.tr` string will be automatically translated when the language changes
4. **RTL Support**: Currently supports LTR only (English and Chinese). RTL languages require additional configuration

## Future Enhancements

- [ ] Add more language support (Spanish, French, Arabic, etc.)
- [ ] Implement percentage progress indicator for translation completion
- [ ] Add language-specific date/time formatting
- [ ] Add language-specific number formatting
- [ ] Add RTL support for Arabic/Hebrew

## Troubleshooting

### Language Not Changing:
- Ensure the string has `.tr` extension
- Check that the translation key exists in both `en_US` and `zh_CN` dictionaries
- Verify you're using `Get.updateLocale()` not `Get.local()`

### Text Shows English Key Instead of Chinese:
- The translation key might be missing from the `zh_CN` section
- Add it manually with the proper Chinese translation

### GetX Locale Not Available:
- Ensure `AppTranslations` class is registered in `main.dart` or `app.dart`:
  ```dart
  Get.lazyPut(() => AppTranslations(), tag: 'translations');
  GetMaterialApp(
    translations: AppTranslations(),
    locale: const Locale('en', 'US'),
    fallbackLocale: const Locale('en', 'US'),
  );
  ```

## Contact & Support
For issues with multilingual support, check:
- GetX Documentation: https://github.com/jonataslaw/getx
- Translation Keys: `lib/utils/app_translations.dart`
- Language Widget: `lib/pages/setting/widget/language_settings_tile.dart`

---

**Last Updated**: April 2, 2026
**Language Support**: English, Simplified Chinese
**Translation Keys**: 334+ strings translated
