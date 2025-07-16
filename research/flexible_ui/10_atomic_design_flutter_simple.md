# Atomic Design trong Flutter - Simple Flexible UI

## Overview

Atomic Design là một phương pháp thiết kế UI được tạo bởi Brad Frost, chia UI thành 5 cấp độ: Atoms, Molecules, Organisms, Templates, và Pages. Áp dụng vào Flutter để tạo flexible UI một cách đơn giản.

## 1. Atomic Design Fundamentals

### 1.1 5 Cấp độ của Atomic Design

#### Atoms (Nguyên tử)

- **Định nghĩa**: Components nhỏ nhất, không thể chia nhỏ hơn
- **Ví dụ**: Button, Text, Icon, Input field
- **Đặc điểm**: Reusable, không có business logic

#### Molecules (Phân tử)

- **Định nghĩa**: Kết hợp nhiều atoms
- **Ví dụ**: Search bar (input + button), Form field (label + input)
- **Đặc điểm**: Có chức năng cụ thể, reusable

#### Organisms (Sinh vật)

- **Định nghĩa**: Kết hợp molecules và atoms
- **Ví dụ**: Header, Footer, Product list, Login form
- **Đặc điểm**: Có business logic, complex functionality

#### Templates (Mẫu)

- **Định nghĩa**: Layout structure cho pages
- **Ví dụ**: Page layout, Grid system
- **Đặc điểm**: Không có real content, chỉ là structure

#### Pages (Trang)

- **Định nghĩa**: Instances của templates với real content
- **Ví dụ**: Home page, Login page, Product detail page
- **Đặc điểm**: Có real data, specific content

### 1.2 Benefits trong Flutter

- ✅ **Reusability**: Components có thể tái sử dụng
- ✅ **Consistency**: UI nhất quán
- ✅ **Maintainability**: Dễ maintain và update
- ✅ **Scalability**: Dễ mở rộng
- ✅ **Testing**: Dễ test từng component
- ✅ **Flexibility**: Dễ customize và thay đổi

## 2. Simple Atomic Design Implementation

### 2.1 Folder Structure

```
lib/
├── components/
│   ├── atoms/
│   │   ├── app_button.dart
│   │   ├── app_text.dart
│   │   ├── app_icon.dart
│   │   └── app_input.dart
│   ├── molecules/
│   │   ├── search_bar.dart
│   │   ├── form_field.dart
│   │   └── card_item.dart
│   ├── organisms/
│   │   ├── app_header.dart
│   │   ├── login_form.dart
│   │   └── product_list.dart
│   └── templates/
│       ├── page_template.dart
│       └── form_template.dart
├── pages/
│   ├── home_page.dart
│   ├── login_page.dart
│   └── product_page.dart
└── theme/
    ├── app_colors.dart
    ├── app_spacing.dart
    └── app_typography.dart
```

### 2.2 Simple Theme System

```dart
// app_colors.dart
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF007AFF);
  static const Color primaryLight = Color(0xFF4DA3FF);
  static const Color primaryDark = Color(0xFF0056CC);

  // Secondary Colors
  static const Color secondary = Color(0xFF5856D6);
  static const Color secondaryLight = Color(0xFF7B79E6);
  static const Color secondaryDark = Color(0xFF3D3B9E);

  // Neutral Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color text = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6C757D);

  // Status Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);
}

// app_spacing.dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// app_typography.dart
class AppTypography {
  static const TextStyle h1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16.0,
    color: AppColors.text,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14.0,
    color: AppColors.textSecondary,
  );
}
```

## 3. Atoms Implementation

### 3.1 AppButton (Atom)

```dart
// atoms/app_button.dart
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? variant; // primary, secondary, outline, text
  final String? size; // small, medium, large
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = 'primary',
    this.size = 'medium',
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
      case 'secondary':
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
      case 'outline':
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: buttonSize,
            foregroundColor: AppColors.primary,
          ),
          child: buttonChild,
        );
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
      case 'small':
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case 'large':
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        );
      default:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case 'small':
        return AppTypography.caption;
      case 'large':
        return AppTypography.h3;
      default:
        return AppTypography.body;
    }
  }

  Color _getTextColor() {
    switch (variant) {
      case 'secondary':
      case 'outline':
        return AppColors.primary;
      default:
        return Colors.white;
    }
  }

  double _getIconSize() {
    switch (size) {
      case 'small':
        return 16.0;
      case 'large':
        return 24.0;
      default:
        return 20.0;
    }
  }
}
```

### 3.2 AppText (Atom)

```dart
// atoms/app_text.dart
class AppText extends StatelessWidget {
  final String text;
  final String? variant; // h1, h2, h3, body, caption
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText({
    Key? key,
    required this.text,
    this.variant = 'body',
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _getTextStyle(),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _getTextStyle() {
    final baseStyle = _getBaseStyle();
    return baseStyle.copyWith(
      color: color ?? baseStyle.color,
    );
  }

  TextStyle _getBaseStyle() {
    switch (variant) {
      case 'h1':
        return AppTypography.h1;
      case 'h2':
        return AppTypography.h2;
      case 'h3':
        return AppTypography.h3;
      case 'caption':
        return AppTypography.caption;
      default:
        return AppTypography.body;
    }
  }
}
```

### 3.3 AppInput (Atom)

```dart
// atoms/app_input.dart
class AppInput extends StatelessWidget {
  final String? hint;
  final String? label;
  final TextEditingController? controller;
  final bool isPassword;
  final String? errorText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;

  const AppInput({
    Key? key,
    this.hint,
    this.label,
    this.controller,
    this.isPassword = false,
    this.errorText,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          AppText(
            text: label!,
            variant: 'caption',
            color: AppColors.text,
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
            prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColors.textSecondary)
              : null,
            suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon),
                  onPressed: onSuffixIconPressed,
                  color: AppColors.textSecondary,
                )
              : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.textSecondary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.textSecondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            errorText: errorText,
            contentPadding: const EdgeInsets.all(AppSpacing.md),
          ),
        ),
      ],
    );
  }
}
```

## 4. Molecules Implementation

### 4.1 SearchBar (Molecule)

```dart
// molecules/search_bar.dart
class SearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final VoidCallback? onSearch;
  final VoidCallback? onClear;

  const SearchBar({
    Key? key,
    this.controller,
    this.hint = 'Search...',
    this.onSearch,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppInput(
            controller: controller,
            hint: hint,
            prefixIcon: Icons.search,
            suffixIcon: controller?.text.isNotEmpty == true
              ? Icons.clear
              : null,
            onSuffixIconPressed: onClear,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppButton(
          text: 'Search',
          onPressed: onSearch,
          size: 'small',
        ),
      ],
    );
  }
}
```

### 4.2 FormField (Molecule)

```dart
// molecules/form_field.dart
class FormField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool isRequired;
  final bool isPassword;
  final String? errorText;
  final TextInputType? keyboardType;
  final IconData? icon;

  const FormField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.isRequired = false,
    this.isPassword = false,
    this.errorText,
    this.keyboardType,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText(
              text: label,
              variant: 'caption',
              color: AppColors.text,
            ),
            if (isRequired) ...[
              const SizedBox(width: AppSpacing.xs),
              const AppText(
                text: '*',
                variant: 'caption',
                color: AppColors.error,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        AppInput(
          controller: controller,
          hint: hint,
          isPassword: isPassword,
          errorText: errorText,
          keyboardType: keyboardType,
          prefixIcon: icon,
        ),
      ],
    );
  }
}
```

### 4.3 CardItem (Molecule)

```dart
// molecules/card_item.dart
class CardItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final VoidCallback? onTap;
  final Widget? trailing;

  const CardItem({
    Key? key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              if (imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Icon(
                          Icons.image,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: title,
                      variant: 'h3',
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      AppText(
                        text: subtitle!,
                        variant: 'caption',
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

## 5. Organisms Implementation

### 5.1 AppHeader (Organism)

```dart
// organisms/app_header.dart
class AppHeader extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AppHeader({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (showBackButton) ...[
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
                color: AppColors.text,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: AppText(
                text: title,
                variant: 'h2',
              ),
            ),
            if (actions != null) ...[
              ...actions!,
            ],
          ],
        ),
      ),
    );
  }
}
```

### 5.2 LoginForm (Organism)

```dart
// organisms/login_form.dart
class LoginForm extends StatefulWidget {
  final Function(String email, String password)? onLogin;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onRegister;

  const LoginForm({
    Key? key,
    this.onLogin,
    this.onForgotPassword,
    this.onRegister,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormField(
            label: 'Email',
            hint: 'Enter your email',
            controller: _emailController,
            isRequired: true,
            keyboardType: TextInputType.emailAddress,
            icon: Icons.email,
          ),
          const SizedBox(height: AppSpacing.md),
          FormField(
            label: 'Password',
            hint: 'Enter your password',
            controller: _passwordController,
            isRequired: true,
            isPassword: true,
            icon: Icons.lock,
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgotPassword,
              child: const AppText(
                text: 'Forgot Password?',
                variant: 'caption',
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            text: 'Login',
            onPressed: _handleLogin,
            isLoading: _isLoading,
            icon: Icons.login,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppText(
                text: "Don't have an account? ",
                variant: 'caption',
              ),
              TextButton(
                onPressed: widget.onRegister,
                child: const AppText(
                  text: 'Register',
                  variant: 'caption',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });

      widget.onLogin?.call(
        _emailController.text,
        _passwordController.text,
      );

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
```

### 5.3 ProductList (Organism)

```dart
// organisms/product_list.dart
class ProductList extends StatelessWidget {
  final List<Product> products;
  final Function(Product)? onProductTap;
  final VoidCallback? onLoadMore;
  final bool isLoading;

  const ProductList({
    Key? key,
    required this.products,
    this.onProductTap,
    this.onLoadMore,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: products.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == products.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final product = products[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: CardItem(
                  title: product.name,
                  subtitle: product.description,
                  imageUrl: product.imageUrl,
                  onTap: () => onProductTap?.call(product),
                  trailing: AppText(
                    text: '\$${product.price.toStringAsFixed(2)}',
                    variant: 'h3',
                    color: AppColors.primary,
                  ),
                ),
              );
            },
          ),
        ),
        if (onLoadMore != null && !isLoading) ...[
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppButton(
              text: 'Load More',
              onPressed: onLoadMore,
              variant: 'outline',
            ),
          ),
        ],
      ],
    );
  }
}

// Product model
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
  });
}
```

## 6. Templates Implementation

### 6.1 PageTemplate (Template)

```dart
// templates/page_template.dart
class PageTemplate extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? floatingActionButton;

  const PageTemplate({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: title,
        actions: actions,
        showBackButton: showBackButton,
        onBackPressed: onBackPressed,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
```

### 6.2 FormTemplate (Template)

```dart
// templates/form_template.dart
class FormTemplate extends StatelessWidget {
  final String title;
  final Widget form;
  final String submitText;
  final VoidCallback? onSubmit;
  final bool isLoading;

  const FormTemplate({
    Key? key,
    required this.title,
    required this.form,
    required this.submitText,
    this.onSubmit,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: title,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            AppText(
              text: title,
              variant: 'h1',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            form,
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              text: submitText,
              onPressed: onSubmit,
              isLoading: isLoading,
              size: 'large',
            ),
          ],
        ),
      ),
    );
  }
}
```

## 7. Pages Implementation

### 7.1 HomePage (Page)

```dart
// pages/home_page.dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Home',
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Navigate to search page
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Navigate to notifications
          },
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Welcome Back!',
              variant: 'h1',
            ),
            const SizedBox(height: AppSpacing.md),
            AppText(
              text: 'Discover amazing products',
              variant: 'body',
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.xl),
            SearchBar(
              hint: 'Search products...',
              onSearch: () {
                // Handle search
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            AppText(
              text: 'Featured Products',
              variant: 'h2',
            ),
            const SizedBox(height: AppSpacing.md),
            // Sample products
            ProductList(
              products: [
                Product(
                  id: '1',
                  name: 'Product 1',
                  description: 'Amazing product description',
                  price: 99.99,
                  imageUrl: 'https://via.placeholder.com/150',
                ),
                Product(
                  id: '2',
                  name: 'Product 2',
                  description: 'Another great product',
                  price: 149.99,
                  imageUrl: 'https://via.placeholder.com/150',
                ),
              ],
              onProductTap: (product) {
                // Navigate to product detail
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

### 7.2 LoginPage (Page)

```dart
// pages/login_page.dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormTemplate(
      title: 'Welcome Back',
      submitText: 'Login',
      form: LoginForm(
        onLogin: (email, password) {
          // Handle login
          print('Login: $email, $password');
        },
        onForgotPassword: () {
          // Navigate to forgot password
        },
        onRegister: () {
          // Navigate to register
        },
      ),
      onSubmit: () {
        // Handle form submission
      },
    );
  }
}
```

## 8. Simple Usage Examples

### 8.1 Basic App Structure

```dart
// main.dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atomic Design App',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
      ),
      home: HomePage(),
    );
  }
}
```

### 8.2 Component Usage

```dart
// Using atoms
AppButton(
  text: 'Click Me',
  onPressed: () => print('Button clicked'),
  variant: 'primary',
  size: 'medium',
  icon: Icons.add,
)

AppText(
  text: 'Hello World',
  variant: 'h1',
  color: AppColors.primary,
)

AppInput(
  hint: 'Enter text',
  label: 'Input Label',
  prefixIcon: Icons.search,
)

// Using molecules
SearchBar(
  hint: 'Search...',
  onSearch: () => print('Search'),
  onClear: () => print('Clear'),
)

FormField(
  label: 'Email',
  hint: 'Enter email',
  isRequired: true,
  icon: Icons.email,
)

// Using organisms
AppHeader(
  title: 'My App',
  showBackButton: true,
  actions: [
    IconButton(icon: Icon(Icons.menu), onPressed: () {}),
  ],
)

LoginForm(
  onLogin: (email, password) => print('Login'),
  onForgotPassword: () => print('Forgot password'),
  onRegister: () => print('Register'),
)
```

## 9. Benefits of Atomic Design

### 9.1 Development Benefits

- ✅ **Reusability**: Components có thể tái sử dụng
- ✅ **Consistency**: UI nhất quán
- ✅ **Maintainability**: Dễ maintain
- ✅ **Scalability**: Dễ mở rộng
- ✅ **Testing**: Dễ test từng component

### 9.2 Team Benefits

- ✅ **Clear Structure**: Cấu trúc rõ ràng
- ✅ **Easy Onboarding**: Dễ cho new team members
- ✅ **Code Review**: Dễ review code
- ✅ **Documentation**: Dễ document

### 9.3 Business Benefits

- ✅ **Fast Development**: Phát triển nhanh
- ✅ **Quality**: Chất lượng cao
- ✅ **Flexibility**: Linh hoạt
- ✅ **Cost Effective**: Tiết kiệm chi phí

## 10. Best Practices

### 10.1 Naming Conventions

- **Atoms**: `AppButton`, `AppText`, `AppInput`
- **Molecules**: `SearchBar`, `FormField`, `CardItem`
- **Organisms**: `AppHeader`, `LoginForm`, `ProductList`
- **Templates**: `PageTemplate`, `FormTemplate`
- **Pages**: `HomePage`, `LoginPage`, `ProductPage`

### 10.2 File Organization

```
components/
├── atoms/          # Smallest components
├── molecules/      # Combinations of atoms
├── organisms/      # Complex components
└── templates/      # Layout structures

pages/              # Page implementations
theme/              # Design tokens
```

### 10.3 Component Design

- **Single Responsibility**: Mỗi component có 1 nhiệm vụ
- **Props Interface**: Clear props interface
- **Default Values**: Sensible defaults
- **Error Handling**: Proper error handling
- **Accessibility**: Accessibility support

## 11. Migration Strategy

### 11.1 Phase 1: Foundation

1. **Setup Theme System**: Colors, spacing, typography
2. **Create Atoms**: Basic components
3. **Establish Patterns**: Naming conventions

### 11.2 Phase 2: Molecules

1. **Combine Atoms**: Create molecules
2. **Add Functionality**: Business logic
3. **Test Components**: Unit testing

### 11.3 Phase 3: Organisms

1. **Complex Components**: Build organisms
2. **Integration**: Connect components
3. **Optimization**: Performance optimization

### 11.4 Phase 4: Templates & Pages

1. **Layout Structure**: Create templates
2. **Page Implementation**: Build pages
3. **Navigation**: App navigation

## Conclusion

Atomic Design trong Flutter cung cấp:

1. **Clear Structure**: Cấu trúc rõ ràng và dễ hiểu
2. **Reusability**: Components có thể tái sử dụng
3. **Maintainability**: Dễ maintain và update
4. **Scalability**: Dễ mở rộng khi cần
5. **Team Efficiency**: Hiệu quả cho team development

Đây là cách tiếp cận **đơn giản nhưng mạnh mẽ** để tạo flexible UI! 🎯
