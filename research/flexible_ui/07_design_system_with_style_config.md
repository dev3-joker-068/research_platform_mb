# Design System với Style Configuration

## Overview

Xây dựng bộ UI common cơ bản với khả năng load config style (radius, space, grid, colors, typography) để dễ dàng thay đổi design system mà không cần sửa code.

## 1. Design System Architecture

### 1.1 Core Design Tokens

```dart
class DesignTokens {
  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // Border Radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusXXL = 24.0;

  // Grid System
  static const double gridXS = 4.0;
  static const double gridS = 8.0;
  static const double gridM = 16.0;
  static const double gridL = 24.0;
  static const double gridXL = 32.0;

  // Typography
  static const double fontSizeXS = 12.0;
  static const double fontSizeS = 14.0;
  static const double fontSizeM = 16.0;
  static const double fontSizeL = 18.0;
  static const double fontSizeXL = 20.0;
  static const double fontSizeXXL = 24.0;

  // Colors
  static const Color primaryColor = Color(0xFF007AFF);
  static const Color secondaryColor = Color(0xFF5856D6);
  static const Color successColor = Color(0xFF34C759);
  static const Color warningColor = Color(0xFFFF9500);
  static const Color errorColor = Color(0xFFFF3B30);
  static const Color neutral100 = Color(0xFFF2F2F7);
  static const Color neutral200 = Color(0xFFE5E5EA);
  static const Color neutral300 = Color(0xFFD1D1D6);
  static const Color neutral400 = Color(0xFFC7C7CC);
  static const Color neutral500 = Color(0xFFAEAEB2);
  static const Color neutral600 = Color(0xFF8E8E93);
  static const Color neutral700 = Color(0xFF636366);
  static const Color neutral800 = Color(0xFF48484A);
  static const Color neutral900 = Color(0xFF1C1C1E);
}
```

### 1.2 Style Configuration System

```dart
class StyleConfig {
  final Map<String, double> spacing;
  final Map<String, double> radius;
  final Map<String, double> grid;
  final Map<String, double> typography;
  final Map<String, Color> colors;
  final Map<String, TextStyle> textStyles;

  StyleConfig({
    required this.spacing,
    required this.radius,
    required this.grid,
    required this.typography,
    required this.colors,
    required this.textStyles,
  });

  static StyleConfig fromJson(Map<String, dynamic> json) {
    return StyleConfig(
      spacing: _parseSpacing(json['spacing']),
      radius: _parseRadius(json['radius']),
      grid: _parseGrid(json['grid']),
      typography: _parseTypography(json['typography']),
      colors: _parseColors(json['colors']),
      textStyles: _parseTextStyles(json['text_styles']),
    );
  }

  static Map<String, double> _parseSpacing(dynamic spacing) {
    if (spacing is Map) {
      return spacing.map((key, value) => MapEntry(key, value.toDouble()));
    }
    return {};
  }

  static Map<String, double> _parseRadius(dynamic radius) {
    if (radius is Map) {
      return radius.map((key, value) => MapEntry(key, value.toDouble()));
    }
    return {};
  }

  static Map<String, double> _parseGrid(dynamic grid) {
    if (grid is Map) {
      return grid.map((key, value) => MapEntry(key, value.toDouble()));
    }
    return {};
  }

  static Map<String, double> _parseTypography(dynamic typography) {
    if (typography is Map) {
      return typography.map((key, value) => MapEntry(key, value.toDouble()));
    }
    return {};
  }

  static Map<String, Color> _parseColors(dynamic colors) {
    if (colors is Map) {
      return colors.map((key, value) => MapEntry(key, _parseColor(value)));
    }
    return {};
  }

  static Color _parseColor(dynamic color) {
    if (color is String) {
      return Color(int.parse(color.replaceFirst('#', '0xFF')));
    }
    return Colors.black;
  }

  static Map<String, TextStyle> _parseTextStyles(dynamic textStyles) {
    if (textStyles is Map) {
      return textStyles.map((key, value) => MapEntry(key, _parseTextStyle(value)));
    }
    return {};
  }

  static TextStyle _parseTextStyle(dynamic style) {
    if (style is Map) {
      return TextStyle(
        fontSize: style['font_size']?.toDouble(),
        fontWeight: _parseFontWeight(style['font_weight']),
        color: _parseColor(style['color']),
      );
    }
    return TextStyle();
  }

  static FontWeight _parseFontWeight(dynamic weight) {
    switch (weight) {
      case 'bold': return FontWeight.bold;
      case 'w500': return FontWeight.w500;
      case 'w600': return FontWeight.w600;
      default: return FontWeight.normal;
    }
  }
}
```

## 2. Common UI Components

### 2.1 Base Component với Style Config

```dart
abstract class BaseComponent extends StatelessWidget {
  final StyleConfig? styleConfig;

  const BaseComponent({Key? key, this.styleConfig}) : super(key: key);

  StyleConfig get config => styleConfig ?? StyleManager.currentConfig;

  double getSpacing(String key) => config.spacing[key] ?? 16.0;
  double getRadius(String key) => config.radius[key] ?? 8.0;
  double getGrid(String key) => config.grid[key] ?? 16.0;
  Color getColor(String key) => config.colors[key] ?? Colors.black;
  TextStyle getTextStyle(String key) => config.textStyles[key] ?? TextStyle();
}

class CommonTextField extends BaseComponent {
  final String? hint;
  final bool isPassword;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? errorText;

  const CommonTextField({
    Key? key,
    this.hint,
    this.isPassword = false,
    this.controller,
    this.onChanged,
    this.errorText,
    StyleConfig? styleConfig,
  }) : super(key: key, styleConfig: styleConfig);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: getSpacing('field_margin')),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        onChanged: onChanged,
        style: getTextStyle('body'),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: getTextStyle('body').copyWith(
            color: getColor('neutral500'),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(getRadius('field')),
            borderSide: BorderSide(color: getColor('neutral300')),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(getRadius('field')),
            borderSide: BorderSide(color: getColor('neutral300')),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(getRadius('field')),
            borderSide: BorderSide(color: getColor('primary')),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(getRadius('field')),
            borderSide: BorderSide(color: getColor('error')),
          ),
          errorText: errorText,
          contentPadding: EdgeInsets.symmetric(
            horizontal: getSpacing('field_padding_horizontal'),
            vertical: getSpacing('field_padding_vertical'),
          ),
        ),
      ),
    );
  }
}

class CommonButton extends BaseComponent {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? variant; // primary, secondary, outline, ghost

  const CommonButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.variant = 'primary',
    StyleConfig? styleConfig,
  }) : super(key: key, styleConfig: styleConfig);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: getSpacing('button_height'),
      margin: EdgeInsets.only(bottom: getSpacing('button_margin')),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(),
        child: isLoading
            ? SizedBox(
                width: getSpacing('loading_size'),
                height: getSpacing('loading_size'),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    getColor('white'),
                  ),
                ),
              )
            : Text(
                text,
                style: getTextStyle('button'),
              ),
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    switch (variant) {
      case 'primary':
        return ElevatedButton.styleFrom(
          backgroundColor: getColor('primary'),
          foregroundColor: getColor('white'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getRadius('button')),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: getSpacing('button_padding_horizontal'),
            vertical: getSpacing('button_padding_vertical'),
          ),
        );
      case 'secondary':
        return ElevatedButton.styleFrom(
          backgroundColor: getColor('secondary'),
          foregroundColor: getColor('white'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getRadius('button')),
          ),
        );
      case 'outline':
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: getColor('primary'),
          side: BorderSide(color: getColor('primary')),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getRadius('button')),
          ),
        );
      case 'ghost':
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: getColor('primary'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getRadius('button')),
          ),
        );
      default:
        return ElevatedButton.styleFrom(
          backgroundColor: getColor('primary'),
          foregroundColor: getColor('white'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getRadius('button')),
          ),
        );
    }
  }
}

class CommonCard extends BaseComponent {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final String? variant; // default, elevated, outlined

  const CommonCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.variant = 'default',
    StyleConfig? styleConfig,
  }) : super(key: key, styleConfig: styleConfig);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(getSpacing('card_margin')),
      padding: padding ?? EdgeInsets.all(getSpacing('card_padding')),
      decoration: _getCardDecoration(),
      child: child,
    );
  }

  BoxDecoration _getCardDecoration() {
    switch (variant) {
      case 'elevated':
        return BoxDecoration(
          color: getColor('white'),
          borderRadius: BorderRadius.circular(getRadius('card')),
          boxShadow: [
            BoxShadow(
              color: getColor('neutral200').withOpacity(0.1),
              blurRadius: getSpacing('shadow_blur'),
              offset: Offset(0, getSpacing('shadow_offset')),
            ),
          ],
        );
      case 'outlined':
        return BoxDecoration(
          color: getColor('white'),
          borderRadius: BorderRadius.circular(getRadius('card')),
          border: Border.all(color: getColor('neutral300')),
        );
      default:
        return BoxDecoration(
          color: getColor('white'),
          borderRadius: BorderRadius.circular(getRadius('card')),
        );
    }
  }
}
```

## 3. Style Manager

### 3.1 Centralized Style Management

```dart
class StyleManager extends ChangeNotifier {
  static StyleManager? _instance;
  static StyleManager get instance => _instance ??= StyleManager._();

  StyleManager._();

  StyleConfig _currentConfig = _getDefaultConfig();
  StyleConfig get currentConfig => _currentConfig;

  static StyleConfig _getDefaultConfig() {
    return StyleConfig(
      spacing: {
        'xs': 4.0,
        's': 8.0,
        'm': 16.0,
        'l': 24.0,
        'xl': 32.0,
        'xxl': 48.0,
        'field_margin': 16.0,
        'field_padding_horizontal': 16.0,
        'field_padding_vertical': 12.0,
        'button_height': 48.0,
        'button_margin': 16.0,
        'button_padding_horizontal': 24.0,
        'button_padding_vertical': 12.0,
        'loading_size': 20.0,
        'card_margin': 16.0,
        'card_padding': 16.0,
        'shadow_blur': 8.0,
        'shadow_offset': 2.0,
      },
      radius: {
        'xs': 4.0,
        's': 8.0,
        'm': 12.0,
        'l': 16.0,
        'xl': 24.0,
        'field': 8.0,
        'button': 8.0,
        'card': 12.0,
      },
      grid: {
        'xs': 4.0,
        's': 8.0,
        'm': 16.0,
        'l': 24.0,
        'xl': 32.0,
      },
      typography: {
        'xs': 12.0,
        's': 14.0,
        'm': 16.0,
        'l': 18.0,
        'xl': 20.0,
        'xxl': 24.0,
      },
      colors: {
        'primary': Color(0xFF007AFF),
        'secondary': Color(0xFF5856D6),
        'success': Color(0xFF34C759),
        'warning': Color(0xFFFF9500),
        'error': Color(0xFFFF3B30),
        'white': Colors.white,
        'black': Colors.black,
        'neutral100': Color(0xFFF2F2F7),
        'neutral200': Color(0xFFE5E5EA),
        'neutral300': Color(0xFFD1D1D6),
        'neutral400': Color(0xFFC7C7CC),
        'neutral500': Color(0xFFAEAEB2),
        'neutral600': Color(0xFF8E8E93),
        'neutral700': Color(0xFF636366),
        'neutral800': Color(0xFF48484A),
        'neutral900': Color(0xFF1C1C1E),
      },
      textStyles: {
        'body': TextStyle(fontSize: 16.0, color: Color(0xFF1C1C1E)),
        'button': TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        'title': TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        'subtitle': TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        'caption': TextStyle(fontSize: 12.0, color: Color(0xFF8E8E93)),
      },
    );
  }

  void updateConfig(StyleConfig newConfig) {
    _currentConfig = newConfig;
    notifyListeners();
  }

  Future<void> loadConfigFromFile(String filePath) async {
    try {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString);
      final config = StyleConfig.fromJson(json);
      updateConfig(config);
    } catch (e) {
      print('Error loading style config: $e');
    }
  }

  Future<void> loadConfigFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final json = jsonDecode(response.body);
      final config = StyleConfig.fromJson(json);
      updateConfig(config);
    } catch (e) {
      print('Error loading style config from URL: $e');
    }
  }
}
```

## 4. Style Configuration Files

### 4.1 Default Style Config (default_style.json)

```json
{
  "spacing": {
    "xs": 4,
    "s": 8,
    "m": 16,
    "l": 24,
    "xl": 32,
    "xxl": 48,
    "field_margin": 16,
    "field_padding_horizontal": 16,
    "field_padding_vertical": 12,
    "button_height": 48,
    "button_margin": 16,
    "button_padding_horizontal": 24,
    "button_padding_vertical": 12,
    "loading_size": 20,
    "card_margin": 16,
    "card_padding": 16,
    "shadow_blur": 8,
    "shadow_offset": 2
  },
  "radius": {
    "xs": 4,
    "s": 8,
    "m": 12,
    "l": 16,
    "xl": 24,
    "field": 8,
    "button": 8,
    "card": 12
  },
  "grid": {
    "xs": 4,
    "s": 8,
    "m": 16,
    "l": 24,
    "xl": 32
  },
  "typography": {
    "xs": 12,
    "s": 14,
    "m": 16,
    "l": 18,
    "xl": 20,
    "xxl": 24
  },
  "colors": {
    "primary": "#007AFF",
    "secondary": "#5856D6",
    "success": "#34C759",
    "warning": "#FF9500",
    "error": "#FF3B30",
    "white": "#FFFFFF",
    "black": "#000000",
    "neutral100": "#F2F2F7",
    "neutral200": "#E5E5EA",
    "neutral300": "#D1D1D6",
    "neutral400": "#C7C7CC",
    "neutral500": "#AEAEB2",
    "neutral600": "#8E8E93",
    "neutral700": "#636366",
    "neutral800": "#48484A",
    "neutral900": "#1C1C1E"
  },
  "text_styles": {
    "body": {
      "font_size": 16,
      "color": "#1C1C1E"
    },
    "button": {
      "font_size": 16,
      "font_weight": "w600"
    },
    "title": {
      "font_size": 24,
      "font_weight": "bold"
    },
    "subtitle": {
      "font_size": 18,
      "font_weight": "w500"
    },
    "caption": {
      "font_size": 12,
      "color": "#8E8E93"
    }
  }
}
```

### 4.2 Modern Style Config (modern_style.json)

```json
{
  "spacing": {
    "xs": 6,
    "s": 12,
    "m": 20,
    "l": 28,
    "xl": 36,
    "xxl": 56,
    "field_margin": 20,
    "field_padding_horizontal": 20,
    "field_padding_vertical": 16,
    "button_height": 56,
    "button_margin": 20,
    "button_padding_horizontal": 32,
    "button_padding_vertical": 16,
    "loading_size": 24,
    "card_margin": 20,
    "card_padding": 24,
    "shadow_blur": 12,
    "shadow_offset": 4
  },
  "radius": {
    "xs": 6,
    "s": 12,
    "m": 16,
    "l": 20,
    "xl": 28,
    "field": 12,
    "button": 12,
    "card": 16
  },
  "grid": {
    "xs": 6,
    "s": 12,
    "m": 20,
    "l": 28,
    "xl": 36
  },
  "typography": {
    "xs": 14,
    "s": 16,
    "m": 18,
    "l": 20,
    "xl": 24,
    "xxl": 28
  },
  "colors": {
    "primary": "#6366F1",
    "secondary": "#8B5CF6",
    "success": "#10B981",
    "warning": "#F59E0B",
    "error": "#EF4444",
    "white": "#FFFFFF",
    "black": "#000000",
    "neutral100": "#F8FAFC",
    "neutral200": "#E2E8F0",
    "neutral300": "#CBD5E1",
    "neutral400": "#94A3B8",
    "neutral500": "#64748B",
    "neutral600": "#475569",
    "neutral700": "#334155",
    "neutral800": "#1E293B",
    "neutral900": "#0F172A"
  },
  "text_styles": {
    "body": {
      "font_size": 18,
      "color": "#0F172A"
    },
    "button": {
      "font_size": 18,
      "font_weight": "w600"
    },
    "title": {
      "font_size": 28,
      "font_weight": "bold"
    },
    "subtitle": {
      "font_size": 20,
      "font_weight": "w500"
    },
    "caption": {
      "font_size": 14,
      "color": "#64748B"
    }
  }
}
```

### 4.3 Minimal Style Config (minimal_style.json)

```json
{
  "spacing": {
    "xs": 2,
    "s": 4,
    "m": 8,
    "l": 16,
    "xl": 24,
    "xxl": 32,
    "field_margin": 8,
    "field_padding_horizontal": 8,
    "field_padding_vertical": 8,
    "button_height": 40,
    "button_margin": 8,
    "button_padding_horizontal": 16,
    "button_padding_vertical": 8,
    "loading_size": 16,
    "card_margin": 8,
    "card_padding": 12,
    "shadow_blur": 4,
    "shadow_offset": 1
  },
  "radius": {
    "xs": 2,
    "s": 4,
    "m": 6,
    "l": 8,
    "xl": 12,
    "field": 4,
    "button": 4,
    "card": 6
  },
  "grid": {
    "xs": 2,
    "s": 4,
    "m": 8,
    "l": 16,
    "xl": 24
  },
  "typography": {
    "xs": 10,
    "s": 12,
    "m": 14,
    "l": 16,
    "xl": 18,
    "xxl": 20
  },
  "colors": {
    "primary": "#000000",
    "secondary": "#666666",
    "success": "#00AA00",
    "warning": "#AA6600",
    "error": "#AA0000",
    "white": "#FFFFFF",
    "black": "#000000",
    "neutral100": "#FFFFFF",
    "neutral200": "#F5F5F5",
    "neutral300": "#E5E5E5",
    "neutral400": "#CCCCCC",
    "neutral500": "#999999",
    "neutral600": "#666666",
    "neutral700": "#333333",
    "neutral800": "#222222",
    "neutral900": "#000000"
  },
  "text_styles": {
    "body": {
      "font_size": 14,
      "color": "#000000"
    },
    "button": {
      "font_size": 14,
      "font_weight": "w500"
    },
    "title": {
      "font_size": 20,
      "font_weight": "bold"
    },
    "subtitle": {
      "font_size": 16,
      "font_weight": "w500"
    },
    "caption": {
      "font_size": 12,
      "color": "#666666"
    }
  }
}
```

## 5. Usage Examples

### 5.1 Basic Usage

```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(StyleManager.instance.currentConfig.spacing['l']!),
        child: Column(
          children: [
            CommonTextField(
              hint: 'Email',
              styleConfig: StyleManager.instance.currentConfig,
            ),
            CommonTextField(
              hint: 'Password',
              isPassword: true,
              styleConfig: StyleManager.instance.currentConfig,
            ),
            CommonButton(
              text: 'Login',
              onPressed: () => _handleLogin(),
              styleConfig: StyleManager.instance.currentConfig,
            ),
          ],
        ),
      ),
    );
  }
}
```

### 5.2 Style Switching

```dart
class StyleSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _loadDefaultStyle(),
          child: Text('Default Style'),
        ),
        ElevatedButton(
          onPressed: () => _loadModernStyle(),
          child: Text('Modern Style'),
        ),
        ElevatedButton(
          onPressed: () => _loadMinimalStyle(),
          child: Text('Minimal Style'),
        ),
      ],
    );
  }

  void _loadDefaultStyle() async {
    await StyleManager.instance.loadConfigFromFile('assets/styles/default_style.json');
  }

  void _loadModernStyle() async {
    await StyleManager.instance.loadConfigFromFile('assets/styles/modern_style.json');
  }

  void _loadMinimalStyle() async {
    await StyleManager.instance.loadConfigFromFile('assets/styles/minimal_style.json');
  }
}
```

### 5.3 Responsive Style

```dart
class ResponsiveStyleManager {
  static void loadStyleForScreenSize(Size screenSize) {
    if (screenSize.width < 600) {
      // Mobile style
      StyleManager.instance.loadConfigFromFile('assets/styles/mobile_style.json');
    } else if (screenSize.width < 1200) {
      // Tablet style
      StyleManager.instance.loadConfigFromFile('assets/styles/tablet_style.json');
    } else {
      // Desktop style
      StyleManager.instance.loadConfigFromFile('assets/styles/desktop_style.json');
    }
  }
}
```

## 6. Advanced Features

### 6.1 Theme-Aware Components

```dart
class ThemeAwareComponent extends BaseComponent {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final styleConfig = isDark ? _getDarkConfig() : _getLightConfig();

    return CommonCard(
      styleConfig: styleConfig,
      child: Text('Theme Aware Component'),
    );
  }

  StyleConfig _getDarkConfig() {
    // Return dark theme config
    return StyleConfig.fromJson({
      'colors': {
        'primary': '#6366F1',
        'background': '#1F2937',
        'text': '#F9FAFB',
      },
      // ... other config
    });
  }

  StyleConfig _getLightConfig() {
    // Return light theme config
    return StyleConfig.fromJson({
      'colors': {
        'primary': '#007AFF',
        'background': '#FFFFFF',
        'text': '#1F2937',
      },
      // ... other config
    });
  }
}
```

### 6.2 Animation Style Transitions

```dart
class AnimatedStyleTransition extends StatefulWidget {
  final Widget child;
  final StyleConfig fromConfig;
  final StyleConfig toConfig;
  final Duration duration;

  const AnimatedStyleTransition({
    Key? key,
    required this.child,
    required this.fromConfig,
    required this.toConfig,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  _AnimatedStyleTransitionState createState() => _AnimatedStyleTransitionState();
}

class _AnimatedStyleTransitionState extends State<AnimatedStyleTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final interpolatedConfig = _interpolateConfig(
          widget.fromConfig,
          widget.toConfig,
          _animation.value,
        );

        return widget.child;
      },
    );
  }

  StyleConfig _interpolateConfig(StyleConfig from, StyleConfig to, double t) {
    // Interpolate between configs
    return StyleConfig(
      spacing: _interpolateMap(from.spacing, to.spacing, t),
      radius: _interpolateMap(from.radius, to.radius, t),
      colors: _interpolateColors(from.colors, to.colors, t),
      // ... other properties
    );
  }

  Map<String, double> _interpolateMap(
    Map<String, double> from,
    Map<String, double> to,
    double t,
  ) {
    final result = <String, double>{};
    for (final key in from.keys) {
      if (to.containsKey(key)) {
        result[key] = from[key]! + (to[key]! - from[key]!) * t;
      }
    }
    return result;
  }

  Map<String, Color> _interpolateColors(
    Map<String, Color> from,
    Map<String, Color> to,
    double t,
  ) {
    final result = <String, Color>{};
    for (final key in from.keys) {
      if (to.containsKey(key)) {
        result[key] = Color.lerp(from[key]!, to[key]!, t)!;
      }
    }
    return result;
  }
}
```

## 7. Benefits

### 7.1 Development Benefits

- **Consistent Design**: Tất cả components sử dụng cùng design system
- **Easy Maintenance**: Chỉ cần thay đổi config file
- **Rapid Prototyping**: Dễ dàng thử nghiệm các style khác nhau
- **Team Collaboration**: Designers và developers có thể làm việc độc lập

### 7.2 User Experience Benefits

- **Consistent UI**: Giao diện nhất quán across app
- **Theme Support**: Hỗ trợ dark/light mode
- **Responsive Design**: Tự động adapt theo screen size
- **Smooth Transitions**: Animation khi chuyển đổi style

### 7.3 Business Benefits

- **Faster Development**: Giảm thời gian phát triển
- **Easy Branding**: Dễ dàng thay đổi brand colors
- **A/B Testing**: Dễ dàng test các style khác nhau
- **Cost Effective**: Giảm chi phí maintenance

## 8. Implementation Strategy

### 8.1 Phase 1: Foundation

1. Tạo base components với style config
2. Implement StyleManager
3. Tạo default style config
4. Test basic functionality

### 8.2 Phase 2: Enhancement

1. Thêm theme support
2. Implement responsive styles
3. Add animation transitions
4. Create style presets

### 8.3 Phase 3: Advanced Features

1. Remote style loading
2. A/B testing integration
3. Analytics tracking
4. Performance optimization

## Conclusion

Design system với style configuration cung cấp:

1. **Flexibility**: Dễ dàng thay đổi design mà không cần sửa code
2. **Consistency**: Tất cả components follow cùng design system
3. **Maintainability**: Centralized style management
4. **Scalability**: Dễ dàng mở rộng và thêm components mới
5. **Performance**: Optimized rendering với style caching

Đây là approach rất hiệu quả cho việc xây dựng flexible UI system trong Flutter!
