# Dynamic Theme Implementation Example

## 🔧 Complete Implementation Example

### **1. Project Setup Structure**

```
my_flutter_app/
├── assets/
│   ├── themes/
│   │   ├── default.json
│   │   ├── corporate_blue.json
│   │   ├── eco_green.json
│   │   └── modern_purple.json
│   └── config/
│       └── app_config.json
├── lib/
│   ├── core/
│   │   └── theme/
│   │       ├── services/
│   │       │   └── theme_service.dart
│   │       ├── widgets/
│   │       │   └── dynamic_theme_builder.dart
│   │       └── notifiers/
│   │           └── theme_notifier.dart
│   ├── main.dart
│   └── pages/
│       └── home_page.dart
```

### **2. Theme JSON Files**

#### **assets/themes/corporate_blue.json:**

```json
{
  "theme": {
    "name": "Corporate Blue",
    "brand": "TechCorp",
    "version": "1.0.0",
    "modes": {
      "light": {
        "colors": {
          "primary": "#1565C0",
          "secondary": "#FFC107",
          "background": "#F8F9FA",
          "surface": "#FFFFFF",
          "error": "#D32F2F",
          "onPrimary": "#FFFFFF",
          "onSecondary": "#000000",
          "onBackground": "#000000",
          "onSurface": "#000000"
        }
      },
      "dark": {
        "colors": {
          "primary": "#42A5F5",
          "secondary": "#FFD54F",
          "background": "#121212",
          "surface": "#1E1E1E",
          "error": "#F44336",
          "onPrimary": "#000000",
          "onSecondary": "#000000",
          "onBackground": "#FFFFFF",
          "onSurface": "#FFFFFF"
        }
      }
    },
    "typography": {
      "fontFamily": "Roboto",
      "sizes": {
        "h1": 32,
        "h2": 24,
        "body1": 16,
        "body2": 14
      }
    },
    "spacing": {
      "xs": 4,
      "sm": 8,
      "md": 16,
      "lg": 24,
      "xl": 32
    }
  }
}
```

#### **assets/themes/eco_green.json:**

```json
{
  "theme": {
    "name": "Eco Green",
    "brand": "GreenTech",
    "version": "1.0.0",
    "modes": {
      "light": {
        "colors": {
          "primary": "#4CAF50",
          "secondary": "#8BC34A",
          "background": "#F1F8E9",
          "surface": "#FFFFFF",
          "error": "#F44336",
          "accent": "#FF9800"
        }
      }
    }
  }
}
```

### **3. Core Implementation**

#### **lib/core/theme/services/theme_service.dart:**

```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notifiers/theme_notifier.dart';

class ThemeService {
  static ThemeService? _instance;
  static ThemeService get instance => _instance ??= ThemeService._();
  ThemeService._();

  Map<String, dynamic>? _themeConfig;
  String _currentThemeName = 'default';

  // Getters
  String get currentThemeName => _currentThemeName;
  String get brandName => _themeConfig?['theme']['brand'] ?? 'MyApp';
  String get themeName => _themeConfig?['theme']['name'] ?? 'Default';

  /// Load theme from assets
  Future<void> loadThemeFromAssets(String themePath) async {
    try {
      print('Loading theme from: $themePath');
      final String themeData = await rootBundle.loadString(themePath);
      _themeConfig = jsonDecode(themeData);
      _currentThemeName = themePath.split('/').last.replaceAll('.json', '');
      await _cacheThemeConfig();
      print('Theme loaded successfully: ${themeName}');
    } catch (e) {
      print('Error loading theme: $e');
      await _loadDefaultTheme();
    }
  }

  /// Get color by path
  Color getColor(String colorName, {bool isDark = false}) {
    try {
      final mode = isDark ? 'dark' : 'light';
      final colorHex = _themeConfig?['theme']['modes'][mode]['colors'][colorName];

      if (colorHex != null) {
        return _hexToColor(colorHex);
      }

      // Fallback to light mode if dark not available
      if (isDark) {
        final lightColorHex = _themeConfig?['theme']['modes']['light']['colors'][colorName];
        if (lightColorHex != null) {
          return _hexToColor(lightColorHex);
        }
      }

      return _getDefaultColor(colorName);
    } catch (e) {
      print('Error getting color $colorName: $e');
      return _getDefaultColor(colorName);
    }
  }

  /// Get spacing value
  double getSpacing(String spacingName) {
    try {
      final spacing = _themeConfig?['theme']['spacing'][spacingName];
      return spacing?.toDouble() ?? 16.0;
    } catch (e) {
      return 16.0;
    }
  }

  /// Get font size
  double getFontSize(String sizeName) {
    try {
      final size = _themeConfig?['theme']['typography']['sizes'][sizeName];
      return size?.toDouble() ?? 16.0;
    } catch (e) {
      return 16.0;
    }
  }

  /// Switch theme at runtime
  Future<void> switchTheme(String themeName) async {
    final themePath = 'assets/themes/$themeName.json';
    await loadThemeFromAssets(themePath);

    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_theme', themeName);

    // Notify listeners
    ThemeNotifier.instance.notifyThemeChanged();
  }

  /// Get available themes
  List<String> getAvailableThemes() {
    return ['default', 'corporate_blue', 'eco_green', 'modern_purple'];
  }

  /// Load saved theme preference
  Future<void> loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString('selected_theme') ?? 'default';
      await switchTheme(savedTheme);
    } catch (e) {
      await _loadDefaultTheme();
    }
  }

  // Private methods
  Future<void> _cacheThemeConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = jsonEncode(_themeConfig);
      await prefs.setString('cached_theme_config', themeString);
    } catch (e) {
      print('Error caching theme: $e');
    }
  }

  Future<void> _loadDefaultTheme() async {
    await loadThemeFromAssets('assets/themes/default.json');
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  Color _getDefaultColor(String colorName) {
    final defaultColors = {
      'primary': Colors.blue,
      'secondary': Colors.blueAccent,
      'background': Colors.white,
      'surface': Colors.white,
      'error': Colors.red,
      'onPrimary': Colors.white,
      'onSecondary': Colors.black,
      'onBackground': Colors.black,
      'onSurface': Colors.black,
    };
    return defaultColors[colorName] ?? Colors.blue;
  }
}
```

#### **lib/core/theme/notifiers/theme_notifier.dart:**

```dart
import 'package:flutter/foundation.dart';

class ThemeNotifier extends ChangeNotifier {
  static ThemeNotifier? _instance;
  static ThemeNotifier get instance => _instance ??= ThemeNotifier._();
  ThemeNotifier._();

  void notifyThemeChanged() {
    notifyListeners();
  }
}
```

#### **lib/core/theme/widgets/dynamic_theme_builder.dart:**

```dart
import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../notifiers/theme_notifier.dart';

class DynamicThemeBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, ThemeData lightTheme, ThemeData darkTheme) builder;
  final String? initialThemePath;

  const DynamicThemeBuilder({
    Key? key,
    required this.builder,
    this.initialThemePath,
  }) : super(key: key);

  @override
  _DynamicThemeBuilderState createState() => _DynamicThemeBuilderState();
}

class _DynamicThemeBuilderState extends State<DynamicThemeBuilder> {
  ThemeData? _lightTheme;
  ThemeData? _darkTheme;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialTheme();
    ThemeNotifier.instance.addListener(_onThemeChanged);
  }

  Future<void> _loadInitialTheme() async {
    if (widget.initialThemePath != null) {
      await ThemeService.instance.loadThemeFromAssets(widget.initialThemePath!);
    } else {
      await ThemeService.instance.loadSavedTheme();
    }
    _buildThemes();
  }

  void _onThemeChanged() {
    _buildThemes();
  }

  void _buildThemes() {
    final service = ThemeService.instance;

    setState(() {
      _lightTheme = _buildThemeData(false);
      _darkTheme = _buildThemeData(true);
      _isLoading = false;
    });
  }

  ThemeData _buildThemeData(bool isDark) {
    final service = ThemeService.instance;

    final ColorScheme colorScheme = isDark
        ? ColorScheme.dark(
            primary: service.getColor('primary', isDark: true),
            secondary: service.getColor('secondary', isDark: true),
            background: service.getColor('background', isDark: true),
            surface: service.getColor('surface', isDark: true),
            error: service.getColor('error', isDark: true),
          )
        : ColorScheme.light(
            primary: service.getColor('primary', isDark: false),
            secondary: service.getColor('secondary', isDark: false),
            background: service.getColor('background', isDark: false),
            surface: service.getColor('surface', isDark: false),
            error: service.getColor('error', isDark: false),
          );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: service.getFontSize('h1'),
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontSize: service.getFontSize('h2'),
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          fontSize: service.getFontSize('body1'),
        ),
        bodyMedium: TextStyle(
          fontSize: service.getFontSize('body2'),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: service.getSpacing('lg'),
            vertical: service.getSpacing('md'),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 2,
        margin: EdgeInsets.all(service.getSpacing('sm')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _lightTheme == null || _darkTheme == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return widget.builder(context, _lightTheme!, _darkTheme!);
  }

  @override
  void dispose() {
    ThemeNotifier.instance.removeListener(_onThemeChanged);
    super.dispose();
  }
}
```

### **4. App Implementation**

#### **lib/main.dart:**

```dart
import 'package:flutter/material.dart';
import 'core/theme/widgets/dynamic_theme_builder.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicThemeBuilder(
      initialThemePath: 'assets/themes/corporate_blue.json',
      builder: (context, lightTheme, darkTheme) {
        return MaterialApp(
          title: 'Dynamic Theme Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          home: HomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
```

#### **lib/pages/home_page.dart:**

```dart
import 'package:flutter/material.dart';
import '../core/theme/services/theme_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ThemeService themeService = ThemeService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${themeService.brandName} - ${themeService.themeName}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(themeService.getSpacing('md')),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThemeSelector(),
            SizedBox(height: themeService.getSpacing('lg')),
            _buildSampleContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(themeService.getSpacing('md')),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Theme',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: themeService.getSpacing('sm')),
            Wrap(
              spacing: themeService.getSpacing('sm'),
              children: themeService.getAvailableThemes().map((themeName) {
                final isSelected = themeService.currentThemeName == themeName;
                return FilterChip(
                  label: Text(themeName.replaceAll('_', ' ').toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      themeService.switchTheme(themeName);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleContent() {
    return Expanded(
      child: ListView(
        children: [
          Text(
            'Sample Content',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: themeService.getSpacing('md')),

          Card(
            child: Padding(
              padding: EdgeInsets.all(themeService.getSpacing('md')),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Primary Color Example',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: themeService.getSpacing('sm')),
                  Container(
                    height: 60,
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.primary,
                    child: Center(
                      child: Text(
                        'Primary Color',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: themeService.getSpacing('md')),

          Card(
            child: Padding(
              padding: EdgeInsets.all(themeService.getSpacing('md')),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buttons Example',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: themeService.getSpacing('sm')),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Primary Button'),
                      ),
                      SizedBox(width: themeService.getSpacing('sm')),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text('Outlined Button'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: themeService.getSpacing('md')),

          Card(
            child: Padding(
              padding: EdgeInsets.all(themeService.getSpacing('md')),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Typography Example',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: themeService.getSpacing('sm')),
                  Text(
                    'Headline Large',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    'Headline Medium',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'Body Large - Regular text content goes here',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Body Medium - Smaller text content',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### **5. pubspec.yaml Dependencies**

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/themes/
    - assets/config/
```

## 🚀 Usage Guide

### **1. Tạo Project Mới:**

```bash
# Clone base source
git clone your_base_source.git my_new_app
cd my_new_app

# Copy theme files
cp assets/themes/corporate_blue.json assets/themes/my_brand.json

# Edit theme colors
# Update JSON với brand colors của bạn
```

### **2. Customize Theme:**

```json
{
  "theme": {
    "name": "My Brand Theme",
    "brand": "MyCompany",
    "modes": {
      "light": {
        "colors": {
          "primary": "#YOUR_PRIMARY_COLOR",
          "secondary": "#YOUR_SECONDARY_COLOR",
          "background": "#YOUR_BACKGROUND_COLOR"
        }
      }
    }
  }
}
```

### **3. Update App Config:**

```dart
// In main.dart, change initial theme
DynamicThemeBuilder(
  initialThemePath: 'assets/themes/my_brand.json',
  builder: (context, lightTheme, darkTheme) {
    // Your app
  },
)
```

### **4. Build & Deploy:**

```bash
flutter build apk --release
# Theme được apply ngay lập tức!
```

## 📊 Benefits Demo

### **Before (Traditional):**

```dart
// Phải edit code mỗi project
class AppColors {
  static const Color primary = Color(0xFF2196F3); // Hard-coded
  static const Color secondary = Color(0xFF03DAC6); // Hard-coded
}

// Rebuild required for changes
```

### **After (Dynamic JSON):**

```json
{
  "theme": {
    "modes": {
      "light": {
        "colors": {
          "primary": "#2196F3",
          "secondary": "#03DAC6"
        }
      }
    }
  }
}
```

**Result:**

- ✅ **No code changes** required
- ✅ **Instant theme switching**
- ✅ **Easy customization**
- ✅ **Runtime updates possible**

## 🎯 Perfect Solution!

Với implementation này:

1. **🔄 Project Setup**: 5 phút
2. **🎨 Theme Customization**: 10 phút
3. **📱 Build & Deploy**: 5 phút
4. **⚡ Total Time**: 20 phút để có app mới với brand riêng!

**From weeks to minutes - That's the power of Dynamic Theme Loading!** 🚀
