# Simple Flexible UI Approaches

## Overview

Các cách tiếp cận đơn giản và thực tế để tạo flexible UI trong Flutter, dễ implement và maintain.

## 1. Simple Style Config Approach

### 1.1 Basic Style Configuration

```dart
// Đơn giản nhất - chỉ cần một class config
class SimpleStyleConfig {
  // Colors
  static Color get primaryColor => const Color(0xFF007AFF);
  static Color get secondaryColor => const Color(0xFF5856D6);
  static Color get backgroundColor => const Color(0xFFFFFFFF);
  static Color get textColor => const Color(0xFF000000);

  // Spacing
  static double get spacingSmall => 8.0;
  static double get spacingMedium => 16.0;
  static double get spacingLarge => 24.0;

  // Border Radius
  static double get borderRadiusSmall => 4.0;
  static double get borderRadiusMedium => 8.0;
  static double get borderRadiusLarge => 12.0;

  // Font Sizes
  static double get fontSizeSmall => 14.0;
  static double get fontSizeMedium => 16.0;
  static double get fontSizeLarge => 18.0;
  static double get fontSizeTitle => 24.0;
}

// Sử dụng đơn giản
class SimpleButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const SimpleButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: SimpleStyleConfig.primaryColor,
        padding: EdgeInsets.all(SimpleStyleConfig.spacingMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SimpleStyleConfig.borderRadiusMedium),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: SimpleStyleConfig.fontSizeMedium,
          color: Colors.white,
        ),
      ),
    );
  }
}
```

### 1.2 Theme-Based Simple Approach

```dart
// Sử dụng Flutter Theme system có sẵn
class SimpleTheme {
  static ThemeData get lightTheme => ThemeData(
    primaryColor: const Color(0xFF007AFF),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF007AFF),
      brightness: Brightness.light,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16.0),
      bodyMedium: TextStyle(fontSize: 14.0),
      titleLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    primaryColor: const Color(0xFF007AFF),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF007AFF),
      brightness: Brightness.dark,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16.0),
      bodyMedium: TextStyle(fontSize: 14.0),
      titleLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    ),
  );
}

// Sử dụng
class SimpleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: SimpleTheme.lightTheme,
      darkTheme: SimpleTheme.darkTheme,
      home: HomePage(),
    );
  }
}
```

## 2. Simple Component Library

### 2.1 Basic Reusable Components

```dart
// Simple Text Field
class SimpleTextField extends StatelessWidget {
  final String? hint;
  final bool isPassword;
  final TextEditingController? controller;

  const SimpleTextField({
    Key? key,
    this.hint,
    this.isPassword = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.all(16.0),
      ),
    );
  }
}

// Simple Button
class SimpleButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? variant; // primary, secondary, outline

  const SimpleButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = 'primary',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case 'secondary':
        return OutlinedButton(
          onPressed: onPressed,
          child: Text(text),
        );
      case 'outline':
        return TextButton(
          onPressed: onPressed,
          child: Text(text),
        );
      default:
        return ElevatedButton(
          onPressed: onPressed,
          child: Text(text),
        );
    }
  }
}

// Simple Card
class SimpleCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const SimpleCard({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
```

### 2.2 Simple Form Builder

```dart
class SimpleFormBuilder {
  static Widget buildLoginForm({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required VoidCallback onLogin,
  }) {
    return Column(
      children: [
        SimpleTextField(
          hint: 'Email',
          controller: emailController,
        ),
        const SizedBox(height: 16),
        SimpleTextField(
          hint: 'Password',
          isPassword: true,
          controller: passwordController,
        ),
        const SizedBox(height: 24),
        SimpleButton(
          text: 'Login',
          onPressed: onLogin,
        ),
      ],
    );
  }

  static Widget buildRegisterForm({
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required VoidCallback onRegister,
  }) {
    return Column(
      children: [
        SimpleTextField(
          hint: 'Full Name',
          controller: nameController,
        ),
        const SizedBox(height: 16),
        SimpleTextField(
          hint: 'Email',
          controller: emailController,
        ),
        const SizedBox(height: 16),
        SimpleTextField(
          hint: 'Password',
          isPassword: true,
          controller: passwordController,
        ),
        const SizedBox(height: 24),
        SimpleButton(
          text: 'Register',
          onPressed: onRegister,
        ),
      ],
    );
  }
}
```

## 3. Simple JSON Config Approach

### 3.1 Basic JSON Configuration

```dart
// Đơn giản hóa JSON config
class SimpleConfig {
  static Map<String, dynamic> get defaultConfig => {
    'colors': {
      'primary': '#007AFF',
      'secondary': '#5856D6',
      'background': '#FFFFFF',
      'text': '#000000',
    },
    'spacing': {
      'small': 8.0,
      'medium': 16.0,
      'large': 24.0,
    },
    'radius': {
      'small': 4.0,
      'medium': 8.0,
      'large': 12.0,
    },
  };

  static Map<String, dynamic> get modernConfig => {
    'colors': {
      'primary': '#6366F1',
      'secondary': '#8B5CF6',
      'background': '#FFFFFF',
      'text': '#1F2937',
    },
    'spacing': {
      'small': 12.0,
      'medium': 20.0,
      'large': 28.0,
    },
    'radius': {
      'small': 6.0,
      'medium': 12.0,
      'large': 16.0,
    },
  };
}

class SimpleConfigManager {
  static Map<String, dynamic> _currentConfig = SimpleConfig.defaultConfig;

  static Map<String, dynamic> get currentConfig => _currentConfig;

  static void setConfig(Map<String, dynamic> config) {
    _currentConfig = config;
  }

  static Color getColor(String key) {
    final colorString = _currentConfig['colors'][key] as String?;
    if (colorString != null) {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    }
    return Colors.black;
  }

  static double getSpacing(String key) {
    return _currentConfig['spacing'][key] as double? ?? 16.0;
  }

  static double getRadius(String key) {
    return _currentConfig['radius'][key] as double? ?? 8.0;
  }
}

// Sử dụng
class ConfigurableButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const ConfigurableButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: SimpleConfigManager.getColor('primary'),
        padding: EdgeInsets.all(SimpleConfigManager.getSpacing('medium')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SimpleConfigManager.getRadius('medium')),
        ),
      ),
      child: Text(text),
    );
  }
}
```

## 4. Simple Theme Switcher

### 4.1 Basic Theme Switching

```dart
class SimpleThemeSwitcher extends StatefulWidget {
  @override
  _SimpleThemeSwitcherState createState() => _SimpleThemeSwitcherState();
}

class _SimpleThemeSwitcherState extends State<SimpleThemeSwitcher> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? _getDarkTheme() : _getLightTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Simple Theme Switcher'),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SimpleTextField(hint: 'Email'),
              const SizedBox(height: 16),
              SimpleTextField(hint: 'Password', isPassword: true),
              const SizedBox(height: 24),
              SimpleButton(
                text: 'Login',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  ThemeData _getLightTheme() {
    return ThemeData(
      primaryColor: const Color(0xFF007AFF),
      brightness: Brightness.light,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007AFF),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  ThemeData _getDarkTheme() {
    return ThemeData(
      primaryColor: const Color(0xFF007AFF),
      brightness: Brightness.dark,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007AFF),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
```

## 5. Simple Responsive Design

### 5.1 Basic Responsive Components

```dart
class SimpleResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const SimpleResponsiveWidget({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobile;
        } else if (constraints.maxWidth < 1200) {
          return tablet ?? mobile;
        } else {
          return desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}

// Sử dụng
class ResponsiveLoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleResponsiveWidget(
      mobile: _buildMobileForm(),
      tablet: _buildTabletForm(),
      desktop: _buildDesktopForm(),
    );
  }

  Widget _buildMobileForm() {
    return Column(
      children: [
        SimpleTextField(hint: 'Email'),
        const SizedBox(height: 16),
        SimpleTextField(hint: 'Password', isPassword: true),
        const SizedBox(height: 24),
        SimpleButton(text: 'Login', onPressed: () {}),
      ],
    );
  }

  Widget _buildTabletForm() {
    return Row(
      children: [
        Expanded(child: SimpleTextField(hint: 'Email')),
        const SizedBox(width: 16),
        Expanded(child: SimpleTextField(hint: 'Password', isPassword: true)),
        const SizedBox(width: 16),
        SimpleButton(text: 'Login', onPressed: () {}),
      ],
    );
  }

  Widget _buildDesktopForm() {
    return Row(
      children: [
        Expanded(flex: 2, child: SimpleTextField(hint: 'Email')),
        const SizedBox(width: 16),
        Expanded(flex: 2, child: SimpleTextField(hint: 'Password', isPassword: true)),
        const SizedBox(width: 16),
        Expanded(child: SimpleButton(text: 'Login', onPressed: () {})),
      ],
    );
  }
}
```

## 6. Simple Animation

### 6.1 Basic Animation Components

```dart
class SimpleAnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;

  const SimpleAnimatedButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  _SimpleAnimatedButtonState createState() => _SimpleAnimatedButtonState();
}

class _SimpleAnimatedButtonState extends State<SimpleAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: SimpleButton(
              text: widget.text,
              onPressed: widget.onPressed,
            ),
          );
        },
      ),
    );
  }
}
```

## 7. Simple Usage Examples

### 7.1 Complete Login Screen

```dart
class SimpleLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            SimpleTextField(hint: 'Email'),
            const SizedBox(height: 16),
            SimpleTextField(hint: 'Password', isPassword: true),
            const SizedBox(height: 24),
            SimpleAnimatedButton(
              text: 'Login',
              onPressed: () {
                // Handle login
              },
            ),
            const SizedBox(height: 16),
            SimpleButton(
              text: 'Forgot Password?',
              variant: 'outline',
              onPressed: () {
                // Handle forgot password
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

### 7.2 Simple Form Builder

```dart
class SimpleFormBuilder {
  static Widget buildForm({
    required List<Map<String, dynamic>> fields,
    required String submitText,
    required VoidCallback onSubmit,
  }) {
    return Column(
      children: [
        ...fields.map((field) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SimpleTextField(
              hint: field['hint'],
              isPassword: field['isPassword'] ?? false,
            ),
          );
        }).toList(),
        const SizedBox(height: 24),
        SimpleButton(
          text: submitText,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}

// Sử dụng
Widget buildLoginForm() {
  return SimpleFormBuilder.buildForm(
    fields: [
      {'hint': 'Email'},
      {'hint': 'Password', 'isPassword': true},
    ],
    submitText: 'Login',
    onSubmit: () {
      // Handle login
    },
  );
}
```

## 8. Benefits of Simple Approach

### 8.1 Development Benefits

- ✅ **Easy to Understand**: Code đơn giản, dễ đọc
- ✅ **Quick Implementation**: Implement nhanh chóng
- ✅ **Low Learning Curve**: Ít phức tạp, dễ học
- ✅ **Easy Maintenance**: Dễ maintain và debug

### 8.2 Flexibility Benefits

- ✅ **Theme Switching**: Dễ dàng chuyển đổi theme
- ✅ **Responsive Design**: Hỗ trợ responsive đơn giản
- ✅ **Animation**: Animation cơ bản
- ✅ **Configurable**: Có thể config thông qua JSON

### 8.3 Practical Benefits

- ✅ **Real-world Ready**: Sẵn sàng cho production
- ✅ **Team Friendly**: Dễ dàng cho team làm việc
- ✅ **Performance**: Performance tốt
- ✅ **Scalable**: Có thể mở rộng khi cần

## 9. When to Use Simple Approach

### 9.1 Perfect For

- **Small to Medium Projects**: Dự án nhỏ và vừa
- **Quick Prototypes**: Prototype nhanh
- **Learning Projects**: Dự án học tập
- **MVP Development**: Phát triển MVP
- **Small Teams**: Team nhỏ

### 9.2 Not Ideal For

- **Large Enterprise Apps**: Ứng dụng enterprise lớn
- **Complex Design Systems**: Design system phức tạp
- **Multiple Brands**: Nhiều brand khác nhau
- **Advanced Customization**: Customization phức tạp

## 10. Migration Path

### 10.1 Start Simple

1. **Begin with Basic Components**: Bắt đầu với components cơ bản
2. **Use Flutter Theme**: Sử dụng Flutter Theme system
3. **Add Simple Config**: Thêm config đơn giản
4. **Gradual Enhancement**: Tăng cường dần dần

### 10.2 Scale When Needed

1. **Monitor Complexity**: Theo dõi độ phức tạp
2. **Identify Pain Points**: Xác định điểm khó khăn
3. **Gradual Migration**: Migrate dần dần
4. **Keep It Simple**: Luôn giữ đơn giản

## Conclusion

Simple approach cung cấp:

1. **Simplicity**: Đơn giản, dễ hiểu
2. **Speed**: Implement nhanh chóng
3. **Maintainability**: Dễ maintain
4. **Flexibility**: Vẫn có tính linh hoạt
5. **Practical**: Thực tế và sử dụng được

Đôi khi đơn giản là tốt nhất! 🎯
