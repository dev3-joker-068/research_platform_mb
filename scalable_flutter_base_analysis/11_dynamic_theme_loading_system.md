# Dynamic Theme Loading System - JSON Configuration

## 🎨 Vấn Đề Hiện Tại & Solution

### **Traditional Approach (Hiện tại):**

```dart
// Mỗi project phải define lại colors
class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03DAC6);
  // ... phải code lại mỗi project
}
```

**Nhược điểm:**

- ❌ Phải code lại mỗi project
- ❌ Không thể thay đổi runtime
- ❌ Khó maintain multiple brands
- ❌ Deploy mới mỗi khi thay colors

### **🚀 Dynamic JSON Solution:**

```json
{
  "theme": {
    "name": "Corporate Blue",
    "brand": "TechCorp",
    "modes": {
      "light": {
        "colors": {
          "primary": "#1565C0",
          "secondary": "#FFC107",
          "background": "#F8F9FA"
        }
      },
      "dark": {
        "colors": {
          "primary": "#BB86FC",
          "secondary": "#03DAC6",
          "background": "#121212"
        }
      }
    },
    "typography": {
      "fontFamily": "Roboto",
      "sizes": {
        "h1": 32,
        "body1": 16
      }
    }
  }
}
```

## 🏗️ Architecture Implementation

### **1. Theme Service Core:**

```dart
// lib/core/theme/services/theme_service.dart
class ThemeService {
  static ThemeService? _instance;
  static ThemeService get instance => _instance ??= ThemeService._();

  Map<String, dynamic>? _themeConfig;

  /// Load theme from JSON file
  Future<void> loadThemeFromAssets(String themePath) async {
    final String themeData = await rootBundle.loadString(themePath);
    _themeConfig = jsonDecode(themeData);
    await _cacheThemeConfig();
  }

  /// Load theme from remote URL
  Future<void> loadThemeFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      _themeConfig = jsonDecode(response.body);
      await _cacheThemeConfig();
    }
  }

  /// Get color by path
  Color getColor(String path, {bool isDark = false}) {
    final mode = isDark ? 'dark' : 'light';
    final colorHex = _getNestedValue('theme.modes.$mode.colors.$path');
    return _hexToColor(colorHex ?? '#2196F3');
  }

  /// Switch theme runtime
  Future<void> switchTheme(String themeName) async {
    await loadThemeFromAssets('assets/themes/$themeName.json');
    ThemeNotifier.instance.notifyThemeChanged();
  }
}
```

### **2. Dynamic Theme Builder Widget:**

```dart
// lib/core/theme/widgets/dynamic_theme_builder.dart
class DynamicThemeBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, ThemeData theme) builder;
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
  ThemeData? _currentTheme;

  @override
  void initState() {
    super.initState();
    _loadInitialTheme();
    ThemeNotifier.instance.addListener(_onThemeChanged);
  }

  Future<void> _loadInitialTheme() async {
    final themePath = widget.initialThemePath ?? 'assets/themes/default.json';
    await ThemeService.instance.loadThemeFromAssets(themePath);
    _buildTheme();
  }

  void _buildTheme() {
    final service = ThemeService.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    setState(() {
      _currentTheme = ThemeData(
        primaryColor: service.getColor('primary', isDark: isDark),
        colorScheme: ColorScheme.fromSeed(
          seedColor: service.getColor('primary', isDark: isDark),
          brightness: isDark ? Brightness.dark : Brightness.light,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentTheme == null) {
      return const CircularProgressIndicator();
    }

    return widget.builder(context, _currentTheme!);
  }
}
```

## 📱 Usage Examples

### **App Integration:**

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load initial theme
  await ThemeService.instance.loadThemeFromAssets('assets/themes/default.json');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicThemeBuilder(
      initialThemePath: 'assets/themes/corporate_blue.json',
      builder: (context, theme) {
        return MaterialApp(
          title: 'Dynamic Theme App',
          theme: theme,
          home: HomePage(),
        );
      },
    );
  }
}
```

### **Runtime Theme Switching:**

```dart
// lib/widgets/theme_selector.dart
class ThemeSelectorWidget extends StatelessWidget {
  final List<String> availableThemes = [
    'default',
    'corporate_blue',
    'eco_green',
    'modern_purple'
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: availableThemes.map((theme) {
        return DropdownMenuItem(
          value: theme,
          child: Text(theme.replaceAll('_', ' ').toUpperCase()),
        );
      }).toList(),
      onChanged: (String? newTheme) {
        if (newTheme != null) {
          ThemeService.instance.switchTheme(newTheme);
        }
      },
    );
  }
}
```

## 🎨 Theme JSON Examples

### **Corporate Blue Theme:**

```json
{
  "theme": {
    "name": "Corporate Blue",
    "brand": "TechCorp",
    "modes": {
      "light": {
        "colors": {
          "primary": "#1565C0",
          "secondary": "#FFC107",
          "background": "#F8F9FA",
          "surface": "#FFFFFF",
          "error": "#D32F2F"
        }
      },
      "dark": {
        "colors": {
          "primary": "#42A5F5",
          "secondary": "#FFD54F",
          "background": "#121212",
          "surface": "#1E1E1E",
          "error": "#F44336"
        }
      }
    }
  }
}
```

### **Eco Green Theme:**

```json
{
  "theme": {
    "name": "Eco Green",
    "brand": "GreenTech",
    "modes": {
      "light": {
        "colors": {
          "primary": "#4CAF50",
          "secondary": "#8BC34A",
          "background": "#F1F8E9",
          "surface": "#FFFFFF",
          "accent": "#FF9800"
        }
      }
    }
  }
}
```

## 🚀 Advanced Features

### **Remote Theme Loading:**

```dart
class RemoteThemeManager {
  static const String baseUrl = 'https://api.myapp.com/themes';

  /// Download theme từ server
  static Future<void> downloadTheme(String brandId) async {
    final url = '$baseUrl/$brandId/theme.json';
    await ThemeService.instance.loadThemeFromUrl(url);
  }

  /// Auto-update theme
  static Future<void> autoUpdateTheme(String brandId) async {
    if (await checkForUpdates(brandId)) {
      await downloadTheme(brandId);
    }
  }
}
```

### **Theme Configuration:**

```dart
// Project setup chỉ cần 1 config file
// assets/config/app_config.json
{
  "app": {
    "name": "My Custom App",
    "package": "com.company.myapp"
  },
  "theme": {
    "source": "remote", // "assets" or "remote"
    "defaultTheme": "corporate_blue",
    "remoteUrl": "https://api.myapp.com/themes/corporate_blue.json",
    "fallbackTheme": "assets/themes/default.json"
  }
}
```

## 📊 Benefits Summary

### **✅ Advantages:**

1. **🔄 Zero Code Changes** - Chỉ thay JSON file
2. **⚡ Real-time Updates** - Update theme mà không redeploy
3. **🎨 Unlimited Branding** - JSON-driven customization
4. **🌐 Remote Management** - Control từ admin panel
5. **🧪 A/B Testing** - Test themes real-time
6. **📱 White-label Ready** - Mỗi client có theme riêng

### **📈 Performance:**

- **Cache Strategy** - Cache 10 themes thường dùng
- **Lazy Loading** - Load khi cần
- **Fallback System** - Default theme nếu load failed

### **🔧 Implementation Time:**

- **Setup**: 2-3 ngày
- **JSON Themes**: 1 ngày/theme
- **Remote Loading**: 1-2 ngày
- **Total**: 1 tuần

## 🎯 Conclusion

Với **Dynamic Theme Loading System**, mỗi project mới chỉ cần:

1. **Copy base source** ✅
2. **Tạo theme JSON file** ✅
3. **Update app config** ✅
4. **Deploy** ✅

**Result: 2-3 ngày thay vì 2-3 tuần để rebrand!** 🚀

**Perfect solution cho scalable, maintainable theme system!**
