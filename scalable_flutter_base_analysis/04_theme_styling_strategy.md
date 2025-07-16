# Chiến Lược Theme & Styling - Flutter Base Source

## Triết Lý Thiết Kế Theme

### Design System Approach

```
Design Tokens (Atomic Level)
├── Colors, Typography, Spacing
├── Border Radius, Shadows, Animations
└── Semantic Values

Component Themes (Component Level)
├── Button Theme, Card Theme
├── Input Field Theme, Navigation Theme
└── Feature-specific Themes

App Themes (Application Level)
├── Light Theme, Dark Theme
├── Brand Themes, Seasonal Themes
└── Accessibility Themes
```

### Multi-Brand Support

- **White-label Ready**: Dễ dàng rebrand cho client khác
- **Dynamic Theming**: Thay đổi theme runtime
- **A/B Testing**: Test multiple theme variants
- **Seasonal Themes**: Holiday, special events themes

## Theme Architecture

### 1. Design Token System

```dart
class AppDesignTokens {
  // Color Tokens
  static const primaryColors = AppColorTokens(
    primary50: Color(0xFFF0F9FF),
    primary100: Color(0xFFE0F2FE),
    primary200: Color(0xFFBAE6FD),
    primary300: Color(0xFF7DD3FC),
    primary400: Color(0xFF38BDF8),
    primary500: Color(0xFF0EA5E9), // Base primary
    primary600: Color(0xFF0284C7),
    primary700: Color(0xFF0369A1),
    primary800: Color(0xFF075985),
    primary900: Color(0xFF0C4A6E),
  );

  // Typography Tokens
  static const textTokens = AppTextTokens(
    fontFamily: 'Inter',
    headlineFont: 'Poppins',
    monoFont: 'JetBrains Mono',

    // Font Sizes
    xs: 12.0,
    sm: 14.0,
    base: 16.0,
    lg: 18.0,
    xl: 20.0,
    xl2: 24.0,
    xl3: 30.0,
    xl4: 36.0,
    xl5: 48.0,
    xl6: 60.0,
  );

  // Spacing Tokens
  static const spacingTokens = AppSpacingTokens(
    xs: 4.0,
    sm: 8.0,
    md: 16.0,
    lg: 24.0,
    xl: 32.0,
    xl2: 48.0,
    xl3: 64.0,
    xl4: 96.0,
  );

  // Border Radius Tokens
  static const radiusTokens = AppRadiusTokens(
    none: 0.0,
    sm: 4.0,
    md: 8.0,
    lg: 12.0,
    xl: 16.0,
    full: 9999.0,
  );
}
```

### 2. Semantic Color System

```dart
class AppSemanticColors {
  // Brand Colors
  final Color primary;
  final Color secondary;
  final Color accent;

  // Functional Colors
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  // Neutral Colors
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color onSurface;
  final Color onSurfaceVariant;

  // Text Colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;

  // Border Colors
  final Color border;
  final Color borderStrong;
  final Color borderSubtle;

  // Interaction Colors
  final Color hover;
  final Color pressed;
  final Color focused;
  final Color selected;
  final Color disabled;
}
```

### 3. Typography System

```dart
class AppTypography {
  // Display Text Styles
  static TextStyle get displayLarge => TextStyle(
    fontFamily: AppDesignTokens.textTokens.headlineFont,
    fontSize: AppDesignTokens.textTokens.xl6,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );

  static TextStyle get displayMedium => TextStyle(
    fontFamily: AppDesignTokens.textTokens.headlineFont,
    fontSize: AppDesignTokens.textTokens.xl5,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Headline Text Styles
  static TextStyle get headlineLarge => TextStyle(
    fontFamily: AppDesignTokens.textTokens.headlineFont,
    fontSize: AppDesignTokens.textTokens.xl4,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static TextStyle get headlineMedium => TextStyle(
    fontFamily: AppDesignTokens.textTokens.headlineFont,
    fontSize: AppDesignTokens.textTokens.xl3,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // Body Text Styles
  static TextStyle get bodyLarge => TextStyle(
    fontFamily: AppDesignTokens.textTokens.fontFamily,
    fontSize: AppDesignTokens.textTokens.lg,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: AppDesignTokens.textTokens.fontFamily,
    fontSize: AppDesignTokens.textTokens.base,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: AppDesignTokens.textTokens.fontFamily,
    fontSize: AppDesignTokens.textTokens.sm,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // Label Text Styles
  static TextStyle get labelLarge => TextStyle(
    fontFamily: AppDesignTokens.textTokens.fontFamily,
    fontSize: AppDesignTokens.textTokens.base,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle get labelMedium => TextStyle(
    fontFamily: AppDesignTokens.textTokens.fontFamily,
    fontSize: AppDesignTokens.textTokens.sm,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static TextStyle get labelSmall => TextStyle(
    fontFamily: AppDesignTokens.textTokens.fontFamily,
    fontSize: AppDesignTokens.textTokens.xs,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
}
```

## Theme Configuration System

### 1. Theme Builder Pattern

```dart
class AppThemeBuilder {
  late AppSemanticColors _colors;
  late AppTypography _typography;
  late AppSpacing _spacing;
  late AppBorderRadius _borderRadius;

  AppThemeBuilder.light() {
    _colors = AppLightColors();
    // ... other light theme properties
  }

  AppThemeBuilder.dark() {
    _colors = AppDarkColors();
    // ... other dark theme properties
  }

  AppThemeBuilder.custom(AppThemeConfig config) {
    _colors = config.colors;
    // ... other custom properties
  }

  // Customization methods
  AppThemeBuilder withPrimaryColor(Color color) {
    _colors = _colors.copyWith(primary: color);
    return this;
  }

  AppThemeBuilder withTypography(AppTypography typography) {
    _typography = typography;
    return this;
  }

  AppThemeBuilder withBrandColors(BrandColorPalette brand) {
    _colors = _colors.copyWith(
      primary: brand.primary,
      secondary: brand.secondary,
      accent: brand.accent,
    );
    return this;
  }

  ThemeData build() {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: _colors.primary,
        secondary: _colors.secondary,
        // ... map to Material Design colors
      ),
      textTheme: TextTheme(
        displayLarge: _typography.displayLarge,
        displayMedium: _typography.displayMedium,
        // ... complete text theme mapping
      ),
      extensions: [
        AppColors(_colors),
        AppTextStyles(_typography),
        AppSpacingTheme(_spacing),
        AppBorderRadiusTheme(_borderRadius),
      ],
    );
  }
}
```

### 2. Configuration-Driven Themes

```dart
class AppThemeConfig {
  final String name;
  final String description;
  final AppSemanticColors colors;
  final AppTypography typography;
  final AppSpacing spacing;
  final AppBorderRadius borderRadius;
  final AppShadows shadows;
  final AppAnimations animations;

  // Brand-specific configurations
  final String? logoPath;
  final String? brandName;
  final Map<String, dynamic>? customProperties;
}

// JSON Configuration Example
const themeConfig = {
  "name": "Brand A Theme",
  "description": "Custom theme for Brand A",
  "colors": {
    "primary": "#FF6B6B",
    "secondary": "#4ECDC4",
    "accent": "#45B7D1",
    // ... more colors
  },
  "typography": {
    "fontFamily": "Roboto",
    "headlineFont": "Poppins",
    "baseFontSize": 16,
    // ... more typography settings
  },
  "spacing": {
    "scale": 1.2,
    "baseUnit": 8,
  },
  "branding": {
    "logoPath": "assets/images/brand_a_logo.png",
    "brandName": "Brand A",
  }
};
```

### 3. Dynamic Theme Switching

```dart
class ThemeManager extends ChangeNotifier {
  ThemeData _currentTheme;
  ThemeMode _themeMode;
  String _currentThemeId;

  // Available themes
  final Map<String, AppThemeConfig> _availableThemes = {};

  // Load theme from configuration
  Future<void> loadTheme(String themeId) async {
    final config = await _loadThemeConfig(themeId);
    _currentTheme = AppThemeBuilder.custom(config).build();
    _currentThemeId = themeId;
    notifyListeners();
  }

  // Switch between light/dark
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Apply brand colors
  void applyBrandColors(BrandColorPalette brand) {
    _currentTheme = AppThemeBuilder
        .fromExisting(_currentTheme)
        .withBrandColors(brand)
        .build();
    notifyListeners();
  }

  // Runtime color updates
  void updatePrimaryColor(Color color) {
    _currentTheme = AppThemeBuilder
        .fromExisting(_currentTheme)
        .withPrimaryColor(color)
        .build();
    notifyListeners();
  }
}
```

## Component Theme Extensions

### 1. Custom Theme Extensions

```dart
class AppButtonTheme extends ThemeExtension<AppButtonTheme> {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color disabledColor;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final double elevation;
  final Duration animationDuration;

  @override
  AppButtonTheme copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    // ... other properties
  }) {
    return AppButtonTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      // ... other properties
    );
  }

  @override
  AppButtonTheme lerp(ThemeExtension<AppButtonTheme>? other, double t) {
    if (other is! AppButtonTheme) return this;

    return AppButtonTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      // ... lerp other properties
    );
  }
}
```

### 2. Theme-Aware Components

```dart
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonTheme = theme.extension<AppButtonTheme>()!;
    final colors = theme.extension<AppColors>()!;

    Color getBackgroundColor() {
      switch (variant) {
        case AppButtonVariant.primary:
          return colors.primary;
        case AppButtonVariant.secondary:
          return colors.secondary;
        case AppButtonVariant.outlined:
          return Colors.transparent;
      }
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: getBackgroundColor(),
        textStyle: buttonTheme.textStyle,
        padding: buttonTheme.padding,
        shape: RoundedRectangleBorder(
          borderRadius: buttonTheme.borderRadius,
        ),
        elevation: buttonTheme.elevation,
      ),
      child: Text(text),
    );
  }
}
```

## Responsive Design Strategy

### 1. Breakpoint System

```dart
class AppBreakpoints {
  static const mobile = 480.0;
  static const tablet = 768.0;
  static const laptop = 1024.0;
  static const desktop = 1440.0;
  static const ultrawide = 1920.0;
}

class ResponsiveTheme {
  static AppSpacing getSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < AppBreakpoints.mobile) {
      return AppSpacing.compact();
    } else if (width < AppBreakpoints.tablet) {
      return AppSpacing.normal();
    } else if (width < AppBreakpoints.laptop) {
      return AppSpacing.comfortable();
    } else {
      return AppSpacing.spacious();
    }
  }

  static AppTypography getTypography(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < AppBreakpoints.mobile) {
      return AppTypography.mobile();
    } else if (width < AppBreakpoints.desktop) {
      return AppTypography.tablet();
    } else {
      return AppTypography.desktop();
    }
  }
}
```

### 2. Adaptive Components

```dart
class AdaptiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveTheme.getSpacing(context);

    return Container(
      padding: padding ?? spacing.medium,
      child: child,
    );
  }
}
```

## Theme Testing Strategy

### 1. Theme Validation

```dart
void validateTheme(ThemeData theme) {
  // Color contrast validation
  assert(
    _hasGoodContrast(theme.primaryColor, theme.backgroundColor),
    'Primary color must have good contrast with background',
  );

  // Accessibility validation
  assert(
    theme.textTheme.bodyMedium!.fontSize! >= 14.0,
    'Body text must be at least 14sp for accessibility',
  );

  // Component theme validation
  final buttonTheme = theme.extension<AppButtonTheme>();
  assert(buttonTheme != null, 'AppButtonTheme must be provided');
}
```

### 2. Visual Regression Testing

```dart
testWidgets('Button theme golden test', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppThemeBuilder.light().build(),
      home: Scaffold(
        body: Column(
          children: [
            AppButton.primary('Primary Button'),
            AppButton.secondary('Secondary Button'),
            AppButton.outlined('Outlined Button'),
          ],
        ),
      ),
    ),
  );

  await expectLater(
    find.byType(Scaffold),
    matchesGoldenFile('button_theme_light.png'),
  );
});
```

## Benefits của Theme System

### 1. Brand Flexibility

- Dễ dàng rebrand cho client khác
- Consistent brand application
- White-label ready

### 2. Design Consistency

- Single source of truth cho design
- Automatic color harmony
- Typography hierarchy

### 3. Developer Experience

- Type-safe theme access
- IntelliSense support
- Clear API design

### 4. Maintenance

- Centralized style updates
- Easy A/B testing
- Version control friendly

### 5. Accessibility

- Built-in contrast checking
- Font size compliance
- Screen reader support

## Implementation Roadmap

### Phase 1: Foundation

- Design token system
- Basic light/dark themes
- Core component themes

### Phase 2: Advanced Features

- Multi-brand support
- Dynamic theme switching
- Configuration system

### Phase 3: Optimization

- Performance optimization
- Testing framework
- Documentation
