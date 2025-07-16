# Effective Variant Management trong Flutter

## Overview

Các cách quản lý variants hiệu quả hơn, tránh dùng string để giảm lỗi typo và tăng type safety.

## 1. Enum-Based Variants

### 1.1 Basic Enum Approach

```dart
// Thay vì dùng string
enum ButtonVariant {
  primary,
  secondary,
  outline,
  text,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final buttonSize = _getButtonSize();

    Widget buttonChild = isLoading
      ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getTextColor(),
            ),
          ),
        )
      : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: _getIconSize()),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(text, style: _getTextStyle()),
          ],
        );

    switch (variant) {
      case ButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: buttonSize,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            side: const BorderSide(color: AppColors.primary),
          ),
          child: buttonChild,
        );
      case ButtonVariant.outline:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: buttonSize,
            foregroundColor: AppColors.primary,
          ),
          child: buttonChild,
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: buttonSize,
            foregroundColor: AppColors.primary,
          ),
          child: buttonChild,
        );
      case ButtonVariant.primary:
      default:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: buttonSize,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: buttonChild,
        );
    }
  }

  EdgeInsets _getButtonSize() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        );
      case ButtonSize.medium:
      default:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTypography.caption;
      case ButtonSize.large:
        return AppTypography.h3;
      case ButtonSize.medium:
      default:
        return AppTypography.body;
    }
  }

  Color _getTextColor() {
    switch (variant) {
      case ButtonVariant.secondary:
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return AppColors.primary;
      case ButtonVariant.primary:
      default:
        return Colors.white;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16.0;
      case ButtonSize.large:
        return 24.0;
      case ButtonSize.medium:
      default:
        return 20.0;
    }
  }
}

// Sử dụng
AppButton(
  text: 'Click Me',
  variant: ButtonVariant.primary, // Type safe!
  size: ButtonSize.medium,
  onPressed: () {},
)
```

### 1.2 Comprehensive Enum System

```dart
// variants/app_variants.dart
enum ButtonVariant {
  primary,
  secondary,
  outline,
  text,
  danger,
  success,
  warning,
}

enum ButtonSize {
  xs,
  sm,
  md,
  lg,
  xl,
}

enum TextVariant {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  body,
  bodySmall,
  caption,
  overline,
}

enum InputVariant {
  outlined,
  filled,
  underlined,
}

enum InputSize {
  small,
  medium,
  large,
}

enum CardVariant {
  elevated,
  outlined,
  filled,
}

enum SpacingVariant {
  none,
  xs,
  sm,
  md,
  lg,
  xl,
  xxl,
}
```

## 2. Const Class Approach

### 2.1 Const Class Variants

```dart
// variants/app_variants.dart
class ButtonVariants {
  const ButtonVariants._();

  static const primary = 'primary';
  static const secondary = 'secondary';
  static const outline = 'outline';
  static const text = 'text';
  static const danger = 'danger';
  static const success = 'success';
  static const warning = 'warning';

  // Validation method
  static bool isValid(String variant) {
    return [primary, secondary, outline, text, danger, success, warning]
        .contains(variant);
  }

  // Get all variants
  static List<String> get all => [
    primary, secondary, outline, text, danger, success, warning,
  ];
}

class ButtonSizes {
  const ButtonSizes._();

  static const xs = 'xs';
  static const sm = 'small';
  static const md = 'medium';
  static const lg = 'large';
  static const xl = 'xl';

  static bool isValid(String size) {
    return [xs, sm, md, lg, xl].contains(size);
  }

  static List<String> get all => [xs, sm, md, lg, xl];
}

// Sử dụng
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String variant;
  final String size;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariants.primary,
    this.size = ButtonSizes.md,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Validation
    assert(ButtonVariants.isValid(variant), 'Invalid button variant: $variant');
    assert(ButtonSizes.isValid(size), 'Invalid button size: $size');

    // Implementation...
  }
}

// Sử dụng
AppButton(
  text: 'Click Me',
  variant: ButtonVariants.primary, // Const reference
  size: ButtonSizes.md,
  onPressed: () {},
)
```

## 3. Typed Variant Classes

### 3.1 Typed Variant Classes

```dart
// variants/typed_variants.dart
class ButtonVariant {
  final String value;
  const ButtonVariant._(this.value);

  static const primary = ButtonVariant._('primary');
  static const secondary = ButtonVariant._('secondary');
  static const outline = ButtonVariant._('outline');
  static const text = ButtonVariant._('text');
  static const danger = ButtonVariant._('danger');
  static const success = ButtonVariant._('success');
  static const warning = ButtonVariant._('warning');

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ButtonVariant && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class ButtonSize {
  final String value;
  const ButtonSize._(this.value);

  static const xs = ButtonSize._('xs');
  static const sm = ButtonSize._('small');
  static const md = ButtonSize._('medium');
  static const lg = ButtonSize._('large');
  static const xl = ButtonSize._('xl');

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ButtonSize && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

// Sử dụng
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
        return _buildPrimaryButton();
      case ButtonVariant.secondary:
        return _buildSecondaryButton();
      case ButtonVariant.outline:
        return _buildOutlineButton();
      case ButtonVariant.text:
        return _buildTextButton();
      case ButtonVariant.danger:
        return _buildDangerButton();
      case ButtonVariant.success:
        return _buildSuccessButton();
      case ButtonVariant.warning:
        return _buildWarningButton();
    }
  }

  Widget _buildPrimaryButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: _getPadding(),
      ),
      child: Text(text),
    );
  }

  Widget _buildSecondaryButton() {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: _getPadding(),
        side: const BorderSide(color: AppColors.primary),
      ),
      child: Text(text),
    );
  }

  Widget _buildOutlineButton() {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: _getPadding(),
        foregroundColor: AppColors.primary,
      ),
      child: Text(text),
    );
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: _getPadding(),
        foregroundColor: AppColors.primary,
      ),
      child: Text(text),
    );
  }

  Widget _buildDangerButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        padding: _getPadding(),
      ),
      child: Text(text),
    );
  }

  Widget _buildSuccessButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        padding: _getPadding(),
      ),
      child: Text(text),
    );
  }

  Widget _buildWarningButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.warning,
        foregroundColor: Colors.white,
        padding: _getPadding(),
      ),
      child: Text(text),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.xs:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        );
      case ButtonSize.sm:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case ButtonSize.md:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
      case ButtonSize.lg:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        );
      case ButtonSize.xl:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        );
    }
  }
}

// Sử dụng
AppButton(
  text: 'Click Me',
  variant: ButtonVariant.primary, // Type safe!
  size: ButtonSize.md,
  onPressed: () {},
)
```

## 4. Extension-Based Approach

### 4.1 Extension Methods

```dart
// variants/variant_extensions.dart
enum ButtonVariant {
  primary,
  secondary,
  outline,
  text,
  danger,
  success,
  warning,
}

enum ButtonSize {
  xs,
  sm,
  md,
  lg,
  xl,
}

extension ButtonVariantExtension on ButtonVariant {
  Color get backgroundColor {
    switch (this) {
      case ButtonVariant.primary:
        return AppColors.primary;
      case ButtonVariant.secondary:
        return Colors.transparent;
      case ButtonVariant.outline:
        return Colors.transparent;
      case ButtonVariant.text:
        return Colors.transparent;
      case ButtonVariant.danger:
        return AppColors.error;
      case ButtonVariant.success:
        return AppColors.success;
      case ButtonVariant.warning:
        return AppColors.warning;
    }
  }

  Color get foregroundColor {
    switch (this) {
      case ButtonVariant.primary:
      case ButtonVariant.danger:
      case ButtonVariant.success:
      case ButtonVariant.warning:
        return Colors.white;
      case ButtonVariant.secondary:
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return AppColors.primary;
    }
  }

  BorderSide? get borderSide {
    switch (this) {
      case ButtonVariant.secondary:
        return const BorderSide(color: AppColors.primary);
      case ButtonVariant.outline:
      case ButtonVariant.text:
      case ButtonVariant.primary:
      case ButtonVariant.danger:
      case ButtonVariant.success:
      case ButtonVariant.warning:
        return null;
    }
  }

  String get name {
    switch (this) {
      case ButtonVariant.primary:
        return 'primary';
      case ButtonVariant.secondary:
        return 'secondary';
      case ButtonVariant.outline:
        return 'outline';
      case ButtonVariant.text:
        return 'text';
      case ButtonVariant.danger:
        return 'danger';
      case ButtonVariant.success:
        return 'success';
      case ButtonVariant.warning:
        return 'warning';
    }
  }
}

extension ButtonSizeExtension on ButtonSize {
  EdgeInsets get padding {
    switch (this) {
      case ButtonSize.xs:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        );
      case ButtonSize.sm:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case ButtonSize.md:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
      case ButtonSize.lg:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        );
      case ButtonSize.xl:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        );
    }
  }

  double get fontSize {
    switch (this) {
      case ButtonSize.xs:
        return 12.0;
      case ButtonSize.sm:
        return 14.0;
      case ButtonSize.md:
        return 16.0;
      case ButtonSize.lg:
        return 18.0;
      case ButtonSize.xl:
        return 20.0;
    }
  }

  double get iconSize {
    switch (this) {
      case ButtonSize.xs:
        return 14.0;
      case ButtonSize.sm:
        return 16.0;
      case ButtonSize.md:
        return 18.0;
      case ButtonSize.lg:
        return 20.0;
      case ButtonSize.xl:
        return 24.0;
    }
  }
}

// Sử dụng
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasBorder = variant.borderSide != null;

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: size.iconSize),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: size.fontSize,
            color: variant.foregroundColor,
          ),
        ),
      ],
    );

    if (hasBorder) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: size.padding,
          side: variant.borderSide,
          backgroundColor: variant.backgroundColor,
        ),
        child: buttonChild,
      );
    } else if (variant == ButtonVariant.text) {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: size.padding,
          foregroundColor: variant.foregroundColor,
        ),
        child: buttonChild,
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: variant.backgroundColor,
          foregroundColor: variant.foregroundColor,
          padding: size.padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: buttonChild,
      );
    }
  }
}

// Sử dụng
AppButton(
  text: 'Click Me',
  variant: ButtonVariant.primary, // Type safe!
  size: ButtonSize.md,
  icon: Icons.add,
  onPressed: () {},
)
```

## 5. Variant Registry Pattern

### 5.1 Variant Registry

```dart
// variants/variant_registry.dart
class VariantRegistry {
  static final Map<String, Map<String, dynamic>> _variants = {
    'button': {
      'primary': {
        'backgroundColor': AppColors.primary,
        'foregroundColor': Colors.white,
        'borderSide': null,
      },
      'secondary': {
        'backgroundColor': Colors.transparent,
        'foregroundColor': AppColors.primary,
        'borderSide': const BorderSide(color: AppColors.primary),
      },
      'outline': {
        'backgroundColor': Colors.transparent,
        'foregroundColor': AppColors.primary,
        'borderSide': null,
      },
      'text': {
        'backgroundColor': Colors.transparent,
        'foregroundColor': AppColors.primary,
        'borderSide': null,
      },
      'danger': {
        'backgroundColor': AppColors.error,
        'foregroundColor': Colors.white,
        'borderSide': null,
      },
      'success': {
        'backgroundColor': AppColors.success,
        'foregroundColor': Colors.white,
        'borderSide': null,
      },
      'warning': {
        'backgroundColor': AppColors.warning,
        'foregroundColor': Colors.white,
        'borderSide': null,
      },
    },
    'size': {
      'xs': {
        'padding': const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        'fontSize': 12.0,
        'iconSize': 14.0,
      },
      'sm': {
        'padding': const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        'fontSize': 14.0,
        'iconSize': 16.0,
      },
      'md': {
        'padding': const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        'fontSize': 16.0,
        'iconSize': 18.0,
      },
      'lg': {
        'padding': const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        'fontSize': 18.0,
        'iconSize': 20.0,
      },
      'xl': {
        'padding': const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        ),
        'fontSize': 20.0,
        'iconSize': 24.0,
      },
    },
  };

  static Map<String, dynamic>? getVariant(String component, String variant) {
    return _variants[component]?[variant];
  }

  static Map<String, dynamic>? getSize(String size) {
    return _variants['size']?[size];
  }

  static List<String> getAvailableVariants(String component) {
    return _variants[component]?.keys.toList() ?? [];
  }

  static List<String> getAvailableSizes() {
    return _variants['size']?.keys.toList() ?? [];
  }
}

// Sử dụng
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String variant;
  final String size;
  final IconData? icon;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = 'primary',
    this.size = 'md',
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final variantConfig = VariantRegistry.getVariant('button', variant);
    final sizeConfig = VariantRegistry.getSize(size);

    if (variantConfig == null || sizeConfig == null) {
      throw ArgumentError('Invalid variant or size: $variant, $size');
    }

    final backgroundColor = variantConfig['backgroundColor'] as Color;
    final foregroundColor = variantConfig['foregroundColor'] as Color;
    final borderSide = variantConfig['borderSide'] as BorderSide?;
    final padding = sizeConfig['padding'] as EdgeInsets;
    final fontSize = sizeConfig['fontSize'] as double;
    final iconSize = sizeConfig['iconSize'] as double;

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: iconSize),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: foregroundColor,
          ),
        ),
      ],
    );

    if (borderSide != null) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding,
          side: borderSide,
          backgroundColor: backgroundColor,
        ),
        child: buttonChild,
      );
    } else if (variant == 'text') {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: padding,
          foregroundColor: foregroundColor,
        ),
        child: buttonChild,
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: buttonChild,
      );
    }
  }
}

// Sử dụng
AppButton(
  text: 'Click Me',
  variant: 'primary', // Validated at runtime
  size: 'md',
  icon: Icons.add,
  onPressed: () {},
)
```

## 6. Code Generation Approach

### 6.1 Code Generation with build_runner

```dart
// variants/variant_annotations.dart
class ButtonVariant {
  const ButtonVariant(this.value);
  final String value;
}

class ButtonSize {
  const ButtonSize(this.value);
  final String value;
}

// variants/variant_constants.dart
class ButtonVariants {
  static const primary = ButtonVariant('primary');
  static const secondary = ButtonVariant('secondary');
  static const outline = ButtonVariant('outline');
  static const text = ButtonVariant('text');
  static const danger = ButtonVariant('danger');
  static const success = ButtonVariant('success');
  static const warning = ButtonVariant('warning');
}

class ButtonSizes {
  static const xs = ButtonSize('xs');
  static const sm = ButtonSize('small');
  static const md = ButtonSize('medium');
  static const lg = ButtonSize('large');
  static const xl = ButtonSize('xl');
}

// Generated code (using build_runner)
// variants/generated/variant_extensions.dart
extension ButtonVariantExtension on ButtonVariant {
  Color get backgroundColor {
    switch (value) {
      case 'primary':
        return AppColors.primary;
      case 'secondary':
        return Colors.transparent;
      case 'outline':
        return Colors.transparent;
      case 'text':
        return Colors.transparent;
      case 'danger':
        return AppColors.error;
      case 'success':
        return AppColors.success;
      case 'warning':
        return AppColors.warning;
      default:
        throw ArgumentError('Unknown button variant: $value');
    }
  }

  Color get foregroundColor {
    switch (value) {
      case 'primary':
      case 'danger':
      case 'success':
      case 'warning':
        return Colors.white;
      case 'secondary':
      case 'outline':
      case 'text':
        return AppColors.primary;
      default:
        throw ArgumentError('Unknown button variant: $value');
    }
  }
}
```

## 7. Comparison of Approaches

### 7.1 Enum Approach

**Pros:**

- ✅ Type safe
- ✅ Compile-time checking
- ✅ IDE autocomplete
- ✅ No runtime errors
- ✅ Easy to refactor

**Cons:**

- ❌ Less flexible
- ❌ Harder to add new variants
- ❌ More boilerplate code

### 7.2 Const Class Approach

**Pros:**

- ✅ Type safe with validation
- ✅ Easy to add new variants
- ✅ Runtime validation
- ✅ Good IDE support

**Cons:**

- ❌ Runtime errors possible
- ❌ More complex validation
- ❌ String-based internally

### 7.3 Typed Variant Classes

**Pros:**

- ✅ Type safe
- ✅ Compile-time checking
- ✅ Easy to extend
- ✅ Good IDE support

**Cons:**

- ❌ More boilerplate
- ❌ Complex implementation
- ❌ Harder to understand

### 7.4 Extension-Based Approach

**Pros:**

- ✅ Type safe
- ✅ Clean API
- ✅ Easy to use
- ✅ Good performance

**Cons:**

- ❌ More complex setup
- ❌ Harder to maintain
- ❌ Extension limitations

### 7.5 Variant Registry

**Pros:**

- ✅ Very flexible
- ✅ Easy to configure
- ✅ Runtime validation
- ✅ JSON-like structure

**Cons:**

- ❌ Runtime errors
- ❌ No compile-time checking
- ❌ Performance overhead
- ❌ Complex setup

## 8. Recommended Approach

### 8.1 For Small to Medium Projects

**Use Enum Approach:**

```dart
enum ButtonVariant {
  primary,
  secondary,
  outline,
  text,
}

enum ButtonSize {
  small,
  medium,
  large,
}
```

### 8.2 For Large Projects

**Use Extension-Based Approach:**

```dart
enum ButtonVariant {
  primary,
  secondary,
  outline,
  text,
}

extension ButtonVariantExtension on ButtonVariant {
  Color get backgroundColor { /* ... */ }
  Color get foregroundColor { /* ... */ }
}
```

### 8.3 For Dynamic Projects

**Use Variant Registry:**

```dart
class VariantRegistry {
  static final Map<String, Map<String, dynamic>> _variants = {
    // Configuration
  };
}
```

## 9. Best Practices

### 9.1 Naming Conventions

- Use descriptive names: `ButtonVariant.primary` not `ButtonVariant.p`
- Be consistent: All variants follow same pattern
- Use lowercase for enum values
- Use camelCase for const values

### 9.2 Validation

- Always validate variants at compile-time when possible
- Provide meaningful error messages
- Use assertions for development
- Handle unknown variants gracefully

### 9.3 Documentation

- Document all available variants
- Provide usage examples
- Explain variant differences
- Keep documentation updated

### 9.4 Testing

- Test all variant combinations
- Test invalid variants
- Test edge cases
- Test performance

## 10. Migration Strategy

### 10.1 From String to Enum

```dart
// Before
AppButton(
  variant: 'primary', // String - error prone
  size: 'medium',
)

// After
AppButton(
  variant: ButtonVariant.primary, // Enum - type safe
  size: ButtonSize.medium,
)
```

### 10.2 Gradual Migration

1. **Phase 1**: Create enum types
2. **Phase 2**: Update component APIs
3. **Phase 3**: Update usage throughout app
4. **Phase 4**: Remove string support

## Conclusion

**Enum-based approach** là tốt nhất cho hầu hết trường hợp:

- ✅ Type safe
- ✅ Compile-time checking
- ✅ IDE autocomplete
- ✅ Easy to maintain
- ✅ Good performance

**Extension-based approach** cho projects lớn:

- ✅ Clean API
- ✅ Type safe
- ✅ Easy to extend
- ✅ Good performance

Tránh dùng string variants để giảm lỗi và tăng type safety! 🎯
