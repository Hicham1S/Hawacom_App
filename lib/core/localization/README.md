# i18n (Internationalization) Guide

## What We've Implemented

Your app now supports **multiple languages** (Arabic & English) using Flutter's official i18n system.

---

## Files Created

### 1. Translation Files (`.arb` format)
- `app_en.arb` - English translations
- `app_ar.arb` - Arabic translations

### 2. Generated Files (Auto-generated)
- `app_localizations.dart` - Main localization class
- `app_localizations_ar.dart` - Arabic implementation
- `app_localizations_en.dart` - English implementation

---

## How to Use

### In Your Widgets:

```dart
// 1. Import the localizations
import '../../l10n/app_localizations.dart';

// 2. Get the localizations object
final l10n = AppLocalizations.of(context)!;

// 3. Use it in Text widgets
Text(l10n.clickHere)  // Shows: "اضغط هنا" (Arabic) or "Click Here" (English)
Text(l10n.search)      // Shows: "البحث عن الخدمة..." or "Search for service..."
```

---

## Available Translations

| Key | Arabic | English |
|-----|--------|---------|
| `appTitle` | تطبيق التصميم | Design App |
| `clickHere` | اضغط هنا | Click Here |
| `addStory` | أضف ستوري | Add Story |
| `search` | البحث عن الخدمة... | Search for service... |
| `live` | مباشر | Live |
| `restContent` | المحتوى سيأتي هنا | Rest of content will come here |
| `ahmadAlShehri` | أحمد الشقيري | Ahmad Al-Shehri |
| `aminaAlHajri` | أميمة الهاجري | Amina Al-Hajri |
| `mohammedAli` | محمد علي | Mohammed Ali |
| `sarahAhmed` | سارة أحمد | Sarah Ahmed |

---

## Adding New Translations

### Step 1: Add to Both .arb Files

**app_en.arb:**
```json
{
  "newKey": "English Text Here"
}
```

**app_ar.arb:**
```json
{
  "newKey": "النص العربي هنا"
}
```

### Step 2: Run Code Generation
```bash
flutter pub get
```

### Step 3: Use in Your Code
```dart
Text(AppLocalizations.of(context)!.newKey)
```

---

## Changing Language

### Current Setup:
- **Default Language**: Arabic (`ar`)
- **Supported Languages**: Arabic (`ar`), English (`en`)

### To Switch Language Dynamically:

Update `main.dart`:
```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ar');

  void changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,  // Dynamic locale
      // ... rest of code
    );
  }
}
```

Then call `changeLanguage('en')` or `changeLanguage('ar')` from settings.

---

## Best Practices

### ✅ DO:
- Use i18n for **all user-facing text**
- Use descriptive keys (`clickHere` not `btn1`)
- Keep translations synchronized between languages
- Run `flutter pub get` after adding new translations

### ❌ DON'T:
- Hardcode text in widgets (use i18n instead)
- Use i18n for dynamic data from APIs (user names, posts, etc.)
- Forget to add translations to both .arb files

---

## Troubleshooting

### Error: "Undefined name 'AppLocalizations'"
**Solution:** Run `flutter pub get` to generate localization files.

### Error: "Target of URI doesn't exist"
**Solution:** Check import path is `import '../../l10n/app_localizations.dart';`

### Text Not Changing
**Solution:**
1. Verify translation exists in both .arb files
2. Run `flutter pub get`
3. Hot restart (R) not hot reload (r)

---

## File Structure

```
lib/
└── l10n/
    ├── app_ar.arb                    # Arabic translations (YOU EDIT)
    ├── app_en.arb                    # English translations (YOU EDIT)
    ├── app_localizations.dart        # Generated (DON'T EDIT)
    ├── app_localizations_ar.dart     # Generated (DON'T EDIT)
    └── app_localizations_en.dart     # Generated (DON'T EDIT)
```

---

## Example: Adding a New Translation

**Scenario:** Add "Welcome" message

**1. Edit app_en.arb:**
```json
{
  "@@locale": "en",
  "welcome": "Welcome to our app!"
}
```

**2. Edit app_ar.arb:**
```json
{
  "@@locale": "ar",
  "welcome": "مرحباً بك في تطبيقنا!"
}
```

**3. Run:**
```bash
flutter pub get
```

**4. Use in code:**
```dart
Text(AppLocalizations.of(context)!.welcome)
```

---

## Resources

- [Flutter i18n Official Docs](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- [ARB File Format](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)

---

**Status:** ✅ Fully Implemented
**Last Updated:** October 2025
