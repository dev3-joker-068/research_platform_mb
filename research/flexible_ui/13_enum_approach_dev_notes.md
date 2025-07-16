# Enum Approach - Developer Notes & Conventions

## Overview

Chuẩn và convention cho Enum Approach để đảm bảo consistency và maintainability trong team development.

## 1. Naming Conventions

### 1.1 Enum Naming Rules

#### Component Variants

```dart
// ✅ CORRECT - Clear, descriptive names
enum ButtonVariant {
  primary,
  secondary,
  outline,
  text,
  danger,
  success,
  warning,
}

enum TextVariant {
  h1, h2, h3, h4, h5, h6,
  body, bodySmall, caption, overline,
}

enum InputVariant {
  outlined,
  filled,
  underlined,
}

// ❌ WRONG - Vague or inconsistent names
enum ButtonType { // Don't use "Type"
  normal, // Too vague
  special, // Too vague
  custom, // Too vague
}

enum TextStyle { // Don't use "Style"
  big, // Too informal
  small, // Too informal
  medium, // Too informal
}
```

#### Size Variants

```dart
// ✅ CORRECT - Consistent size naming
enum ButtonSize {
  xs,    // Extra small
  sm,    // Small
  md,    // Medium
  lg,    // Large
  xl,    // Extra large
}

enum SpacingSize {
  none,  // No spacing
  xs,    // Extra small
  sm,    // Small
  md,    // Medium
  lg,    // Large
  xl,    // Extra large
  xxl,   // Extra extra large
}

// ❌ WRONG - Inconsistent naming
enum ButtonSize {
  tiny,    // Inconsistent with other components
  small,   // Use "sm" instead
  medium,  // Use "md" instead
  large,   // Use "lg" instead
  huge,    // Inconsistent with other components
}
```

### 1.2 File Naming Rules

#### File Structure

```
lib/
├── components/
│   ├── atoms/
│   │   ├── app_button.dart
│   │   ├── app_text.dart
│   │   └── app_input.dart
│   ├── molecules/
│   │   ├── search_bar.dart
│   │   └── form_field.dart
│   └── organisms/
│       ├── app_header.dart
│       └── login_form.dart
├── variants/
│   ├── button_variants.dart
│   ├── text_variants.dart
│   ├── input_variants.dart
│   └── spacing_variants.dart
└── theme/
    ├── app_colors.dart
    ├── app_spacing.dart
    └── app_typography.dart
```

#### File Naming

```dart
// ✅ CORRECT - Descriptive file names
button_variants.dart
text_variants.dart
input_variants.dart
spacing_variants.dart

// ❌ WRONG - Generic or unclear names
variants.dart
types.dart
enums.dart
```

## 2. Enum Definition Standards

### 2.1 Basic Enum Structure

```dart
// ✅ CORRECT - Well-structured enum
enum ButtonVariant {
  // Primary variants
  primary,
  secondary,

  // Style variants
  outline,
  text,

  // Status variants
  danger,
  success,
  warning,

  // Add comments for complex variants
  // Custom variant for special use cases
  custom,
}

// ✅ CORRECT - With documentation
/// Defines the visual style variants for buttons
enum ButtonVariant {
  /// Primary button style - solid background with primary color
  primary,

  /// Secondary button style - outlined with primary color
  secondary,

  /// Outline button style - transparent with border
  outline,

  /// Text button style - no background or border
  text,

  /// Danger button style - red color for destructive actions
  danger,

  /// Success button style - green color for positive actions
  success,

  /// Warning button style - orange color for caution actions
  warning,
}
```

### 2.2 Enum Organization Rules

#### Group Related Variants

```dart
// ✅ CORRECT - Logical grouping
enum ButtonVariant {
  // Primary actions
  primary,
  secondary,

  // Alternative styles
  outline,
  text,

  // Status indicators
  danger,
  success,
  warning,

  // Special cases
  ghost,
  link,
}

// ❌ WRONG - No logical grouping
enum ButtonVariant {
  primary,
  danger,
  outline,
  success,
  text,
  warning,
  secondary,
}
```

#### Consistent Order

```dart
// ✅ CORRECT - Consistent ordering across components
enum ButtonVariant {
  primary,    // Always first
  secondary,  // Always second
  outline,    // Alternative style
  text,       // Minimal style
  danger,     // Status variants
  success,
  warning,
}

enum CardVariant {
  elevated,   // Always first
  outlined,   // Always second
  filled,     // Alternative style
  ghost,      // Minimal style
}
```

## 3. Component Implementation Standards

### 3.1 Enum Usage in Components

```dart
// ✅ CORRECT - Proper enum usage
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
    this.variant = ButtonVariant.primary,  // Default value
    this.size = ButtonSize.md,             // Default value
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildButton();
  }

  Widget _buildButton() {
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

  // Individual build methods for each variant
  Widget _buildPrimaryButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: _buildButtonChild(),
    );
  }

  Widget _buildSecondaryButton() {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: _getPadding(),
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: _buildButtonChild(),
    );
  }

  // ... other build methods

  Widget _buildButtonChild() {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getTextColor(),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(text, style: _getTextStyle()),
      ],
    );
  }

  // Helper methods
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

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.xs:
        return AppTypography.caption;
      case ButtonSize.sm:
        return AppTypography.bodySmall;
      case ButtonSize.md:
        return AppTypography.body;
      case ButtonSize.lg:
        return AppTypography.h3;
      case ButtonSize.xl:
        return AppTypography.h2;
    }
  }

  Color _getTextColor() {
    switch (variant) {
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

  double _getIconSize() {
    switch (size) {
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
```

### 3.2 Switch Statement Rules

```dart
// ✅ CORRECT - Exhaustive switch with all cases
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

// ❌ WRONG - Missing cases or using default
switch (variant) {
  case ButtonVariant.primary:
    return _buildPrimaryButton();
  case ButtonVariant.secondary:
    return _buildSecondaryButton();
  default: // Don't use default - be explicit
    return _buildPrimaryButton();
}
```

## 4. Extension Methods Standards

### 4.1 Extension Structure

```dart
// ✅ CORRECT - Well-organized extensions
extension ButtonVariantExtension on ButtonVariant {
  /// Returns the background color for this button variant
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

  /// Returns the foreground color for this button variant
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

  /// Returns the border side for this button variant
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

  /// Returns the semantic label for accessibility
  String get semanticLabel {
    switch (this) {
      case ButtonVariant.primary:
        return 'Primary button';
      case ButtonVariant.secondary:
        return 'Secondary button';
      case ButtonVariant.outline:
        return 'Outline button';
      case ButtonVariant.text:
        return 'Text button';
      case ButtonVariant.danger:
        return 'Danger button';
      case ButtonVariant.success:
        return 'Success button';
      case ButtonVariant.warning:
        return 'Warning button';
    }
  }
}

extension ButtonSizeExtension on ButtonSize {
  /// Returns the padding for this button size
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

  /// Returns the font size for this button size
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

  /// Returns the icon size for this button size
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
```

## 5. Usage Standards

### 5.1 Component Usage

```dart
// ✅ CORRECT - Proper usage with enums
AppButton(
  text: 'Click Me',
  variant: ButtonVariant.primary,
  size: ButtonSize.md,
  onPressed: () => print('Button clicked'),
  icon: Icons.add,
)

// ✅ CORRECT - Using extensions
AppButton(
  text: 'Submit',
  variant: ButtonVariant.success,
  size: ButtonSize.lg,
  onPressed: () => _handleSubmit(),
)

// ❌ WRONG - Using strings
AppButton(
  text: 'Click Me',
  variant: 'primary', // Don't use strings
  size: 'medium',     // Don't use strings
  onPressed: () {},
)
```

### 5.2 Conditional Usage

```dart
// ✅ CORRECT - Conditional variant selection
AppButton(
  text: 'Save',
  variant: _isDangerous ? ButtonVariant.danger : ButtonVariant.primary,
  size: _isLarge ? ButtonSize.lg : ButtonSize.md,
  onPressed: _handleSave,
)

// ✅ CORRECT - Using helper methods
AppButton(
  text: 'Delete',
  variant: _getButtonVariant(),
  size: _getButtonSize(),
  onPressed: _handleDelete,
)

ButtonVariant _getButtonVariant() {
  if (_isDangerous) return ButtonVariant.danger;
  if (_isSuccess) return ButtonVariant.success;
  return ButtonVariant.primary;
}

ButtonSize _getButtonSize() {
  if (_isLarge) return ButtonSize.lg;
  if (_isSmall) return ButtonSize.sm;
  return ButtonSize.md;
}
```

## 6. Testing Standards

### 6.1 Enum Testing

```dart
// ✅ CORRECT - Test all enum values
group('ButtonVariant', () {
  test('should have correct background colors', () {
    expect(ButtonVariant.primary.backgroundColor, AppColors.primary);
    expect(ButtonVariant.secondary.backgroundColor, Colors.transparent);
    expect(ButtonVariant.outline.backgroundColor, Colors.transparent);
    expect(ButtonVariant.text.backgroundColor, Colors.transparent);
    expect(ButtonVariant.danger.backgroundColor, AppColors.error);
    expect(ButtonVariant.success.backgroundColor, AppColors.success);
    expect(ButtonVariant.warning.backgroundColor, AppColors.warning);
  });

  test('should have correct foreground colors', () {
    expect(ButtonVariant.primary.foregroundColor, Colors.white);
    expect(ButtonVariant.secondary.foregroundColor, AppColors.primary);
    expect(ButtonVariant.outline.foregroundColor, AppColors.primary);
    expect(ButtonVariant.text.foregroundColor, AppColors.primary);
    expect(ButtonVariant.danger.foregroundColor, Colors.white);
    expect(ButtonVariant.success.foregroundColor, Colors.white);
    expect(ButtonVariant.warning.foregroundColor, Colors.white);
  });

  test('should have correct border sides', () {
    expect(ButtonVariant.primary.borderSide, isNull);
    expect(ButtonVariant.secondary.borderSide, isNotNull);
    expect(ButtonVariant.outline.borderSide, isNull);
    expect(ButtonVariant.text.borderSide, isNull);
  });
});

group('ButtonSize', () {
  test('should have correct padding', () {
    expect(ButtonSize.xs.padding, isA<EdgeInsets>());
    expect(ButtonSize.sm.padding, isA<EdgeInsets>());
    expect(ButtonSize.md.padding, isA<EdgeInsets>());
    expect(ButtonSize.lg.padding, isA<EdgeInsets>());
    expect(ButtonSize.xl.padding, isA<EdgeInsets>());
  });

  test('should have correct font sizes', () {
    expect(ButtonSize.xs.fontSize, 12.0);
    expect(ButtonSize.sm.fontSize, 14.0);
    expect(ButtonSize.md.fontSize, 16.0);
    expect(ButtonSize.lg.fontSize, 18.0);
    expect(ButtonSize.xl.fontSize, 20.0);
  });
});
```

### 6.2 Component Testing

```dart
// ✅ CORRECT - Test component with different variants
group('AppButton', () {
  testWidgets('should render primary button correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'Test',
            variant: ButtonVariant.primary,
            size: ButtonSize.md,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('should render secondary button correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'Test',
            variant: ButtonVariant.secondary,
            size: ButtonSize.md,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
  });

  testWidgets('should handle all variants', (tester) async {
    for (final variant in ButtonVariant.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test',
              variant: variant,
              size: ButtonSize.md,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    }
  });
});
```

## 7. Documentation Standards

### 7.1 Enum Documentation

```dart
/// Defines the visual style variants for buttons
///
/// Each variant represents a different visual style and use case:
/// - [primary]: Main action buttons with solid background
/// - [secondary]: Alternative actions with outlined style
/// - [outline]: Subtle actions with border only
/// - [text]: Minimal actions with no background or border
/// - [danger]: Destructive actions with red styling
/// - [success]: Positive actions with green styling
/// - [warning]: Caution actions with orange styling
enum ButtonVariant {
  /// Primary button style - solid background with primary color
  /// Used for main actions like "Submit", "Save", "Continue"
  primary,

  /// Secondary button style - outlined with primary color
  /// Used for alternative actions like "Cancel", "Back"
  secondary,

  /// Outline button style - transparent with border
  /// Used for subtle actions that don't compete with primary actions
  outline,

  /// Text button style - no background or border
  /// Used for minimal actions like "Learn more", "Skip"
  text,

  /// Danger button style - red color for destructive actions
  /// Used for actions like "Delete", "Remove", "Cancel subscription"
  danger,

  /// Success button style - green color for positive actions
  /// Used for actions like "Confirm", "Approve", "Activate"
  success,

  /// Warning button style - orange color for caution actions
  /// Used for actions that require user attention
  warning,
}
```

### 7.2 Extension Documentation

```dart
/// Extension methods for [ButtonVariant] to provide styling properties
extension ButtonVariantExtension on ButtonVariant {
  /// Returns the background color for this button variant
  ///
  /// The background color is used to fill the button's background.
  /// For transparent variants like [outline] and [text], this returns
  /// [Colors.transparent].
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

  /// Returns the foreground color for this button variant
  ///
  /// The foreground color is used for text and icons within the button.
  /// This ensures proper contrast with the background color.
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
}
```

## 8. Migration Guidelines

### 8.1 From String to Enum

```dart
// Before (String-based)
class AppButton extends StatelessWidget {
  final String variant; // String - error prone

  const AppButton({
    this.variant = 'primary',
  });
}

// After (Enum-based)
class AppButton extends StatelessWidget {
  final ButtonVariant variant; // Enum - type safe

  const AppButton({
    this.variant = ButtonVariant.primary,
  });
}
```

### 8.2 Migration Steps

1. **Create Enum**: Define the enum with all variants
2. **Update Component**: Change component to use enum
3. **Add Extensions**: Create extension methods for styling
4. **Update Usage**: Replace string usage with enum usage
5. **Add Tests**: Test all enum values and combinations
6. **Document**: Add comprehensive documentation

## 9. Best Practices Summary

### 9.1 Do's

- ✅ Use descriptive enum names (ButtonVariant, not ButtonType)
- ✅ Group related variants logically
- ✅ Provide default values for enums
- ✅ Use exhaustive switch statements
- ✅ Create extension methods for styling
- ✅ Test all enum values
- ✅ Document enum purpose and usage
- ✅ Use consistent naming across components

### 9.2 Don'ts

- ❌ Don't use strings for variants
- ❌ Don't use default cases in switch statements
- ❌ Don't skip testing enum values
- ❌ Don't use vague or inconsistent names
- ❌ Don't forget to document enum usage
- ❌ Don't mix different naming conventions

### 9.3 Team Guidelines

- **Code Review**: Always review enum usage in code reviews
- **Documentation**: Keep documentation updated with new variants
- **Testing**: Ensure all variants are tested
- **Consistency**: Follow naming conventions consistently
- **Refactoring**: Refactor when adding new variants

## 10. Checklist for New Variants

### 10.1 Before Adding New Variant

- [ ] Is the variant really needed?
- [ ] Does it follow naming conventions?
- [ ] Is it logically grouped with existing variants?
- [ ] Are there similar variants in other components?

### 10.2 When Adding New Variant

- [ ] Add to enum with proper documentation
- [ ] Add to switch statements in components
- [ ] Add extension methods for styling
- [ ] Add tests for new variant
- [ ] Update documentation
- [ ] Update examples and usage

### 10.3 After Adding New Variant

- [ ] Test all combinations with other variants
- [ ] Verify accessibility features
- [ ] Check performance impact
- [ ] Update design system documentation
- [ ] Share with team members

Following these conventions ensures consistency, maintainability, and type safety across the entire codebase! 🎯
