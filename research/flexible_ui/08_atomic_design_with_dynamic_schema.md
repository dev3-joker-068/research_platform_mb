# Atomic Design + Design Tokens + Dynamic Schema

## Overview

Kết hợp Atomic Design pattern với Design Tokens và Dynamic Schema để tạo ra một hệ thống UI linh hoạt, scalable và maintainable. Approach này cho phép xây dựng UI từ các components nhỏ nhất (atoms) đến các pages phức tạp với khả năng thay đổi design system động.

## 1. Atomic Design Architecture

### 1.1 Atomic Design Hierarchy

```dart
// Atomic Design Levels
abstract class AtomicComponent extends StatelessWidget {
  final String id;
  final Map<String, dynamic> properties;
  final StyleConfig? styleConfig;

  const AtomicComponent({
    Key? key,
    required this.id,
    required this.properties,
    this.styleConfig,
  }) : super(key: key);

  StyleConfig get config => styleConfig ?? StyleManager.currentConfig;
}

// Atoms - Smallest building blocks
class Atom extends AtomicComponent {
  const Atom({
    Key? key,
    required String id,
    required Map<String, dynamic> properties,
    StyleConfig? styleConfig,
  }) : super(key: key, id: id, properties: properties, styleConfig: styleConfig);
}

// Molecules - Simple combinations of atoms
class Molecule extends AtomicComponent {
  final List<Atom> atoms;

  const Molecule({
    Key? key,
    required String id,
    required Map<String, dynamic> properties,
    required this.atoms,
    StyleConfig? styleConfig,
  }) : super(key: key, id: id, properties: properties, styleConfig: styleConfig);
}

// Organisms - Complex combinations of molecules and atoms
class Organism extends AtomicComponent {
  final List<Molecule> molecules;
  final List<Atom> atoms;

  const Organism({
    Key? key,
    required String id,
    required Map<String, dynamic> properties,
    required this.molecules,
    required this.atoms,
    StyleConfig? styleConfig,
  }) : super(key: key, id: id, properties: properties, styleConfig: styleConfig);
}

// Templates - Page-level layouts
class Template extends AtomicComponent {
  final List<Organism> organisms;
  final List<Molecule> molecules;
  final List<Atom> atoms;

  const Template({
    Key? key,
    required String id,
    required Map<String, dynamic> properties,
    required this.organisms,
    required this.molecules,
    required this.atoms,
    StyleConfig? styleConfig,
  }) : super(key: key, id: id, properties: properties, styleConfig: styleConfig);
}

// Pages - Specific instances of templates
class Page extends AtomicComponent {
  final Template template;
  final Map<String, dynamic> pageData;

  const Page({
    Key? key,
    required String id,
    required Map<String, dynamic> properties,
    required this.template,
    required this.pageData,
    StyleConfig? styleConfig,
  }) : super(key: key, id: id, properties: properties, styleConfig: styleConfig);
}
```

### 1.2 Atomic Component Registry

```dart
class AtomicComponentRegistry {
  static final Map<String, AtomicComponentBuilder> _atoms = {};
  static final Map<String, AtomicComponentBuilder> _molecules = {};
  static final Map<String, AtomicComponentBuilder> _organisms = {};
  static final Map<String, AtomicComponentBuilder> _templates = {};

  // Register atoms
  static void registerAtom(String name, AtomicComponentBuilder builder) {
    _atoms[name] = builder;
  }

  // Register molecules
  static void registerMolecule(String name, AtomicComponentBuilder builder) {
    _molecules[name] = builder;
  }

  // Register organisms
  static void registerOrganism(String name, AtomicComponentBuilder builder) {
    _organisms[name] = builder;
  }

  // Register templates
  static void registerTemplate(String name, AtomicComponentBuilder builder) {
    _templates[name] = builder;
  }

  // Build components
  static Widget buildAtom(String name, Map<String, dynamic> properties, StyleConfig? styleConfig) {
    final builder = _atoms[name];
    if (builder != null) {
      return builder(properties, styleConfig);
    }
    return Container();
  }

  static Widget buildMolecule(String name, Map<String, dynamic> properties, StyleConfig? styleConfig) {
    final builder = _molecules[name];
    if (builder != null) {
      return builder(properties, styleConfig);
    }
    return Container();
  }

  static Widget buildOrganism(String name, Map<String, dynamic> properties, StyleConfig? styleConfig) {
    final builder = _organisms[name];
    if (builder != null) {
      return builder(properties, styleConfig);
    }
    return Container();
  }

  static Widget buildTemplate(String name, Map<String, dynamic> properties, StyleConfig? styleConfig) {
    final builder = _templates[name];
    if (builder != null) {
      return builder(properties, styleConfig);
    }
    return Container();
  }
}

typedef AtomicComponentBuilder = Widget Function(Map<String, dynamic> properties, StyleConfig? styleConfig);
```

## 2. Design Tokens System

### 2.1 Comprehensive Design Tokens

```dart
class DesignTokens {
  // Spacing Tokens
  static const Map<String, double> spacing = {
    'xs': 4.0,
    's': 8.0,
    'm': 16.0,
    'l': 24.0,
    'xl': 32.0,
    'xxl': 48.0,
    'xxxl': 64.0,
  };

  // Border Radius Tokens
  static const Map<String, double> radius = {
    'none': 0.0,
    'xs': 2.0,
    's': 4.0,
    'm': 8.0,
    'l': 12.0,
    'xl': 16.0,
    'xxl': 24.0,
    'full': 9999.0,
  };

  // Typography Tokens
  static const Map<String, double> fontSize = {
    'xs': 12.0,
    's': 14.0,
    'm': 16.0,
    'l': 18.0,
    'xl': 20.0,
    'xxl': 24.0,
    'xxxl': 32.0,
    'display': 48.0,
  };

  static const Map<String, FontWeight> fontWeight = {
    'normal': FontWeight.normal,
    'medium': FontWeight.w500,
    'semibold': FontWeight.w600,
    'bold': FontWeight.bold,
  };

  // Color Tokens
  static const Map<String, Color> colors = {
    // Primary Colors
    'primary50': Color(0xFFE3F2FD),
    'primary100': Color(0xFFBBDEFB),
    'primary200': Color(0xFF90CAF9),
    'primary300': Color(0xFF64B5F6),
    'primary400': Color(0xFF42A5F5),
    'primary500': Color(0xFF2196F3),
    'primary600': Color(0xFF1E88E5),
    'primary700': Color(0xFF1976D2),
    'primary800': Color(0xFF1565C0),
    'primary900': Color(0xFF0D47A1),

    // Neutral Colors
    'neutral50': Color(0xFFFAFAFA),
    'neutral100': Color(0xFFF5F5F5),
    'neutral200': Color(0xFFEEEEEE),
    'neutral300': Color(0xFFE0E0E0),
    'neutral400': Color(0xFFBDBDBD),
    'neutral500': Color(0xFF9E9E9E),
    'neutral600': Color(0xFF757575),
    'neutral700': Color(0xFF616161),
    'neutral800': Color(0xFF424242),
    'neutral900': Color(0xFF212121),

    // Semantic Colors
    'success': Color(0xFF4CAF50),
    'warning': Color(0xFFFF9800),
    'error': Color(0xFFF44336),
    'info': Color(0xFF2196F3),
  };

  // Shadow Tokens
  static const Map<String, List<BoxShadow>> shadows = {
    'xs': [
      BoxShadow(
        color: Color(0x1A000000),
        offset: Offset(0, 1),
        blurRadius: 2,
      ),
    ],
    's': [
      BoxShadow(
        color: Color(0x1A000000),
        offset: Offset(0, 2),
        blurRadius: 4,
      ),
    ],
    'm': [
      BoxShadow(
        color: Color(0x1A000000),
        offset: Offset(0, 4),
        blurRadius: 8,
      ),
    ],
    'l': [
      BoxShadow(
        color: Color(0x1A000000),
        offset: Offset(0, 8),
        blurRadius: 16,
      ),
    ],
    'xl': [
      BoxShadow(
        color: Color(0x1A000000),
        offset: Offset(0, 16),
        blurRadius: 32,
      ),
    ],
  };

  // Animation Tokens
  static const Map<String, Duration> durations = {
    'fast': Duration(milliseconds: 150),
    'normal': Duration(milliseconds: 300),
    'slow': Duration(milliseconds: 500),
  };

  static const Map<String, Curve> curves = {
    'easeIn': Curves.easeIn,
    'easeOut': Curves.easeOut,
    'easeInOut': Curves.easeInOut,
    'bounce': Curves.bounceOut,
    'elastic': Curves.elasticOut,
  };
}
```

### 2.2 Dynamic Token System

```dart
class DynamicTokenSystem {
  static final Map<String, dynamic> _tokens = {};
  static final Map<String, Function> _tokenGenerators = {};

  // Register token generators
  static void registerTokenGenerator(String tokenName, Function generator) {
    _tokenGenerators[tokenName] = generator;
  }

  // Get token value
  static dynamic getToken(String tokenName, [Map<String, dynamic>? context]) {
    // Check if token exists
    if (_tokens.containsKey(tokenName)) {
      return _tokens[tokenName];
    }

    // Check if generator exists
    if (_tokenGenerators.containsKey(tokenName)) {
      final generator = _tokenGenerators[tokenName]!;
      final value = generator(context ?? {});
      _tokens[tokenName] = value;
      return value;
    }

    return null;
  }

  // Set token value
  static void setToken(String tokenName, dynamic value) {
    _tokens[tokenName] = value;
  }

  // Generate responsive tokens
  static double getResponsiveSpacing(String baseToken, Size screenSize) {
    final baseValue = getToken(baseToken) as double? ?? 16.0;

    if (screenSize.width < 600) {
      return baseValue * 0.75; // Mobile
    } else if (screenSize.width < 1200) {
      return baseValue * 1.0; // Tablet
    } else {
      return baseValue * 1.25; // Desktop
    }
  }

  // Generate theme-aware tokens
  static Color getThemeAwareColor(String baseToken, Brightness brightness) {
    final baseColor = getToken(baseToken) as Color? ?? Colors.black;

    if (brightness == Brightness.dark) {
      return _adjustColorForDarkMode(baseColor);
    }

    return baseColor;
  }

  static Color _adjustColorForDarkMode(Color color) {
    // Simple dark mode adjustment
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + 0.3).clamp(0.0, 1.0)).toColor();
  }
}

// Register token generators
DynamicTokenSystem.registerTokenGenerator('spacing.adaptive', (context) {
  final screenSize = context['screenSize'] as Size? ?? Size(375, 812);
  return DynamicTokenSystem.getResponsiveSpacing('spacing.m', screenSize);
});

DynamicTokenSystem.registerTokenGenerator('color.adaptive', (context) {
  final brightness = context['brightness'] as Brightness? ?? Brightness.light;
  return DynamicTokenSystem.getThemeAwareColor('color.primary', brightness);
});
```

## 3. Dynamic Schema System

### 3.1 Schema Definition

```dart
class DynamicSchema {
  final String name;
  final String version;
  final Map<String, dynamic> properties;
  final Map<String, SchemaValidation> validations;
  final Map<String, SchemaTransformation> transformations;

  DynamicSchema({
    required this.name,
    required this.version,
    required this.properties,
    required this.validations,
    required this.transformations,
  });

  static DynamicSchema fromJson(Map<String, dynamic> json) {
    return DynamicSchema(
      name: json['name'],
      version: json['version'],
      properties: json['properties'] ?? {},
      validations: _parseValidations(json['validations']),
      transformations: _parseTransformations(json['transformations']),
    );
  }

  static Map<String, SchemaValidation> _parseValidations(dynamic validations) {
    final result = <String, SchemaValidation>{};
    if (validations is Map) {
      for (final entry in validations.entries) {
        result[entry.key] = SchemaValidation.fromJson(entry.value);
      }
    }
    return result;
  }

  static Map<String, SchemaTransformation> _parseTransformations(dynamic transformations) {
    final result = <String, SchemaTransformation>{};
    if (transformations is Map) {
      for (final entry in transformations.entries) {
        result[entry.key] = SchemaTransformation.fromJson(entry.value);
      }
    }
    return result;
  }

  // Validate data against schema
  Map<String, dynamic> validate(Map<String, dynamic> data) {
    final validated = <String, dynamic>{};

    for (final entry in properties.entries) {
      final key = entry.key;
      final schema = entry.value;

      if (data.containsKey(key)) {
        final value = data[key];

        // Apply validation
        if (validations.containsKey(key)) {
          final validation = validations[key]!;
          if (!validation.validate(value)) {
            throw SchemaValidationException('Validation failed for $key: ${validation.message}');
          }
        }

        // Apply transformation
        if (transformations.containsKey(key)) {
          final transformation = transformations[key]!;
          validated[key] = transformation.transform(value);
        } else {
          validated[key] = value;
        }
      } else if (schema['required'] == true) {
        throw SchemaValidationException('Required field $key is missing');
      } else if (schema['default'] != null) {
        validated[key] = schema['default'];
      }
    }

    return validated;
  }
}

class SchemaValidation {
  final String type;
  final dynamic min;
  final dynamic max;
  final String? pattern;
  final String message;

  SchemaValidation({
    required this.type,
    this.min,
    this.max,
    this.pattern,
    required this.message,
  });

  static SchemaValidation fromJson(Map<String, dynamic> json) {
    return SchemaValidation(
      type: json['type'],
      min: json['min'],
      max: json['max'],
      pattern: json['pattern'],
      message: json['message'] ?? 'Validation failed',
    );
  }

  bool validate(dynamic value) {
    switch (type) {
      case 'string':
        return _validateString(value);
      case 'number':
        return _validateNumber(value);
      case 'boolean':
        return _validateBoolean(value);
      case 'array':
        return _validateArray(value);
      case 'object':
        return _validateObject(value);
      default:
        return true;
    }
  }

  bool _validateString(dynamic value) {
    if (value is! String) return false;
    if (min != null && value.length < min) return false;
    if (max != null && value.length > max) return false;
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) return false;
    return true;
  }

  bool _validateNumber(dynamic value) {
    if (value is! num) return false;
    if (min != null && value < min) return false;
    if (max != null && value > max) return false;
    return true;
  }

  bool _validateBoolean(dynamic value) {
    return value is bool;
  }

  bool _validateArray(dynamic value) {
    if (value is! List) return false;
    if (min != null && value.length < min) return false;
    if (max != null && value.length > max) return false;
    return true;
  }

  bool _validateObject(dynamic value) {
    return value is Map;
  }
}

class SchemaTransformation {
  final String type;
  final Map<String, dynamic> options;

  SchemaTransformation({
    required this.type,
    required this.options,
  });

  static SchemaTransformation fromJson(Map<String, dynamic> json) {
    return SchemaTransformation(
      type: json['type'],
      options: json['options'] ?? {},
    );
  }

  dynamic transform(dynamic value) {
    switch (type) {
      case 'uppercase':
        return value.toString().toUpperCase();
      case 'lowercase':
        return value.toString().toLowerCase();
      case 'trim':
        return value.toString().trim();
      case 'number':
        return double.tryParse(value.toString()) ?? 0.0;
      case 'boolean':
        return value.toString().toLowerCase() == 'true';
      case 'color':
        return _parseColor(value.toString());
      case 'token':
        return DynamicTokenSystem.getToken(value.toString());
      default:
        return value;
    }
  }

  Color _parseColor(String colorString) {
    if (colorString.startsWith('#')) {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    }
    return Colors.black;
  }
}

class SchemaValidationException implements Exception {
  final String message;
  SchemaValidationException(this.message);

  @override
  String toString() => 'SchemaValidationException: $message';
}
```

### 3.2 Schema Registry

```dart
class SchemaRegistry {
  static final Map<String, DynamicSchema> _schemas = {};

  static void registerSchema(String name, DynamicSchema schema) {
    _schemas[name] = schema;
  }

  static DynamicSchema? getSchema(String name) {
    return _schemas[name];
  }

  static Map<String, dynamic> validateData(String schemaName, Map<String, dynamic> data) {
    final schema = getSchema(schemaName);
    if (schema == null) {
      throw SchemaValidationException('Schema $schemaName not found');
    }
    return schema.validate(data);
  }

  static List<String> getAvailableSchemas() {
    return _schemas.keys.toList();
  }
}
```

## 4. Atomic Components Implementation

### 4.1 Atoms

```dart
// Text Atom
class TextAtom extends Atom {
  const TextAtom({
    Key? key,
    required String id,
    required Map<String, dynamic> properties,
    StyleConfig? styleConfig,
  }) : super(key: key, id: id, properties: properties, styleConfig: styleConfig);

  @override
  Widget build(BuildContext context) {
    final text = properties['text'] ?? '';
    final variant = properties['variant'] ?? 'body';
    final color = properties['color'];
    final align = properties['align'] ?? TextAlign.left;

    return Text(
      text,
      style: _getTextStyle(variant, color),
      textAlign: _parseTextAlign(align),
    );
  }

  TextStyle _getTextStyle(String variant, dynamic color) {
    final baseStyle = config.textStyles[variant] ?? TextStyle();
    final tokenColor = color != null ? DynamicTokenSystem.getToken(color) : null;

    return baseStyle.copyWith(
      color: tokenColor ?? baseStyle.color,
    );
  }

  TextAlign _parseTextAlign(String align) {
    switch (align) {
      case 'center': return TextAlign.center;
      case 'right': return TextAlign.right;
      case 'justify': return TextAlign.justify;
      default: return TextAlign.left;
    }
  }
}

// Button Atom
class ButtonAtom extends Atom {
  const ButtonAtom({
    Key? key,
    required String id,
    required Map<String, dynamic> properties,
    StyleConfig? styleConfig,
  }) : super(key: key, id: id, properties: properties, styleConfig: styleConfig);

  @override
  Widget build(BuildContext context) {
    final text = properties['text'] ?? '';
    final variant = properties['variant'] ?? 'primary';
    final size = properties['size'] ?? 'medium';
    final onPressed = properties['onPressed'];

    return ElevatedButton(
      onPressed: onPressed,
      style: _getButtonStyle(variant, size),
      child: Text(text, style: _getTextStyle(size)),
    );
  }

  ButtonStyle _getButtonStyle(String variant, String size) {
    final backgroundColor = DynamicTokenSystem.getToken('color.$variant') as Color? ?? Colors.blue;
    final padding = DynamicTokenSystem.getToken('spacing.button.$size') as double? ?? 16.0;
    final radius = DynamicTokenSystem.getToken('radius.button.$size') as double? ?? 8.0;

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      padding: EdgeInsets.all(padding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  TextStyle _getTextStyle(String size) {
    final fontSize = DynamicTokenSystem.getToken('fontSize.$size') as double? ?? 16.0;
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }
}

// Input Atom
class InputAtom extends Atom {
  const InputAtom({
    Key? key,
    required String id,
    required Map<String, dynamic> properties,
    StyleConfig? styleConfig,
  }) : super(key: key, id: id, properties: properties, styleConfig: styleConfig);

  @override
  Widget build(BuildContext context) {
    final placeholder = properties['placeholder'] ?? '';
    final type = properties['type'] ?? 'text';
    final size = properties['size'] ?? 'medium';

    return TextField(
      obscureText: type == 'password',
      decoration: InputDecoration(
        hintText: placeholder,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            DynamicTokenSystem.getToken('radius.input.$size') as double? ?? 8.0,
          ),
        ),
        contentPadding: EdgeInsets.all(
          DynamicTokenSystem.getToken('spacing.input.$size') as double? ?? 12.0,
        ),
      ),
    );
  }
}
```

### 4.2 Molecules

```dart
// Form Field Molecule
class FormFieldMolecule extends Molecule {
  const FormFieldMolecule({
    Key? key,
    required String id,
    required Map<String, dynamic> properties,
    required List<Atom> atoms,
    StyleConfig? styleConfig,
  }) : super(key: key, id: id, properties: properties, atoms: atoms, styleConfig: styleConfig);

  @override
  Widget build(BuildContext context) {
    final label = properties['label'] ?? '';
    final required = properties['required'] ?? false;
    final error = properties['error'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            '$label${required ? ' *' : ''}',
            style: _getLabelStyle(),
          ),
          SizedBox(height: DynamicTokenSystem.getToken('spacing.xs') as double? ?? 4.0),
        ],
        ...atoms.map((atom) => atom),
        if (error != null) ...[
          SizedBox(height: DynamicTokenSystem.getToken('spacing.xs') as double? ?? 4.0),
          Text(
            error,
            style: _getErrorStyle(),
          ),
        ],
      ],
    );
  }

  TextStyle _getLabelStyle() {
    return TextStyle(
      fontSize: DynamicTokenSystem.getToken('fontSize.s') as double? ?? 14.0,
      fontWeight: FontWeight.w500,
      color: DynamicTokenSystem.getToken('color.neutral700') as Color? ?? Colors.grey[700],
    );
  }

  TextStyle _getErrorStyle() {
    return TextStyle(
      fontSize: DynamicTokenSystem.getToken('fontSize.xs') as double? ?? 12.0,
      color: DynamicTokenSystem.getToken('color.error') as Color? ?? Colors.red,
    );
  }
}

// Card Molecule
class CardMolecule extends Molecule {
  const CardMolecule({
    Key? key,
    required String id,
    required Map<String, dynamic> properties,
    required List<Atom> atoms,
    StyleConfig? styleConfig,
  }) : super(key: key, id: id, properties: properties, atoms: atoms, styleConfig: styleConfig);

  @override
  Widget build(BuildContext context) {
    final variant = properties['variant'] ?? 'default';
    final padding = properties['padding'] ?? 'medium';

    return Container(
      padding: EdgeInsets.all(
        DynamicTokenSystem.getToken('spacing.$padding') as double? ?? 16.0,
      ),
      decoration: _getCardDecoration(variant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: atoms.map((atom) => atom).toList(),
      ),
    );
  }

  BoxDecoration _getCardDecoration(String variant) {
    final backgroundColor = DynamicTokenSystem.getToken('color.background') as Color? ?? Colors.white;
    final radius = DynamicTokenSystem.getToken('radius.card') as double? ?? 12.0;

    switch (variant) {
      case 'elevated':
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: DynamicTokenSystem.getToken('shadow.m') as List<BoxShadow>? ?? [],
        );
      case 'outlined':
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: DynamicTokenSystem.getToken('color.neutral300') as Color? ?? Colors.grey[300]!,
          ),
        );
      default:
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
        );
    }
  }
}
```

### 4.3 Organisms

```dart
// Login Form Organism
class LoginFormOrganism extends Organism {
  const LoginFormOrganism({
    Key? key,
    required String id,
    required Map<String, dynamic> properties,
    required List<Molecule> molecules,
    required List<Atom> atoms,
    StyleConfig? styleConfig,
  }) : super(key: key, id: id, properties: properties, molecules: molecules, atoms: atoms, styleConfig: styleConfig);

  @override
  Widget build(BuildContext context) {
    final title = properties['title'] ?? 'Login';
    final subtitle = properties['subtitle'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Column(
          children: [
            Text(
              title,
              style: _getTitleStyle(),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: DynamicTokenSystem.getToken('spacing.s') as double? ?? 8.0),
              Text(
                subtitle,
                style: _getSubtitleStyle(),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
        SizedBox(height: DynamicTokenSystem.getToken('spacing.xl') as double? ?? 32.0),

        // Form Fields
        ...molecules.map((molecule) => molecule),

        SizedBox(height: DynamicTokenSystem.getToken('spacing.l') as double? ?? 24.0),

        // Actions
        ...atoms.map((atom) => atom),
      ],
    );
  }

  TextStyle _getTitleStyle() {
    return TextStyle(
      fontSize: DynamicTokenSystem.getToken('fontSize.xxl') as double? ?? 24.0,
      fontWeight: FontWeight.bold,
      color: DynamicTokenSystem.getToken('color.neutral900') as Color? ?? Colors.black,
    );
  }

  TextStyle _getSubtitleStyle() {
    return TextStyle(
      fontSize: DynamicTokenSystem.getToken('fontSize.m') as double? ?? 16.0,
      color: DynamicTokenSystem.getToken('color.neutral600') as Color? ?? Colors.grey[600],
    );
  }
}

// Navigation Organism
class NavigationOrganism extends Organism {
  const NavigationOrganism({
    Key? key,
    required String id,
    required Map<String, dynamic> properties,
    required List<Molecule> molecules,
    required List<Atom> atoms,
    StyleConfig? styleConfig,
  }) : super(key: key, id: id, properties: properties, molecules: molecules, atoms: atoms, styleConfig: styleConfig);

  @override
  Widget build(BuildContext context) {
    final variant = properties['variant'] ?? 'horizontal';
    final position = properties['position'] ?? 'top';

    return Container(
      padding: EdgeInsets.all(
        DynamicTokenSystem.getToken('spacing.m') as double? ?? 16.0,
      ),
      decoration: _getNavigationDecoration(position),
      child: _buildNavigationContent(variant),
    );
  }

  Widget _buildNavigationContent(String variant) {
    switch (variant) {
      case 'horizontal':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...molecules.map((molecule) => molecule),
            ...atoms.map((atom) => atom),
          ],
        );
      case 'vertical':
        return Column(
          children: [
            ...molecules.map((molecule) => molecule),
            ...atoms.map((atom) => atom),
          ],
        );
      default:
        return Row(
          children: [
            ...molecules.map((molecule) => molecule),
            ...atoms.map((atom) => atom),
          ],
        );
    }
  }

  BoxDecoration _getNavigationDecoration(String position) {
    final backgroundColor = DynamicTokenSystem.getToken('color.background') as Color? ?? Colors.white;

    switch (position) {
      case 'bottom':
        return BoxDecoration(
          color: backgroundColor,
          boxShadow: DynamicTokenSystem.getToken('shadow.s') as List<BoxShadow>? ?? [],
        );
      default:
        return BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: DynamicTokenSystem.getToken('color.neutral200') as Color? ?? Colors.grey[200]!,
            ),
          ),
        );
    }
  }
}
```

## 5. Schema Examples

### 5.1 Button Schema

```json
{
  "name": "button",
  "version": "1.0.0",
  "properties": {
    "text": {
      "type": "string",
      "required": true,
      "min": 1,
      "max": 50
    },
    "variant": {
      "type": "string",
      "default": "primary",
      "enum": ["primary", "secondary", "outline", "ghost"]
    },
    "size": {
      "type": "string",
      "default": "medium",
      "enum": ["small", "medium", "large"]
    },
    "disabled": {
      "type": "boolean",
      "default": false
    }
  },
  "validations": {
    "text": {
      "type": "string",
      "min": 1,
      "max": 50,
      "message": "Button text must be between 1 and 50 characters"
    }
  },
  "transformations": {
    "text": {
      "type": "trim"
    }
  }
}
```

### 5.2 Form Field Schema

```json
{
  "name": "form_field",
  "version": "1.0.0",
  "properties": {
    "label": {
      "type": "string",
      "required": true,
      "max": 100
    },
    "placeholder": {
      "type": "string",
      "max": 100
    },
    "type": {
      "type": "string",
      "default": "text",
      "enum": ["text", "email", "password", "number", "tel"]
    },
    "required": {
      "type": "boolean",
      "default": false
    },
    "error": {
      "type": "string"
    },
    "validation": {
      "type": "object",
      "properties": {
        "pattern": {
          "type": "string"
        },
        "min": {
          "type": "number"
        },
        "max": {
          "type": "number"
        }
      }
    }
  },
  "validations": {
    "label": {
      "type": "string",
      "min": 1,
      "max": 100,
      "message": "Label must be between 1 and 100 characters"
    },
    "placeholder": {
      "type": "string",
      "max": 100,
      "message": "Placeholder must be less than 100 characters"
    }
  },
  "transformations": {
    "label": {
      "type": "trim"
    },
    "placeholder": {
      "type": "trim"
    }
  }
}
```

### 5.3 Card Schema

```json
{
  "name": "card",
  "version": "1.0.0",
  "properties": {
    "title": {
      "type": "string",
      "max": 200
    },
    "subtitle": {
      "type": "string",
      "max": 500
    },
    "variant": {
      "type": "string",
      "default": "default",
      "enum": ["default", "elevated", "outlined"]
    },
    "padding": {
      "type": "string",
      "default": "medium",
      "enum": ["none", "small", "medium", "large"]
    },
    "actions": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "label": {
            "type": "string",
            "required": true
          },
          "action": {
            "type": "string",
            "required": true
          }
        }
      }
    }
  },
  "validations": {
    "title": {
      "type": "string",
      "max": 200,
      "message": "Title must be less than 200 characters"
    },
    "subtitle": {
      "type": "string",
      "max": 500,
      "message": "Subtitle must be less than 500 characters"
    }
  },
  "transformations": {
    "title": {
      "type": "trim"
    },
    "subtitle": {
      "type": "trim"
    }
  }
}
```

## 6. Usage Examples

### 6.1 Building with Atomic Design

```dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create atoms
    final emailInput = InputAtom(
      id: 'email_input',
      properties: {
        'placeholder': 'Enter your email',
        'type': 'email',
        'size': 'medium',
      },
    );

    final passwordInput = InputAtom(
      id: 'password_input',
      properties: {
        'placeholder': 'Enter your password',
        'type': 'password',
        'size': 'medium',
      },
    );

    final loginButton = ButtonAtom(
      id: 'login_button',
      properties: {
        'text': 'Login',
        'variant': 'primary',
        'size': 'large',
        'onPressed': () => _handleLogin(),
      },
    );

    // Create molecules
    final emailField = FormFieldMolecule(
      id: 'email_field',
      properties: {
        'label': 'Email',
        'required': true,
      },
      atoms: [emailInput],
    );

    final passwordField = FormFieldMolecule(
      id: 'password_field',
      properties: {
        'label': 'Password',
        'required': true,
      },
      atoms: [passwordInput],
    );

    // Create organism
    final loginForm = LoginFormOrganism(
      id: 'login_form',
      properties: {
        'title': 'Welcome Back',
        'subtitle': 'Sign in to your account',
      },
      molecules: [emailField, passwordField],
      atoms: [loginButton],
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: loginForm,
      ),
    );
  }
}
```

### 6.2 Dynamic Schema Validation

```dart
class DynamicFormBuilder {
  static Widget buildFromSchema(String schemaName, Map<String, dynamic> data) {
    // Validate data against schema
    final validatedData = SchemaRegistry.validateData(schemaName, data);

    // Build component based on schema
    switch (schemaName) {
      case 'button':
        return ButtonAtom(
          id: 'dynamic_button',
          properties: validatedData,
        );
      case 'form_field':
        return FormFieldMolecule(
          id: 'dynamic_field',
          properties: validatedData,
          atoms: [
            InputAtom(
              id: 'input',
              properties: validatedData,
            ),
          ],
        );
      case 'card':
        return CardMolecule(
          id: 'dynamic_card',
          properties: validatedData,
          atoms: [],
        );
      default:
        return Container();
    }
  }
}

// Usage
Widget buildDynamicButton() {
  return DynamicFormBuilder.buildFromSchema('button', {
    'text': 'Click me',
    'variant': 'primary',
    'size': 'medium',
  });
}
```

## 7. Benefits of This Approach

### 7.1 Atomic Design Benefits

- **Consistency**: Tất cả components follow cùng pattern
- **Reusability**: Components có thể tái sử dụng ở nhiều nơi
- **Scalability**: Dễ dàng mở rộng và thêm components mới
- **Maintainability**: Dễ dàng maintain và update

### 7.2 Design Tokens Benefits

- **Centralized Design**: Tất cả design values được centralize
- **Dynamic Theming**: Dễ dàng thay đổi theme
- **Responsive Design**: Tự động adapt theo screen size
- **Performance**: Optimized với token caching

### 7.3 Dynamic Schema Benefits

- **Type Safety**: Validation và type checking
- **Flexibility**: Dynamic component generation
- **Error Handling**: Proper error handling và validation
- **Extensibility**: Dễ dàng extend schemas

## 8. Implementation Strategy

### 8.1 Phase 1: Foundation

1. Implement Atomic Design hierarchy
2. Create Design Tokens system
3. Build basic atoms (Text, Button, Input)
4. Implement schema validation

### 8.2 Phase 2: Molecules & Organisms

1. Create common molecules (FormField, Card)
2. Build complex organisms (LoginForm, Navigation)
3. Add responsive design support
4. Implement theme switching

### 8.3 Phase 3: Advanced Features

1. Dynamic component generation
2. Schema-driven UI building
3. Performance optimization
4. Testing and documentation

## Conclusion

Kết hợp Atomic Design + Design Tokens + Dynamic Schema tạo ra một hệ thống UI mạnh mẽ với:

1. **Atomic Design**: Cấu trúc rõ ràng và scalable
2. **Design Tokens**: Centralized design system
3. **Dynamic Schema**: Type-safe và flexible component generation

Approach này cung cấp maximum flexibility và maintainability cho việc xây dựng UI systems trong Flutter!
