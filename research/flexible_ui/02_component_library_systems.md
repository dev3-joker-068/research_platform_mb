# Component Library Systems for Flexible Flutter UI

## Overview

This document explores component library systems that enable building flexible, reusable UI components in Flutter. These systems allow for rapid UI development and easy customization through configuration.

## 1. Component Registry Pattern

### 1.1 Basic Component Registry

**Concept**: Central registry for all UI components with dynamic instantiation

```dart
abstract class UIComponent {
  Widget build(Map<String, dynamic> properties);
}

class ComponentRegistry {
  static final Map<String, UIComponent> _components = {};

  static void register(String name, UIComponent component) {
    _components[name] = component;
  }

  static Widget build(String name, Map<String, dynamic> properties) {
    final component = _components[name];
    if (component != null) {
      return component.build(properties);
    }
    return Container();
  }

  static List<String> getAvailableComponents() {
    return _components.keys.toList();
  }
}
```

### 1.2 Advanced Component Registry with Validation

```dart
class ComponentRegistry {
  static final Map<String, ComponentDefinition> _components = {};

  static void register(String name, ComponentDefinition definition) {
    _components[name] = definition;
  }

  static Widget build(String name, Map<String, dynamic> properties) {
    final definition = _components[name];
    if (definition != null) {
      final validatedProperties = definition.validate(properties);
      return definition.builder(validatedProperties);
    }
    return Container();
  }
}

class ComponentDefinition {
  final WidgetBuilder builder;
  final Map<String, PropertyDefinition> schema;

  ComponentDefinition({
    required this.builder,
    required this.schema,
  });

  Map<String, dynamic> validate(Map<String, dynamic> properties) {
    final validated = <String, dynamic>{};

    for (final entry in schema.entries) {
      final key = entry.key;
      final definition = entry.value;

      if (properties.containsKey(key)) {
        validated[key] = definition.validate(properties[key]);
      } else if (definition.required) {
        throw ArgumentError('Required property $key is missing');
      } else {
        validated[key] = definition.defaultValue;
      }
    }

    return validated;
  }
}
```

## 2. Reusable UI Components

### 2.1 Text Field Component

```dart
class CustomTextField extends StatelessWidget {
  final String? hint;
  final bool isPassword;
  final double borderRadius;
  final EdgeInsets margin;
  final Color? borderColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
          ? Border.all(color: borderColor!)
          : null,
      ),
      child: TextField(
        obscureText: isPassword,
        style: textStyle,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: hintStyle,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  // Factory method for dynamic creation
  static Widget fromConfig(Map<String, dynamic> properties) {
    return CustomTextField(
      hint: properties['hint'],
      isPassword: properties['is_password'] ?? false,
      borderRadius: properties['border_radius']?.toDouble() ?? 8.0,
      margin: _parseMargin(properties['margin']),
      borderColor: _parseColor(properties['border_color']),
      backgroundColor: _parseColor(properties['background_color']),
      textStyle: _parseTextStyle(properties['text_style']),
      hintStyle: _parseTextStyle(properties['hint_style']),
    );
  }

  static EdgeInsets _parseMargin(dynamic margin) {
    if (margin is Map) {
      return EdgeInsets.only(
        top: margin['top']?.toDouble() ?? 0,
        bottom: margin['bottom']?.toDouble() ?? 0,
        left: margin['left']?.toDouble() ?? 0,
        right: margin['right']?.toDouble() ?? 0,
      );
    }
    return EdgeInsets.zero;
  }

  static Color? _parseColor(dynamic color) {
    if (color is String) {
      return Color(int.parse(color.replaceFirst('#', '0xFF')));
    }
    return null;
  }

  static TextStyle? _parseTextStyle(dynamic style) {
    if (style is Map) {
      return TextStyle(
        fontSize: style['font_size']?.toDouble(),
        fontWeight: _parseFontWeight(style['font_weight']),
        color: _parseColor(style['color']),
      );
    }
    return null;
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

### 2.2 Button Component

```dart
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
  final Widget? icon;

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
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
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

  static Widget fromConfig(Map<String, dynamic> properties) {
    return CustomButton(
      text: properties['text'] ?? '',
      backgroundColor: _parseColor(properties['background_color']),
      textColor: _parseColor(properties['text_color']),
      borderRadius: properties['border_radius']?.toDouble() ?? 8.0,
      margin: _parseMargin(properties['margin']),
      width: properties['width']?.toDouble(),
      height: properties['height']?.toDouble(),
      textStyle: _parseTextStyle(properties['text_style']),
      icon: _parseIcon(properties['icon']),
    );
  }

  static Widget? _parseIcon(dynamic icon) {
    if (icon is Map) {
      switch (icon['type']) {
        case 'Icons':
          return Icon(
            _parseIconData(icon['name']),
            size: icon['size']?.toDouble(),
            color: _parseColor(icon['color']),
          );
        case 'Image':
          return Image.asset(
            icon['path'],
            width: icon['width']?.toDouble(),
            height: icon['height']?.toDouble(),
          );
      }
    }
    return null;
  }

  static IconData _parseIconData(String name) {
    switch (name) {
      case 'email': return Icons.email;
      case 'lock': return Icons.lock;
      case 'visibility': return Icons.visibility;
      case 'visibility_off': return Icons.visibility_off;
      default: return Icons.star;
    }
  }
}
```

## 3. Layout Components

### 3.1 Flexible Container

```dart
class FlexibleContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final Alignment? alignment;
  final double? width;
  final double? height;

  const FlexibleContainer({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.alignment,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius != null
          ? BorderRadius.circular(borderRadius!)
          : null,
        border: border,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }

  static Widget fromConfig(Map<String, dynamic> properties, Widget child) {
    return FlexibleContainer(
      child: child,
      padding: _parseEdgeInsets(properties['padding']),
      margin: _parseEdgeInsets(properties['margin']),
      backgroundColor: _parseColor(properties['background_color']),
      borderRadius: properties['border_radius']?.toDouble(),
      border: _parseBorder(properties['border']),
      boxShadow: _parseBoxShadow(properties['box_shadow']),
      alignment: _parseAlignment(properties['alignment']),
      width: properties['width']?.toDouble(),
      height: properties['height']?.toDouble(),
    );
  }

  static EdgeInsets? _parseEdgeInsets(dynamic edgeInsets) {
    if (edgeInsets is Map) {
      return EdgeInsets.only(
        top: edgeInsets['top']?.toDouble() ?? 0,
        bottom: edgeInsets['bottom']?.toDouble() ?? 0,
        left: edgeInsets['left']?.toDouble() ?? 0,
        right: edgeInsets['right']?.toDouble() ?? 0,
      );
    }
    return null;
  }

  static BoxBorder? _parseBorder(dynamic border) {
    if (border is Map) {
      return Border.all(
        color: _parseColor(border['color']) ?? Colors.black,
        width: border['width']?.toDouble() ?? 1.0,
      );
    }
    return null;
  }

  static List<BoxShadow>? _parseBoxShadow(dynamic shadow) {
    if (shadow is Map) {
      return [
        BoxShadow(
          color: _parseColor(shadow['color']) ?? Colors.black26,
          offset: Offset(
            shadow['offset_x']?.toDouble() ?? 0,
            shadow['offset_y']?.toDouble() ?? 2,
          ),
          blurRadius: shadow['blur_radius']?.toDouble() ?? 4,
        ),
      ];
    }
    return null;
  }

  static Alignment? _parseAlignment(dynamic alignment) {
    if (alignment is String) {
      switch (alignment) {
        case 'center': return Alignment.center;
        case 'topLeft': return Alignment.topLeft;
        case 'topRight': return Alignment.topRight;
        case 'bottomLeft': return Alignment.bottomLeft;
        case 'bottomRight': return Alignment.bottomRight;
        default: return null;
      }
    }
    return null;
  }
}
```

### 3.2 Responsive Layout

```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 800) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }

  static Widget fromConfig(Map<String, dynamic> properties) {
    return ResponsiveLayout(
      mobile: _buildWidget(properties['mobile']),
      tablet: properties['tablet'] != null
        ? _buildWidget(properties['tablet'])
        : null,
      desktop: properties['desktop'] != null
        ? _buildWidget(properties['desktop'])
        : null,
    );
  }

  static Widget _buildWidget(dynamic config) {
    if (config is Map) {
      return ComponentRegistry.build(
        config['type'],
        config['properties'] ?? {},
      );
    }
    return Container();
  }
}
```

## 4. Component Composition

### 4.1 Composite Components

```dart
class LoginForm extends StatelessWidget {
  final Map<String, dynamic> config;

  const LoginForm({Key? key, required this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField.fromConfig(config['email_field'] ?? {}),
        SizedBox(height: config['spacing']?.toDouble() ?? 16),
        CustomTextField.fromConfig(config['password_field'] ?? {}),
        SizedBox(height: config['spacing']?.toDouble() ?? 16),
        CustomButton.fromConfig(config['login_button'] ?? {}),
        if (config['forgot_password'] != null) ...[
          SizedBox(height: config['spacing']?.toDouble() ?? 16),
          _buildForgotPassword(config['forgot_password']),
        ],
      ],
    );
  }

  Widget _buildForgotPassword(Map<String, dynamic> config) {
    return GestureDetector(
      onTap: () {
        // Handle forgot password
      },
      child: Text(
        config['text'] ?? 'Forgot Password?',
        style: TextStyle(
          color: _parseColor(config['color']),
          fontSize: config['font_size']?.toDouble(),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
```

## 5. Component Registration System

### 5.1 Auto-Registration

```dart
class ComponentAutoRegistry {
  static final Map<String, ComponentDefinition> _components = {};

  static void registerAll() {
    // Register text field
    register('text_field', ComponentDefinition(
      builder: (properties) => CustomTextField.fromConfig(properties),
      schema: {
        'hint': PropertyDefinition(type: 'string'),
        'is_password': PropertyDefinition(type: 'boolean', defaultValue: false),
        'border_radius': PropertyDefinition(type: 'number', defaultValue: 8.0),
        'margin': PropertyDefinition(type: 'object'),
      },
    ));

    // Register button
    register('button', ComponentDefinition(
      builder: (properties) => CustomButton.fromConfig(properties),
      schema: {
        'text': PropertyDefinition(type: 'string', required: true),
        'background_color': PropertyDefinition(type: 'string'),
        'text_color': PropertyDefinition(type: 'string'),
        'border_radius': PropertyDefinition(type: 'number', defaultValue: 8.0),
        'margin': PropertyDefinition(type: 'object'),
      },
    ));

    // Register container
    register('container', ComponentDefinition(
      builder: (properties) => FlexibleContainer.fromConfig(
        properties,
        _buildChild(properties['child']),
      ),
      schema: {
        'padding': PropertyDefinition(type: 'object'),
        'margin': PropertyDefinition(type: 'object'),
        'background_color': PropertyDefinition(type: 'string'),
        'border_radius': PropertyDefinition(type: 'number'),
        'child': PropertyDefinition(type: 'object'),
      },
    ));
  }

  static Widget _buildChild(dynamic childConfig) {
    if (childConfig is Map) {
      return ComponentRegistry.build(
        childConfig['type'],
        childConfig['properties'] ?? {},
      );
    }
    return Container();
  }
}
```

## 6. Component Testing

### 6.1 Component Test Utilities

```dart
class ComponentTestUtils {
  static Widget testComponent(String componentName, Map<String, dynamic> properties) {
    return MaterialApp(
      home: Scaffold(
        body: ComponentRegistry.build(componentName, properties),
      ),
    );
  }

  static void testAllComponents() {
    final components = ComponentRegistry.getAvailableComponents();

    for (final component in components) {
      testWidgets('Test $component component', (WidgetTester tester) async {
        await tester.pumpWidget(
          testComponent(component, {}),
        );

        expect(find.byType(Container), findsOneWidget);
      });
    }
  }
}
```

## 7. Performance Optimization

### 7.1 Component Caching

```dart
class ComponentCache {
  static final Map<String, Widget> _cache = {};

  static Widget getCached(String key, WidgetBuilder builder) {
    if (!_cache.containsKey(key)) {
      _cache[key] = builder();
    }
    return _cache[key]!;
  }

  static void clearCache() {
    _cache.clear();
  }
}
```

## Conclusion

The component library system provides:

1. **Reusability**: Components can be used across different screens
2. **Flexibility**: Easy customization through configuration
3. **Maintainability**: Centralized component management
4. **Performance**: Caching and optimization strategies
5. **Testing**: Comprehensive testing utilities

This approach enables rapid UI development while maintaining code quality and performance.
