# Flutter Component Kit - Demo Implementation

> **🎯 Objective**: Provide practical examples and working demonstrations of the Flutter component kit system with design token integration, atomic design, and variant management.

## 🚀 **Quick Start Demo**

### **Basic Setup**

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_component_kit/flutter_component_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize component kit with design tokens
  await ComponentKit.initialize(
    designTokensPath: 'assets/design_tokens/styles.json',
    enableCustomization: true,
  );

  runApp(DemoApp());
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Component Kit Demo',
      theme: ComponentKit.theme.lightTheme,
      darkTheme: ComponentKit.theme.darkTheme,
      home: DemoHomeScreen(),
    );
  }
}
```

### **Demo Home Screen**

```dart
// demo_home_screen.dart
class DemoHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Component Kit Demo',
        showSearch: true,
        actions: [
          AppButton(
            text: 'Settings',
            variant: ButtonVariant.text,
            size: ComponentSize.sm,
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ComponentKit.theme.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Atoms - Basic Components'),
            SizedBox(height: ComponentKit.theme.spacing.md),
            _buildAtomsDemo(),

            SizedBox(height: ComponentKit.theme.spacing.xl),
            _buildSectionTitle('Molecules - Composite Components'),
            SizedBox(height: ComponentKit.theme.spacing.md),
            _buildMoleculesDemo(),

            SizedBox(height: ComponentKit.theme.spacing.xl),
            _buildSectionTitle('Organisms - Complex Components'),
            SizedBox(height: ComponentKit.theme.spacing.md),
            _buildOrganismsDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return AppText(
      text: title,
      variant: TextVariant.h2,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: ComponentKit.theme.colors.neutral['900'],
      ),
    );
  }
}
```

## 🧪 **Atoms Demo**

### **Button Atoms Demo**

```dart
// atoms_demo.dart
class AtomsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildButtonVariants(),
        SizedBox(height: ComponentKit.theme.spacing.lg),
        _buildButtonSizes(),
        SizedBox(height: ComponentKit.theme.spacing.lg),
        _buildButtonStates(),
        SizedBox(height: ComponentKit.theme.spacing.lg),
        _buildTextVariants(),
        SizedBox(height: ComponentKit.theme.spacing.lg),
        _buildInputVariants(),
      ],
    );
  }

  Widget _buildButtonVariants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Button Variants',
          variant: TextVariant.h3,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        Wrap(
          spacing: ComponentKit.theme.spacing.sm,
          runSpacing: ComponentKit.theme.spacing.sm,
          children: [
            AppButton(
              text: 'Primary',
              variant: ButtonVariant.primary,
              onPressed: () => _showSnackBar('Primary button pressed'),
            ),
            AppButton(
              text: 'Secondary',
              variant: ButtonVariant.secondary,
              onPressed: () => _showSnackBar('Secondary button pressed'),
            ),
            AppButton(
              text: 'Outline',
              variant: ButtonVariant.outline,
              onPressed: () => _showSnackBar('Outline button pressed'),
            ),
            AppButton(
              text: 'Text',
              variant: ButtonVariant.text,
              onPressed: () => _showSnackBar('Text button pressed'),
            ),
            AppButton(
              text: 'Danger',
              variant: ButtonVariant.danger,
              onPressed: () => _showSnackBar('Danger button pressed'),
            ),
            AppButton(
              text: 'Success',
              variant: ButtonVariant.success,
              onPressed: () => _showSnackBar('Success button pressed'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonSizes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Button Sizes',
          variant: TextVariant.h3,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        Wrap(
          spacing: ComponentKit.theme.spacing.sm,
          runSpacing: ComponentKit.theme.spacing.sm,
          children: [
            AppButton(
              text: 'XS',
              variant: ButtonVariant.primary,
              size: ComponentSize.xs,
              onPressed: () {},
            ),
            AppButton(
              text: 'SM',
              variant: ButtonVariant.primary,
              size: ComponentSize.sm,
              onPressed: () {},
            ),
            AppButton(
              text: 'MD',
              variant: ButtonVariant.primary,
              size: ComponentSize.md,
              onPressed: () {},
            ),
            AppButton(
              text: 'LG',
              variant: ButtonVariant.primary,
              size: ComponentSize.lg,
              onPressed: () {},
            ),
            AppButton(
              text: 'XL',
              variant: ButtonVariant.primary,
              size: ComponentSize.xl,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonStates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Button States',
          variant: TextVariant.h3,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        Wrap(
          spacing: ComponentKit.theme.spacing.sm,
          runSpacing: ComponentKit.theme.spacing.sm,
          children: [
            AppButton(
              text: 'Normal',
              variant: ButtonVariant.primary,
              onPressed: () {},
            ),
            AppButton(
              text: 'Loading',
              variant: ButtonVariant.primary,
              isLoading: true,
              onPressed: () {},
            ),
            AppButton(
              text: 'Disabled',
              variant: ButtonVariant.primary,
              isDisabled: true,
              onPressed: () {},
            ),
            AppButton(
              text: 'With Icon',
              variant: ButtonVariant.primary,
              icon: Icons.add,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextVariants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Text Variants',
          variant: TextVariant.h3,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Heading 1 - Large Title',
              variant: TextVariant.h1,
            ),
            AppText(
              text: 'Heading 2 - Section Title',
              variant: TextVariant.h2,
            ),
            AppText(
              text: 'Heading 3 - Subsection Title',
              variant: TextVariant.h3,
            ),
            AppText(
              text: 'Body - Regular paragraph text with normal weight and size',
              variant: TextVariant.body,
            ),
            AppText(
              text: 'Caption - Small text for labels and descriptions',
              variant: TextVariant.caption,
            ),
            AppText(
              text: 'OVERLINE - Uppercase text for categories',
              variant: TextVariant.overline,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputVariants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Input Variants',
          variant: TextVariant.h3,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        Column(
          children: [
            AppInput(
              hintText: 'Outlined input field',
              variant: InputVariant.outlined,
              onChanged: (value) => print('Input changed: $value'),
            ),
            SizedBox(height: ComponentKit.theme.spacing.sm),
            AppInput(
              hintText: 'Filled input field',
              variant: InputVariant.filled,
              onChanged: (value) => print('Input changed: $value'),
            ),
            SizedBox(height: ComponentKit.theme.spacing.sm),
            AppInput(
              hintText: 'Underlined input field',
              variant: InputVariant.underlined,
              onChanged: (value) => print('Input changed: $value'),
            ),
          ],
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
```

## 🧬 **Molecules Demo**

### **Composite Components Demo**

```dart
// molecules_demo.dart
class MoleculesDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchBarDemo(),
        SizedBox(height: ComponentKit.theme.spacing.lg),
        _buildFormFieldDemo(),
        SizedBox(height: ComponentKit.theme.spacing.lg),
        _buildCardDemo(),
        SizedBox(height: ComponentKit.theme.spacing.lg),
        _buildListItemDemo(),
      ],
    );
  }

  Widget _buildSearchBarDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Search Bar Molecules',
          variant: TextVariant.h3,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        Column(
          children: [
            SearchBar(
              hintText: 'Basic search...',
              onChanged: (value) => print('Search: $value'),
              onClear: () => print('Search cleared'),
            ),
            SizedBox(height: ComponentKit.theme.spacing.md),
            SearchBar(
              hintText: 'Advanced search with filters...',
              variant: SearchBarVariant.advanced,
              onChanged: (value) => print('Advanced search: $value'),
            ),
            SizedBox(height: ComponentKit.theme.spacing.md),
            SearchBar(
              hintText: 'Search with filter chips...',
              variant: SearchBarVariant.withFilters,
              onChanged: (value) => print('Filtered search: $value'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormFieldDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Form Field Molecules',
          variant: TextVariant.h3,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        Column(
          children: [
            FormField(
              label: 'Full Name',
              hintText: 'Enter your full name',
              isRequired: true,
              onChanged: (value) => print('Name: $value'),
            ),
            SizedBox(height: ComponentKit.theme.spacing.md),
            FormField(
              label: 'Email Address',
              hintText: 'Enter your email',
              variant: FormFieldVariant.email,
              isRequired: true,
              onChanged: (value) => print('Email: $value'),
            ),
            SizedBox(height: ComponentKit.theme.spacing.md),
            FormField(
              label: 'Password',
              hintText: 'Enter your password',
              variant: FormFieldVariant.password,
              isRequired: true,
              onChanged: (value) => print('Password: $value'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Card Molecules',
          variant: TextVariant.h3,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        Row(
          children: [
            Expanded(
              child: Card(
                variant: CardVariant.elevated,
                child: Padding(
                  padding: EdgeInsets.all(ComponentKit.theme.spacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: 'Elevated Card',
                        variant: TextVariant.h4,
                      ),
                      SizedBox(height: ComponentKit.theme.spacing.sm),
                      AppText(
                        text: 'This is an elevated card with shadow and padding.',
                        variant: TextVariant.body,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: ComponentKit.theme.spacing.md),
            Expanded(
              child: Card(
                variant: CardVariant.outlined,
                child: Padding(
                  padding: EdgeInsets.all(ComponentKit.theme.spacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: 'Outlined Card',
                        variant: TextVariant.h4,
                      ),
                      SizedBox(height: ComponentKit.theme.spacing.sm),
                      AppText(
                        text: 'This is an outlined card with border.',
                        variant: TextVariant.body,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListItemDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'List Item Molecules',
          variant: TextVariant.h3,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        Card(
          variant: CardVariant.outlined,
          child: Column(
            children: [
              ListItem(
                title: 'Basic List Item',
                subtitle: 'This is a basic list item with title and subtitle',
                onTap: () => print('Basic item tapped'),
              ),
              Divider(height: 1),
              ListItem(
                title: 'List Item with Avatar',
                subtitle: 'This item has an avatar icon',
                variant: ListItemVariant.withAvatar,
                avatar: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                onTap: () => print('Avatar item tapped'),
              ),
              Divider(height: 1),
              ListItem(
                title: 'List Item with Actions',
                subtitle: 'This item has action buttons',
                variant: ListItemVariant.withActions,
                actions: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => print('Edit tapped'),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => print('Delete tapped'),
                  ),
                ],
                onTap: () => print('Action item tapped'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

## 🦠 **Organisms Demo**

### **Complex Components Demo**

```dart
// organisms_demo.dart
class OrganismsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderDemo(),
        SizedBox(height: ComponentKit.theme.spacing.lg),
        _buildFormDemo(),
        SizedBox(height: ComponentKit.theme.spacing.lg),
        _buildDataTableDemo(),
      ],
    );
  }

  Widget _buildHeaderDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Header Organisms',
          variant: TextVariant.h3,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        Card(
          variant: CardVariant.outlined,
          child: AppHeader(
            title: 'Demo Header',
            showSearch: true,
            showNotifications: true,
            actions: [
              AppButton(
                text: 'Action 1',
                variant: ButtonVariant.outline,
                size: ComponentSize.sm,
                onPressed: () => print('Action 1 pressed'),
              ),
              SizedBox(width: ComponentKit.theme.spacing.sm),
              AppButton(
                text: 'Action 2',
                variant: ButtonVariant.primary,
                size: ComponentSize.sm,
                onPressed: () => print('Action 2 pressed'),
              ),
            ],
            onSearchPressed: () => print('Search pressed'),
            onNotificationPressed: () => print('Notifications pressed'),
          ),
        ),
      ],
    );
  }

  Widget _buildFormDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Form Organisms',
          variant: TextVariant.h3,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        Card(
          variant: CardVariant.outlined,
          child: Padding(
            padding: EdgeInsets.all(ComponentKit.theme.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'User Registration Form',
                  variant: TextVariant.h4,
                ),
                SizedBox(height: ComponentKit.theme.spacing.lg),
                FormField(
                  label: 'First Name',
                  hintText: 'Enter your first name',
                  isRequired: true,
                  onChanged: (value) => print('First name: $value'),
                ),
                SizedBox(height: ComponentKit.theme.spacing.md),
                FormField(
                  label: 'Last Name',
                  hintText: 'Enter your last name',
                  isRequired: true,
                  onChanged: (value) => print('Last name: $value'),
                ),
                SizedBox(height: ComponentKit.theme.spacing.md),
                FormField(
                  label: 'Email',
                  hintText: 'Enter your email address',
                  variant: FormFieldVariant.email,
                  isRequired: true,
                  onChanged: (value) => print('Email: $value'),
                ),
                SizedBox(height: ComponentKit.theme.spacing.md),
                FormField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  variant: FormFieldVariant.password,
                  isRequired: true,
                  onChanged: (value) => print('Password: $value'),
                ),
                SizedBox(height: ComponentKit.theme.spacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Cancel',
                        variant: ButtonVariant.outline,
                        onPressed: () => print('Form cancelled'),
                      ),
                    ),
                    SizedBox(width: ComponentKit.theme.spacing.md),
                    Expanded(
                      child: AppButton(
                        text: 'Submit',
                        variant: ButtonVariant.primary,
                        onPressed: () => print('Form submitted'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataTableDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Data Table Organisms',
          variant: TextVariant.h3,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        AppDataTable(
          headers: ['Name', 'Email', 'Role', 'Status'],
          data: [
            ['John Doe', 'john@example.com', 'Developer', 'Active'],
            ['Jane Smith', 'jane@example.com', 'Designer', 'Active'],
            ['Bob Johnson', 'bob@example.com', 'Manager', 'Inactive'],
            ['Alice Brown', 'alice@example.com', 'Developer', 'Active'],
          ],
          isSortable: true,
          isPaginated: true,
          currentPage: 1,
          totalPages: 3,
          onPageChanged: (page) => print('Page changed to: $page'),
          onSort: (column) => print('Sort by: $column'),
        ),
      ],
    );
  }
}
```

## 🎨 **Design Token Demo**

### **Dynamic Theme Demo**

```dart
// theme_demo.dart
class ThemeDemo extends StatefulWidget {
  @override
  State<ThemeDemo> createState() => _ThemeDemoState();
}

class _ThemeDemoState extends State<ThemeDemo> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Design Token Demo',
          variant: TextVariant.h3,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),

        // Theme toggle
        Row(
          children: [
            AppText(
              text: 'Theme Mode:',
              variant: TextVariant.body,
            ),
            SizedBox(width: ComponentKit.theme.spacing.sm),
            Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                  ComponentKit.setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                });
              },
            ),
            SizedBox(width: ComponentKit.theme.spacing.sm),
            AppText(
              text: _isDarkMode ? 'Dark' : 'Light',
              variant: TextVariant.body,
            ),
          ],
        ),

        SizedBox(height: ComponentKit.theme.spacing.lg),

        // Color palette demo
        _buildColorPalette(),

        SizedBox(height: ComponentKit.theme.spacing.lg),

        // Spacing demo
        _buildSpacingDemo(),

        SizedBox(height: ComponentKit.theme.spacing.lg),

        // Typography demo
        _buildTypographyDemo(),
      ],
    );
  }

  Widget _buildColorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Color Palette',
          variant: TextVariant.h4,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        Wrap(
          spacing: ComponentKit.theme.spacing.sm,
          runSpacing: ComponentKit.theme.spacing.sm,
          children: [
            _buildColorSwatch('Primary', ComponentKit.theme.colors.primary['500']!),
            _buildColorSwatch('Secondary', ComponentKit.theme.colors.secondary['500']!),
            _buildColorSwatch('Success', ComponentKit.theme.colors.status['positive']!['500']!),
            _buildColorSwatch('Warning', ComponentKit.theme.colors.status['warning']!['500']!),
            _buildColorSwatch('Error', ComponentKit.theme.colors.status['negative']!['500']!),
            _buildColorSwatch('Info', ComponentKit.theme.colors.status['informative']!['500']!),
          ],
        ),
      ],
    );
  }

  Widget _buildColorSwatch(String name, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: ComponentKit.theme.colors.neutral['300']!,
            ),
          ),
        ),
        SizedBox(height: ComponentKit.theme.spacing.xs),
        AppText(
          text: name,
          variant: TextVariant.caption,
        ),
      ],
    );
  }

  Widget _buildSpacingDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Spacing Scale',
          variant: TextVariant.h4,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        Column(
          children: [
            _buildSpacingItem('XS', ComponentKit.theme.spacing.xs),
            _buildSpacingItem('SM', ComponentKit.theme.spacing.sm),
            _buildSpacingItem('MD', ComponentKit.theme.spacing.md),
            _buildSpacingItem('LG', ComponentKit.theme.spacing.lg),
            _buildSpacingItem('XL', ComponentKit.theme.spacing.xl),
          ],
        ),
      ],
    );
  }

  Widget _buildSpacingItem(String name, double spacing) {
    return Padding(
      padding: EdgeInsets.only(bottom: ComponentKit.theme.spacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: AppText(
              text: name,
              variant: TextVariant.body,
            ),
          ),
          Container(
            width: spacing,
            height: 20,
            decoration: BoxDecoration(
              color: ComponentKit.theme.colors.primary['300']!,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: ComponentKit.theme.spacing.sm),
          AppText(
            text: '${spacing.toInt()}px',
            variant: TextVariant.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildTypographyDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Typography Scale',
          variant: TextVariant.h4,
        ),
        SizedBox(height: ComponentKit.theme.spacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Display Large - 32px',
              variant: TextVariant.h1,
            ),
            AppText(
              text: 'Display Medium - 24px',
              variant: TextVariant.h2,
            ),
            AppText(
              text: 'Display Small - 20px',
              variant: TextVariant.h3,
            ),
            AppText(
              text: 'Body Large - 18px',
              variant: TextVariant.h4,
            ),
            AppText(
              text: 'Body Medium - 16px',
              variant: TextVariant.body,
            ),
            AppText(
              text: 'Body Small - 14px',
              variant: TextVariant.bodySmall,
            ),
            AppText(
              text: 'Caption - 12px',
              variant: TextVariant.caption,
            ),
          ],
        ),
      ],
    );
  }
}
```

## 📱 **Complete Demo App**

### **Main Demo App Structure**

```dart
// demo_app.dart
class DemoApp extends StatefulWidget {
  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    AtomsDemo(),
    MoleculesDemo(),
    OrganismsDemo(),
    ThemeDemo(),
  ];

  final List<String> _titles = [
    'Atoms',
    'Molecules',
    'Organisms',
    'Design Tokens',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Component Kit Demo',
        showSearch: true,
        actions: [
          AppButton(
            text: 'GitHub',
            variant: ButtonVariant.text,
            size: ComponentSize.sm,
            icon: Icons.link,
            onPressed: () => _launchUrl('https://github.com/your-org/flutter_component_kit'),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.circle),
            label: 'Atoms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.extension),
            label: 'Molecules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Organisms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette),
            label: 'Design',
          ),
        ],
      ),
    );
  }

  void _launchUrl(String url) {
    // Implementation for launching URLs
  }
}
```

## 🎯 **Demo Features**

### **Interactive Features**

1. **🎨 Theme Switching**: Toggle between light and dark themes
2. **🎭 Variant Testing**: Test all component variants and states
3. **📱 Responsive Design**: See components adapt to different screen sizes
4. **⚡ Performance**: Experience fast loading and smooth interactions
5. **🧪 Component Testing**: Test individual components in isolation

### **Demo Benefits**

| **Feature**                     | **Benefit**                          | **Demo Impact**                |
| ------------------------------- | ------------------------------------ | ------------------------------ |
| **🎨 Design Token Integration** | See tokens applied in real-time      | Visual proof of consistency    |
| **🧬 Atomic Design**            | Component composition examples       | Understanding of architecture  |
| **🎭 Variant Management**       | All variants tested interactively    | Comprehensive variant coverage |
| **📱 Multi-Project Support**    | Customization examples               | Real-world usage scenarios     |
| **⚡ Performance**              | Fast loading and smooth interactions | Performance validation         |

## 🚀 **Running the Demo**

### **Setup Instructions**

1. **Clone the repository**:

   ```bash
   git clone https://github.com/your-org/flutter_component_kit.git
   cd flutter_component_kit
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Run the demo**:

   ```bash
   flutter run
   ```

4. **Explore the demo**:
   - Navigate through different component categories
   - Test various variants and states
   - Switch between light and dark themes
   - Experience the responsive design

### **Demo Structure**

```
demo/
├── lib/
│   ├── main.dart
│   ├── demo_app.dart
│   ├── screens/
│   │   ├── atoms_demo.dart
│   │   ├── molecules_demo.dart
│   │   ├── organisms_demo.dart
│   │   └── theme_demo.dart
│   └── widgets/
│       └── demo_widgets.dart
├── assets/
│   └── design_tokens/
│       └── styles.json
└── pubspec.yaml
```

---

> **💡 Demo Insight**: The demo provides hands-on experience with all component kit features, enabling developers to understand the system's capabilities and benefits through practical examples.

**🎯 Demo Success**: Comprehensive demonstration of all research findings with interactive examples and real-world usage scenarios.
