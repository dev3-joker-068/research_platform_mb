# Flow Visualization - Multi-Language with Bloc

> **🎯 Goal**: Explain flow operations in a visual and easy-to-understand way.

## 🔄 **Flow 1: App Startup - App Initialization**

### **Step-by-Step Flow:**

```
1️⃣ 📱 App starts
    │
    ▼
2️⃣ 🔄 LanguageBloc created
    │
    ▼
3️⃣ 🌍 Auto-detect device language (first launch)
    │   └── ui.window.locale.languageCode
    │
    ▼
4️⃣ 💾 Check saved language preference
    │   └── GetStorage.read('selected_language')
    │
    ▼
5️⃣ 📄 Load corresponding JSON file
    │   ├── assets/languages/en.json (default)
    │   ├── assets/languages/vi.json
    │   └── assets/languages/ja.json
    │
    ▼
6️⃣ 🔄 Update LanguageLoaded state
    │   ├── currentLanguage: 'en'
    │   ├── translations: Map<String, String>
    │   ├── supportedLanguages: List<LanguageEntity>
    │   └── isFirstLaunch: true/false
    │
    ▼
7️⃣ 🖥️ UI displays with translations
    │   └── Text('hello_world'.tr()) → "Hello World"
```

### **Code Flow:**

```dart
// 1. App starts
void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

// 2. LanguageBloc created
BlocProvider<LanguageBloc>(
  create: (context) => LanguageBloc(LanguageServiceImpl())
    ..add(const LoadLanguage()), // 3. Trigger load
)

// 4. Service loads file with auto-detection
Future<void> _onLoadLanguage(LoadLanguage event, Emitter<LanguageState> emit) async {
  String languageCode;
  bool isFirstLaunch = false;

  // Check if it's first launch
  if (_languageService.isFirstLaunch()) {
    isFirstLaunch = true;
    // Auto-detect device language
    languageCode = _languageService.detectDeviceLanguage();
    debugPrint('First launch detected. Device language: $languageCode');
  } else {
    // Get saved language
    languageCode = event.languageCode ??
      _languageService.getSavedLanguage() ?? 'en';
  }

  // Load translations
  final translations = await _languageService.loadTranslations(languageCode);

  emit(LanguageLoaded(
    currentLanguage: languageCode,
    translations: translations,
    supportedLanguages: supportedLanguages,
    isFirstLaunch: isFirstLaunch,
  ));
}

// 5. UI uses translations
Text('hello_world'.tr()) // → "Hello World"
```

## 🔄 **Flow 2: Language Switching - Language Switching**

### **Step-by-Step Flow:**

```
1️⃣ 👤 User taps "Tiếng Việt"
    │
    ▼
2️⃣ 🖥️ UI sends event
    │   └── context.read<LanguageBloc>().add(ChangeLanguage('vi'))
    │
    ▼
3️⃣ 🔄 LanguageBloc processes event
    │   ├── emit(LanguageLoading())
    │   └── _onChangeLanguage()
    │
    ▼
4️⃣ 💾 Save new language
    │   └── GetStorage.write('selected_language', 'vi')
    │
    ▼
5️⃣ 📄 Load vi.json file
    │   └── assets/languages/vi.json
    │
    ▼
6️⃣ 🔄 Update new state
    │   ├── currentLanguage: 'vi'
    │   ├── translations: Map<String, String> (Vietnamese)
    │   └── supportedLanguages: List<LanguageEntity>
    │
    ▼
7️⃣ 🖥️ UI automatically rebuilds
    │   └── BlocBuilder rebuilds all widgets
    │
    ▼
8️⃣ 🔧 Extension methods get new translations
    │   └── 'hello_world'.tr() → "Xin chào thế giới"
```

### **Code Flow:**

```dart
// 1. User taps language option
ListTile(
  title: Text('Tiếng Việt'),
  onTap: () {
    // 2. Send event
    context.read<LanguageBloc>().add(ChangeLanguage('vi'));
    Navigator.pop(context);
  },
)

// 3. Bloc processes
Future<void> _onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) async {
  emit(LanguageLoading()); // Show loading

  // 4. Save language
  await _languageService.changeLanguage(event.languageCode);

  // 5. Load new file
  final translations = await _languageService.loadTranslations(event.languageCode);

  // 6. Emit new state
  emit(LanguageLoaded(
    currentLanguage: 'vi',
    translations: translations,
    supportedLanguages: supportedLanguages,
    isFirstLaunch: false,
  ));
}

// 7. UI automatically updates
BlocBuilder<LanguageBloc, LanguageState>(
  builder: (context, state) {
    if (state is LanguageLoaded) {
      return Text('hello_world'.tr()); // → "Xin chào thế giới"
    }
    return CircularProgressIndicator();
  },
)
```

## 🔄 **Flow 3: Auto Language Detection - Device Language Detection**

### **Step-by-Step Flow:**

```
1️⃣ 🌍 First app launch detected
    │   └── GetStorage.read('is_first_launch') == null
    │
    ▼
2️⃣ 📱 Get device locale
    │   └── ui.window.locale.languageCode
    │
    ▼
3️⃣ 🔍 Check if language is supported
    │   ├── 'en' → Supported ✅
    │   ├── 'vi' → Supported ✅
    │   ├── 'fr' → Supported ✅
    │   └── 'xx' → Not supported ❌
    │
    ▼
4️⃣ 🎯 Select appropriate language
    │   ├── Supported → Use device language
    │   ├── Not supported → Try base language
    │   └── Still not supported → Use English
    │
    ▼
5️⃣ 💾 Save selected language
    │   └── GetStorage.write('selected_language', 'vi')
    │
    ▼
6️⃣ 📄 Load language file
    │   └── assets/languages/vi.json
    │
    ▼
7️⃣ 🖥️ UI displays in detected language
    │   └── "Xin chào thế giới"
```

### **Code Flow:**

```dart
// 1. Check first launch
bool isFirstLaunch() {
  return _storage.read('is_first_launch') != false;
}

// 2. Detect device language
String detectDeviceLanguage() {
  try {
    final deviceLocale = ui.window.locale;
    final languageCode = deviceLocale.languageCode.toLowerCase();

    // 3. Check if supported
    if (_supportedLanguages.containsKey(languageCode)) {
      return languageCode;
    }

    // 4. Try base language
    final baseLanguage = languageCode.split('-')[0];
    if (_supportedLanguages.containsKey(baseLanguage)) {
      return baseLanguage;
    }

    // 5. Fallback to English
    return 'en';
  } catch (e) {
    return 'en';
  }
}

// 6. Supported languages mapping
static const Map<String, String> _supportedLanguages = {
  'en': 'en', 'vi': 'vi', 'ja': 'ja', 'ko': 'ko',
  'zh': 'zh', 'fr': 'fr', 'de': 'de', 'es': 'es',
  'pt': 'pt', 'ru': 'ru', 'ar': 'ar', 'hi': 'hi',
  'th': 'th', 'id': 'id', 'ms': 'ms',
};
```

## 🔄 **Flow 4: Extension Method - How .tr() works**

### **Step-by-Step Flow:**

```
1️⃣ 🔍 'hello_world'.tr() called
    │
    ▼
2️⃣ 📊 Get global context
    │   └── _globalNavigatorKey.currentContext
    │
    ▼
3️⃣ 🔄 Read state from LanguageBloc
    │   └── context.read<LanguageBloc>().state
    │
    ▼
4️⃣ ✅ Check state type
    │   ├── LanguageLoaded → Continue
    │   └── Other → Return key
    │
    ▼
5️⃣ 📋 Find key in translations
    │   ├── Found → Return translation
    │   └── Not found → Return key
    │
    ▼
6️⃣ 🖥️ Display result
    │   └── "Hello World"
```

### **Code Flow:**

```dart
// 1. Extension method called
Text('hello_world'.tr())

// 2. Extension implementation
extension StringTranslation on String {
  String tr() {
    return _getTranslation(this);
  }

  String _getTranslation(String key) {
    try {
      // 3. Get context
      final context = _getGlobalContext();
      if (context != null) {
        // 4. Read state
        final state = context.read<LanguageBloc>().state;

        // 5. Check and get translation
        if (state is LanguageLoaded) {
          return state.getTranslation(key);
        }
      }
    } catch (e) {
      debugPrint('Translation error: $e');
    }

    // 6. Fallback
    return key;
  }
}

// 7. Helper method in LanguageLoaded state
String getTranslation(String key) {
  return translations[key] ?? key; // Return translation or key
}
```

## 🎯 **Key Insights**

### **✅ Advantages of this flow:**

1. **Simple**: Each step is clear and easy to follow
2. **Efficient**: Cache in memory, fast loading
3. **Automatic**: UI automatically updates when language changes
4. **Smart Detection**: Automatically detects device language on first launch
5. **Fallback**: Always has backup solutions

### **🔧 Technical Benefits:**

- **Memory Cache**: No need to reload already loaded files
- **Lazy Loading**: Only load when needed
- **State Management**: Bloc manages state centrally
- **Extension Methods**: Simple, natural syntax
- **Auto Detection**: Smart device language detection

### **📱 User Experience:**

- **Instant Switch**: Switch language immediately
- **Persistent**: Remembers selected language
- **Smart Default**: Uses device language on first launch
- **Smooth**: No lag, no flicker
- **Intuitive**: Easy to use, easy to understand

## 🌍 **Supported Languages**

| **Language** | **Code** | **Native Name**  | **Flag** |
| ------------ | -------- | ---------------- | -------- |
| English      | en       | English          | 🇺🇸       |
| Vietnamese   | vi       | Tiếng Việt       | 🇻🇳       |
| Japanese     | ja       | 日本語           | 🇯🇵       |
| Korean       | ko       | 한국어           | 🇰🇷       |
| Chinese      | zh       | 中文             | 🇨🇳       |
| French       | fr       | Français         | 🇫🇷       |
| German       | de       | Deutsch          | 🇩🇪       |
| Spanish      | es       | Español          | 🇪🇸       |
| Portuguese   | pt       | Português        | 🇵🇹       |
| Russian      | ru       | Русский          | 🇷🇺       |
| Arabic       | ar       | العربية          | 🇸🇦       |
| Hindi        | hi       | हिन्दी           | 🇮🇳       |
| Thai         | th       | ไทย              | 🇹🇭       |
| Indonesian   | id       | Bahasa Indonesia | 🇮🇩       |
| Malay        | ms       | Bahasa Melayu    | 🇲🇾       |

---

> **💡 Key Insight**: This simple flow helps developers understand and implement easily, while providing the best user experience.

**🎯 Success Formula**: Simple Flow + Clear Steps + Visual Diagrams + Auto Detection = Easy Implementation
