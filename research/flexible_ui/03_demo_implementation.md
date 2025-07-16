# Demo Implementation: Flexible UI Login/Register Screens

## Overview

This document provides a complete demo implementation of flexible UI systems for login and register screens, demonstrating how to create configurable UI that can be changed through external configuration files.

## 1. Project Structure

```
lib/
├── main.dart
├── config/
│   ├── ui_config.dart
│   ├── login_config.json
│   ├── register_config.json
│   └── themes/
│       ├── default_theme.json
│       ├── dark_theme.json
│       └── custom_theme.json
├── components/
│   ├── base/
│   │   ├── flexible_widget.dart
│   │   └── component_registry.dart
│   ├── ui/
│   │   ├── custom_text_field.dart
│   │   ├── custom_button.dart
│   │   ├── custom_container.dart
│   │   └── custom_text.dart
│   └── layouts/
│       ├── responsive_layout.dart
│       └── flexible_layout.dart
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   └── base_screen.dart
└── utils/
    ├── config_loader.dart
    ├── theme_manager.dart
    └── property_parser.dart
```

## 2. Configuration Files

### 2.1 Login Screen Configuration (login_config.json)

```json
{
  "screen_type": "login",
  "theme": "default",
  "layout": {
    "type": "column",
    "mainAxisAlignment": "center",
    "crossAxisAlignment": "stretch",
    "padding": { "left": 24, "right": 24, "top": 40, "bottom": 40 }
  },
  "background": {
    "type": "gradient",
    "colors": ["#667eea", "#764ba2"],
    "direction": "top_to_bottom"
  },
  "components": [
    {
      "type": "container",
      "properties": {
        "margin": { "bottom": 32 },
        "alignment": "center",
        "child": {
          "type": "text",
          "properties": {
            "text": "Welcome Back",
            "style": {
              "fontSize": 28,
              "fontWeight": "bold",
              "color": "#FFFFFF"
            }
          }
        }
      }
    },
    {
      "type": "text_field",
      "properties": {
        "hint": "Email",
        "icon": { "type": "Icons", "name": "email", "color": "#666666" },
        "border_radius": 12,
        "margin": { "bottom": 16 },
        "background_color": "#FFFFFF",
        "border_color": "#E0E0E0",
        "text_style": {
          "fontSize": 16,
          "color": "#333333"
        },
        "hint_style": {
          "fontSize": 16,
          "color": "#999999"
        }
      }
    },
    {
      "type": "text_field",
      "properties": {
        "hint": "Password",
        "is_password": true,
        "icon": { "type": "Icons", "name": "lock", "color": "#666666" },
        "border_radius": 12,
        "margin": { "bottom": 24 },
        "background_color": "#FFFFFF",
        "border_color": "#E0E0E0",
        "text_style": {
          "fontSize": 16,
          "color": "#333333"
        },
        "hint_style": {
          "fontSize": 16,
          "color": "#999999"
        }
      }
    },
    {
      "type": "button",
      "properties": {
        "text": "Login",
        "background_color": "#007AFF",
        "text_color": "#FFFFFF",
        "border_radius": 12,
        "height": 50,
        "text_style": {
          "fontSize": 16,
          "fontWeight": "w600"
        },
        "margin": { "bottom": 16 }
      }
    },
    {
      "type": "container",
      "properties": {
        "alignment": "center",
        "child": {
          "type": "text",
          "properties": {
            "text": "Don't have an account? ",
            "style": {
              "fontSize": 14,
              "color": "#FFFFFF"
            }
          }
        }
      }
    },
    {
      "type": "button",
      "properties": {
        "text": "Sign Up",
        "background_color": "transparent",
        "text_color": "#FFFFFF",
        "border_color": "#FFFFFF",
        "border_width": 1,
        "border_radius": 12,
        "height": 50,
        "text_style": {
          "fontSize": 16,
          "fontWeight": "w600"
        }
      }
    }
  ]
}
```

### 2.2 Register Screen Configuration (register_config.json)

```json
{
  "screen_type": "register",
  "theme": "default",
  "layout": {
    "type": "column",
    "mainAxisAlignment": "center",
    "crossAxisAlignment": "stretch",
    "padding": { "left": 24, "right": 24, "top": 40, "bottom": 40 }
  },
  "background": {
    "type": "gradient",
    "colors": ["#667eea", "#764ba2"],
    "direction": "top_to_bottom"
  },
  "components": [
    {
      "type": "container",
      "properties": {
        "margin": { "bottom": 32 },
        "alignment": "center",
        "child": {
          "type": "text",
          "properties": {
            "text": "Create Account",
            "style": {
              "fontSize": 28,
              "fontWeight": "bold",
              "color": "#FFFFFF"
            }
          }
        }
      }
    },
    {
      "type": "text_field",
      "properties": {
        "hint": "Full Name",
        "icon": { "type": "Icons", "name": "person", "color": "#666666" },
        "border_radius": 12,
        "margin": { "bottom": 16 },
        "background_color": "#FFFFFF",
        "border_color": "#E0E0E0",
        "text_style": {
          "fontSize": 16,
          "color": "#333333"
        },
        "hint_style": {
          "fontSize": 16,
          "color": "#999999"
        }
      }
    },
    {
      "type": "text_field",
      "properties": {
        "hint": "Email",
        "icon": { "type": "Icons", "name": "email", "color": "#666666" },
        "border_radius": 12,
        "margin": { "bottom": 16 },
        "background_color": "#FFFFFF",
        "border_color": "#E0E0E0",
        "text_style": {
          "fontSize": 16,
          "color": "#333333"
        },
        "hint_style": {
          "fontSize": 16,
          "color": "#999999"
        }
      }
    },
    {
      "type": "text_field",
      "properties": {
        "hint": "Password",
        "is_password": true,
        "icon": { "type": "Icons", "name": "lock", "color": "#666666" },
        "border_radius": 12,
        "margin": { "bottom": 16 },
        "background_color": "#FFFFFF",
        "border_color": "#E0E0E0",
        "text_style": {
          "fontSize": 16,
          "color": "#333333"
        },
        "hint_style": {
          "fontSize": 16,
          "color": "#999999"
        }
      }
    },
    {
      "type": "text_field",
      "properties": {
        "hint": "Confirm Password",
        "is_password": true,
        "icon": { "type": "Icons", "name": "lock", "color": "#666666" },
        "border_radius": 12,
        "margin": { "bottom": 24 },
        "background_color": "#FFFFFF",
        "border_color": "#E0E0E0",
        "text_style": {
          "fontSize": 16,
          "color": "#333333"
        },
        "hint_style": {
          "fontSize": 16,
          "color": "#999999"
        }
      }
    },
    {
      "type": "button",
      "properties": {
        "text": "Create Account",
        "background_color": "#007AFF",
        "text_color": "#FFFFFF",
        "border_radius": 12,
        "height": 50,
        "text_style": {
          "fontSize": 16,
          "fontWeight": "w600"
        },
        "margin": { "bottom": 16 }
      }
    },
    {
      "type": "container",
      "properties": {
        "alignment": "center",
        "child": {
          "type": "text",
          "properties": {
            "text": "Already have an account? ",
            "style": {
              "fontSize": 14,
              "color": "#FFFFFF"
            }
          }
        }
      }
    },
    {
      "type": "button",
      "properties": {
        "text": "Sign In",
        "background_color": "transparent",
        "text_color": "#FFFFFF",
        "border_color": "#FFFFFF",
        "border_width": 1,
        "border_radius": 12,
        "height": 50,
        "text_style": {
          "fontSize": 16,
          "fontWeight": "w600"
        }
      }
    }
  ]
}
```

## 3. Core Implementation

### 3.1 Component Registry (component_registry.dart)

```dart
import 'package:flutter/material.dart';
import '../ui/custom_text_field.dart';
import '../ui/custom_button.dart';
import '../ui/custom_container.dart';
import '../ui/custom_text.dart';

class ComponentRegistry {
  static final Map<String, WidgetBuilder> _components = {};

  static void initialize() {
    // Register text field component
    register('text_field', (properties) {
      return CustomTextField.fromConfig(properties);
    });

    // Register button component
    register('button', (properties) {
      return CustomButton.fromConfig(properties);
    });

    // Register container component
    register('container', (properties) {
      return CustomContainer.fromConfig(properties);
    });

    // Register text component
    register('text', (properties) {
      return CustomText.fromConfig(properties);
    });
  }

  static void register(String name, WidgetBuilder builder) {
    _components[name] = builder;
  }

  static Widget build(String name, Map<String, dynamic> properties) {
    final builder = _components[name];
    if (builder != null) {
      return builder(properties);
    }
    return Container();
  }

  static List<String> getAvailableComponents() {
    return _components.keys.toList();
  }
}
```

### 3.2 Configuration Loader (config_loader.dart)

```dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

class ConfigLoader {
  static Future<Map<String, dynamic>> loadConfig(String configName) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/config/$configName.json');
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Error loading config: $e');
      return {};
    }
  }

  static Future<void> watchConfig(String configName, Function(Map<String, dynamic>) callback) async {
    // For development, you can implement file watching here
    // For production, you might want to implement polling or websocket
    Timer.periodic(Duration(seconds: 5), (timer) async {
      final config = await loadConfig(configName);
      callback(config);
    });
  }
}
```

### 3.3 Property Parser (property_parser.dart)

```dart
import 'package:flutter/material.dart';

class PropertyParser {
  static EdgeInsets parseEdgeInsets(dynamic edgeInsets) {
    if (edgeInsets is Map) {
      return EdgeInsets.only(
        top: edgeInsets['top']?.toDouble() ?? 0,
        bottom: edgeInsets['bottom']?.toDouble() ?? 0,
        left: edgeInsets['left']?.toDouble() ?? 0,
        right: edgeInsets['right']?.toDouble() ?? 0,
      );
    }
    return EdgeInsets.zero;
  }

  static Color? parseColor(dynamic color) {
    if (color is String) {
      if (color == 'transparent') {
        return Colors.transparent;
      }
      return Color(int.parse(color.replaceFirst('#', '0xFF')));
    }
    return null;
  }

  static TextStyle? parseTextStyle(dynamic style) {
    if (style is Map) {
      return TextStyle(
        fontSize: style['fontSize']?.toDouble(),
        fontWeight: parseFontWeight(style['fontWeight']),
        color: parseColor(style['color']),
        decoration: parseTextDecoration(style['decoration']),
      );
    }
    return null;
  }

  static FontWeight parseFontWeight(dynamic weight) {
    switch (weight) {
      case 'bold': return FontWeight.bold;
      case 'w500': return FontWeight.w500;
      case 'w600': return FontWeight.w600;
      case 'w700': return FontWeight.w700;
      default: return FontWeight.normal;
    }
  }

  static TextDecoration? parseTextDecoration(dynamic decoration) {
    switch (decoration) {
      case 'underline': return TextDecoration.underline;
      case 'lineThrough': return TextDecoration.lineThrough;
      default: return null;
    }
  }

  static MainAxisAlignment parseMainAxisAlignment(dynamic alignment) {
    switch (alignment) {
      case 'start': return MainAxisAlignment.start;
      case 'end': return MainAxisAlignment.end;
      case 'center': return MainAxisAlignment.center;
      case 'spaceBetween': return MainAxisAlignment.spaceBetween;
      case 'spaceAround': return MainAxisAlignment.spaceAround;
      case 'spaceEvenly': return MainAxisAlignment.spaceEvenly;
      default: return MainAxisAlignment.start;
    }
  }

  static CrossAxisAlignment parseCrossAxisAlignment(dynamic alignment) {
    switch (alignment) {
      case 'start': return CrossAxisAlignment.start;
      case 'end': return CrossAxisAlignment.end;
      case 'center': return CrossAxisAlignment.center;
      case 'stretch': return CrossAxisAlignment.stretch;
      case 'baseline': return CrossAxisAlignment.baseline;
      default: return CrossAxisAlignment.center;
    }
  }
}
```

### 3.4 Base Screen (base_screen.dart)

```dart
import 'package:flutter/material.dart';
import '../utils/config_loader.dart';
import '../components/base/component_registry.dart';

class BaseScreen extends StatefulWidget {
  final String configName;

  const BaseScreen({Key? key, required this.configName}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  Map<String, dynamic> _config = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await ConfigLoader.loadConfig(widget.configName);
    setState(() {
      _config = config;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return _buildScreen();
  }

  Widget _buildScreen() {
    final layout = _config['layout'] ?? {};
    final background = _config['background'];
    final components = _config['components'] ?? [];

    Widget screenContent = Column(
      mainAxisAlignment: PropertyParser.parseMainAxisAlignment(layout['mainAxisAlignment']),
      crossAxisAlignment: PropertyParser.parseCrossAxisAlignment(layout['crossAxisAlignment']),
      children: components.map<Widget>((component) {
        return ComponentRegistry.build(
          component['type'],
          component['properties'] ?? {},
        );
      }).toList(),
    );

    if (layout['padding'] != null) {
      screenContent = Padding(
        padding: PropertyParser.parseEdgeInsets(layout['padding']),
        child: screenContent,
      );
    }

    if (background != null) {
      screenContent = _buildBackground(background, screenContent);
    }

    return Scaffold(
      body: screenContent,
    );
  }

  Widget _buildBackground(Map<String, dynamic> background, Widget child) {
    switch (background['type']) {
      case 'gradient':
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: (background['colors'] as List)
                  .map((color) => PropertyParser.parseColor(color))
                  .where((color) => color != null)
                  .cast<Color>()
                  .toList(),
              begin: _parseGradientDirection(background['direction']),
              end: _parseGradientDirectionEnd(background['direction']),
            ),
          ),
          child: child,
        );
      case 'color':
        return Container(
          color: PropertyParser.parseColor(background['color']),
          child: child,
        );
      default:
        return child;
    }
  }

  Alignment _parseGradientDirection(String? direction) {
    switch (direction) {
      case 'top_to_bottom': return Alignment.topCenter;
      case 'bottom_to_top': return Alignment.bottomCenter;
      case 'left_to_right': return Alignment.centerLeft;
      case 'right_to_left': return Alignment.centerRight;
      default: return Alignment.topCenter;
    }
  }

  Alignment _parseGradientDirectionEnd(String? direction) {
    switch (direction) {
      case 'top_to_bottom': return Alignment.bottomCenter;
      case 'bottom_to_top': return Alignment.topCenter;
      case 'left_to_right': return Alignment.centerRight;
      case 'right_to_left': return Alignment.centerLeft;
      default: return Alignment.bottomCenter;
    }
  }
}
```

## 4. UI Components Implementation

### 4.1 Custom Text Field (custom_text_field.dart)

```dart
import 'package:flutter/material.dart';
import '../../utils/property_parser.dart';

class CustomTextField extends StatefulWidget {
  final String? hint;
  final bool isPassword;
  final double borderRadius;
  final EdgeInsets margin;
  final Color? borderColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Map<String, dynamic>? icon;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    this.hint,
    this.isPassword = false,
    this.borderRadius = 8.0,
    this.margin = EdgeInsets.zero,
    this.borderColor,
    this.backgroundColor,
    this.textStyle,
    this.hintStyle,
    this.icon,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();

  static Widget fromConfig(Map<String, dynamic> properties) {
    return CustomTextField(
      hint: properties['hint'],
      isPassword: properties['is_password'] ?? false,
      borderRadius: properties['border_radius']?.toDouble() ?? 8.0,
      margin: PropertyParser.parseEdgeInsets(properties['margin']),
      borderColor: PropertyParser.parseColor(properties['border_color']),
      backgroundColor: PropertyParser.parseColor(properties['background_color']),
      textStyle: PropertyParser.parseTextStyle(properties['text_style']),
      hintStyle: PropertyParser.parseTextStyle(properties['hint_style']),
      icon: properties['icon'],
    );
  }
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: widget.borderColor != null
          ? Border.all(color: widget.borderColor!)
          : null,
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword && !_obscureText,
        style: widget.textStyle,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: widget.hintStyle,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: _buildIcon(),
          suffixIcon: widget.isPassword ? _buildPasswordToggle() : null,
        ),
      ),
    );
  }

  Widget? _buildIcon() {
    if (widget.icon != null) {
      return Icon(
        _parseIconData(widget.icon!['name']),
        size: widget.icon!['size']?.toDouble(),
        color: PropertyParser.parseColor(widget.icon!['color']),
      );
    }
    return null;
  }

  Widget? _buildPasswordToggle() {
    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility : Icons.visibility_off,
        color: Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }

  IconData _parseIconData(String name) {
    switch (name) {
      case 'email': return Icons.email;
      case 'lock': return Icons.lock;
      case 'person': return Icons.person;
      case 'visibility': return Icons.visibility;
      case 'visibility_off': return Icons.visibility_off;
      default: return Icons.star;
    }
  }
}
```

### 4.2 Custom Button (custom_button.dart)

```dart
import 'package:flutter/material.dart';
import '../../utils/property_parser.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsets margin;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Map<String, dynamic>? icon;
  final Color? borderColor;
  final double? borderWidth;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 8.0,
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.textStyle,
    this.icon,
    this.borderColor,
    this.borderWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
              ? BorderSide(color: borderColor!, width: borderWidth ?? 1.0)
              : BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              _buildIcon(),
              SizedBox(width: 8),
            ],
            Text(
              text,
              style: textStyle?.copyWith(
                color: textColor,
              ) ?? TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Icon(
      _parseIconData(icon!['name']),
      size: icon!['size']?.toDouble(),
      color: PropertyParser.parseColor(icon!['color']),
    );
  }

  IconData _parseIconData(String name) {
    switch (name) {
      case 'email': return Icons.email;
      case 'lock': return Icons.lock;
      case 'person': return Icons.person;
      default: return Icons.star;
    }
  }

  static Widget fromConfig(Map<String, dynamic> properties) {
    return CustomButton(
      text: properties['text'] ?? '',
      backgroundColor: PropertyParser.parseColor(properties['background_color']),
      textColor: PropertyParser.parseColor(properties['text_color']),
      borderRadius: properties['border_radius']?.toDouble() ?? 8.0,
      margin: PropertyParser.parseEdgeInsets(properties['margin']),
      width: properties['width']?.toDouble(),
      height: properties['height']?.toDouble(),
      textStyle: PropertyParser.parseTextStyle(properties['text_style']),
      icon: properties['icon'],
      borderColor: PropertyParser.parseColor(properties['border_color']),
      borderWidth: properties['border_width']?.toDouble(),
    );
  }
}
```

## 5. Screen Implementation

### 5.1 Login Screen (login_screen.dart)

```dart
import 'package:flutter/material.dart';
import 'base_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(configName: 'login_config');
  }
}
```

### 5.2 Register Screen (register_screen.dart)

```dart
import 'package:flutter/material.dart';
import 'base_screen.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(configName: 'register_config');
  }
}
```

## 6. Main App (main.dart)

```dart
import 'package:flutter/material.dart';
import 'components/base/component_registry.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() {
  ComponentRegistry.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flexible UI Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flexible UI Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Login Screen'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Register Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 7. Alternative Configurations

### 7.1 Dark Theme Login (login_dark_config.json)

```json
{
  "screen_type": "login",
  "theme": "dark",
  "layout": {
    "type": "column",
    "mainAxisAlignment": "center",
    "crossAxisAlignment": "stretch",
    "padding": { "left": 24, "right": 24, "top": 40, "bottom": 40 }
  },
  "background": {
    "type": "gradient",
    "colors": ["#1a1a1a", "#2d2d2d"],
    "direction": "top_to_bottom"
  },
  "components": [
    {
      "type": "container",
      "properties": {
        "margin": { "bottom": 32 },
        "alignment": "center",
        "child": {
          "type": "text",
          "properties": {
            "text": "Welcome Back",
            "style": {
              "fontSize": 28,
              "fontWeight": "bold",
              "color": "#FFFFFF"
            }
          }
        }
      }
    },
    {
      "type": "text_field",
      "properties": {
        "hint": "Email",
        "icon": { "type": "Icons", "name": "email", "color": "#FFFFFF" },
        "border_radius": 12,
        "margin": { "bottom": 16 },
        "background_color": "#333333",
        "border_color": "#555555",
        "text_style": {
          "fontSize": 16,
          "color": "#FFFFFF"
        },
        "hint_style": {
          "fontSize": 16,
          "color": "#AAAAAA"
        }
      }
    },
    {
      "type": "text_field",
      "properties": {
        "hint": "Password",
        "is_password": true,
        "icon": { "type": "Icons", "name": "lock", "color": "#FFFFFF" },
        "border_radius": 12,
        "margin": { "bottom": 24 },
        "background_color": "#333333",
        "border_color": "#555555",
        "text_style": {
          "fontSize": 16,
          "color": "#FFFFFF"
        },
        "hint_style": {
          "fontSize": 16,
          "color": "#AAAAAA"
        }
      }
    },
    {
      "type": "button",
      "properties": {
        "text": "Login",
        "background_color": "#007AFF",
        "text_color": "#FFFFFF",
        "border_radius": 12,
        "height": 50,
        "text_style": {
          "fontSize": 16,
          "fontWeight": "w600"
        },
        "margin": { "bottom": 16 }
      }
    }
  ]
}
```

## 8. Usage Examples

### 8.1 Switching Themes

```dart
// To switch to dark theme, just change the config file name
class LoginScreenDark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(configName: 'login_dark_config');
  }
}
```

### 8.2 Hot Reload Configuration

```dart
// In development, you can watch for config changes
class ConfigWatcher {
  static void watchConfig(String configName, Function(Map<String, dynamic>) callback) {
    Timer.periodic(Duration(seconds: 2), (timer) async {
      final config = await ConfigLoader.loadConfig(configName);
      callback(config);
    });
  }
}
```

## 9. Benefits of This Approach

1. **Flexibility**: UI can be completely changed by modifying JSON files
2. **Reusability**: Components can be used across different screens
3. **Maintainability**: Centralized configuration management
4. **Performance**: Efficient component rendering and caching
5. **Development Speed**: Rapid UI prototyping and iteration
6. **A/B Testing**: Easy to test different UI variations
7. **Remote Configuration**: UI can be updated without app updates

## 10. Next Steps

1. **Add more components**: Image, List, Grid, etc.
2. **Implement animations**: Transition effects between screens
3. **Add validation**: Form validation through configuration
4. **Remote configuration**: Load configs from remote servers
5. **Analytics integration**: Track UI interactions
6. **Performance optimization**: Implement component caching
7. **Testing framework**: Automated UI testing based on configs

This demo implementation provides a solid foundation for building flexible UI systems in Flutter that can be easily customized and maintained through external configuration files.
