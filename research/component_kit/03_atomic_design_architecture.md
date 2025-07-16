# Atomic Design Architecture for Flutter Component Kit

> **🎯 Objective**: Implement atomic design principles (Atoms, Molecules, Organisms) for scalable and maintainable Flutter component architecture.

## 🧬 **Atomic Design Principles**

### **Design Hierarchy**

```
🎨 Design System
├── 🧪 Atoms (Basic building blocks)
│   ├── AppButton
│   ├── AppText
│   ├── AppInput
│   ├── AppIcon
│   └── AppSpacer
├── 🧬 Molecules (Composite components)
│   ├── SearchBar
│   ├── FormField
│   ├── Card
│   ├── ListItem
│   └── NavigationItem
└── 🦠 Organisms (Complex components)
    ├── Header
    ├── Footer
    ├── Sidebar
    ├── Form
    └── DataTable
```

## 🧪 **Atoms - Basic Building Blocks**

### **Component List & Classification**

| **Atom**      | **Variants**                                       | **States**                         | **Use Cases**               |
| ------------- | -------------------------------------------------- | ---------------------------------- | --------------------------- |
| **AppButton** | primary, secondary, outline, text, danger, success | normal, loading, disabled, pressed | Actions, navigation, forms  |
| **AppText**   | h1-h6, body, caption, overline                     | normal, bold, italic, truncated    | Typography, labels, content |
| **AppInput**  | outlined, filled, underlined                       | normal, focused, error, disabled   | Forms, search, data entry   |
| **AppIcon**   | small, medium, large                               | normal, active, disabled           | UI indicators, actions      |
| **AppSpacer** | xs, sm, md, lg, xl                                 | -                                  | Layout spacing              |

### **Atom Implementation Example**

```dart
// Base atom interface
abstract class Atom {
  Widget build(BuildContext context);
  String get name;
  Map<String, dynamic> get props;
}

// AppButton Atom Implementation
class AppButton extends StatelessWidget implements Atom {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final bool isDisabled;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.isLoading = false,
    this.icon,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.fromTokens();

    return _buildButton(theme);
  }

  Widget _buildButton(AppTheme theme) {
    final isEnabled = !isDisabled && !isLoading && onPressed != null;

    switch (variant) {
      case ButtonVariant.primary:
        return _buildPrimaryButton(theme, isEnabled);
      case ButtonVariant.secondary:
        return _buildSecondaryButton(theme, isEnabled);
      case ButtonVariant.outline:
        return _buildOutlineButton(theme, isEnabled);
      case ButtonVariant.text:
        return _buildTextButton(theme, isEnabled);
      case ButtonVariant.danger:
        return _buildDangerButton(theme, isEnabled);
      case ButtonVariant.success:
        return _buildSuccessButton(theme, isEnabled);
    }
  }

  Widget _buildPrimaryButton(AppTheme theme, bool isEnabled) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getBackgroundColor(theme),
        foregroundColor: _getForegroundColor(theme),
        padding: _getPadding(theme),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme.borderRadius.button),
        ),
        elevation: isEnabled ? 2.0 : 0.0,
      ),
      child: _buildButtonChild(theme),
    );
  }

  Widget _buildButtonChild(AppTheme theme) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getTextColor(theme),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: _getIconSize(), color: _getTextColor(theme)),
          SizedBox(width: theme.spacing.sm),
        ],
        Text(
          text,
          style: _getTextStyle(theme),
        ),
      ],
    );
  }

  // Helper methods for styling
  Color _getBackgroundColor(AppTheme theme) {
    if (isDisabled) return theme.colors.neutral['300'] ?? Colors.grey;

    switch (variant) {
      case ButtonVariant.primary:
        return theme.colors.primary['500'] ?? Colors.blue;
      case ButtonVariant.danger:
        return theme.colors.status['negative']?['500'] ?? Colors.red;
      case ButtonVariant.success:
        return theme.colors.status['positive']?['500'] ?? Colors.green;
      default:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(AppTheme theme) {
    if (isDisabled) return theme.colors.neutral['500'] ?? Colors.grey;

    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.danger:
      case ButtonVariant.success:
        return Colors.white;
      default:
        return theme.colors.primary['500'] ?? Colors.blue;
    }
  }

  EdgeInsets _getPadding(AppTheme theme) {
    switch (size) {
      case ButtonSize.xs:
        return EdgeInsets.symmetric(
          horizontal: theme.spacing.sm,
          vertical: theme.spacing.xs,
        );
      case ButtonSize.sm:
        return EdgeInsets.symmetric(
          horizontal: theme.spacing.md,
          vertical: theme.spacing.sm,
        );
      case ButtonSize.md:
        return EdgeInsets.symmetric(
          horizontal: theme.spacing.lg,
          vertical: theme.spacing.md,
        );
      case ButtonSize.lg:
        return EdgeInsets.symmetric(
          horizontal: theme.spacing.xl,
          vertical: theme.spacing.md,
        );
      case ButtonSize.xl:
        return EdgeInsets.symmetric(
          horizontal: theme.spacing.xxl,
          vertical: theme.spacing.lg,
        );
    }
  }

  TextStyle _getTextStyle(AppTheme theme) {
    final baseStyle = theme.typography.getStyle(TextVariant.body);

    switch (size) {
      case ButtonSize.xs:
        return baseStyle.copyWith(fontSize: 12);
      case ButtonSize.sm:
        return baseStyle.copyWith(fontSize: 14);
      case ButtonSize.md:
        return baseStyle.copyWith(fontSize: 16);
      case ButtonSize.lg:
        return baseStyle.copyWith(fontSize: 18);
      case ButtonSize.xl:
        return baseStyle.copyWith(fontSize: 20);
    }
  }

  Color _getTextColor(AppTheme theme) {
    return _getForegroundColor(theme);
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

  @override
  String get name => 'AppButton';

  @override
  Map<String, dynamic> get props => {
    'text': text,
    'variant': variant.name,
    'size': size.name,
    'isLoading': isLoading,
    'isDisabled': isDisabled,
    'hasIcon': icon != null,
  };
}
```

## 🧬 **Molecules - Composite Components**

### **Molecule Implementation**

```dart
// SearchBar Molecule
class SearchBar extends StatelessWidget {
  final String? hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSearch;
  final bool isLoading;
  final SearchBarVariant variant;

  const SearchBar({
    Key? key,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.onClear,
    this.onSearch,
    this.isLoading = false,
    this.variant = SearchBarVariant.basic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.fromTokens();

    return _buildSearchBar(theme);
  }

  Widget _buildSearchBar(AppTheme theme) {
    switch (variant) {
      case SearchBarVariant.basic:
        return _buildBasicSearchBar(theme);
      case SearchBarVariant.advanced:
        return _buildAdvancedSearchBar(theme);
      case SearchBarVariant.withFilters:
        return _buildSearchBarWithFilters(theme);
    }
  }

  Widget _buildBasicSearchBar(AppTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colors.neutral['100'],
        borderRadius: BorderRadius.circular(theme.borderRadius.input),
        border: Border.all(
          color: theme.colors.neutral['300'] ?? Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(theme.spacing.sm),
            child: Icon(
              Icons.search,
              color: theme.colors.neutral['500'],
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: initialValue),
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText ?? 'Search...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: theme.colors.neutral['400'],
                ),
              ),
            ),
          ),
          if (isLoading)
            Padding(
              padding: EdgeInsets.all(theme.spacing.sm),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colors.primary['500'] ?? Colors.blue,
                  ),
                ),
              ),
            ),
          if (onClear != null)
            IconButton(
              onPressed: onClear,
              icon: Icon(
                Icons.clear,
                color: theme.colors.neutral['500'],
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSearchBar(AppTheme theme) {
    return Column(
      children: [
        _buildBasicSearchBar(theme),
        SizedBox(height: theme.spacing.sm),
        _buildSearchOptions(theme),
      ],
    );
  }

  Widget _buildSearchOptions(AppTheme theme) {
    return Row(
      children: [
        AppButton(
          text: 'Filters',
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: () {},
        ),
        SizedBox(width: theme.spacing.sm),
        AppButton(
          text: 'Sort',
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBarWithFilters(theme) {
    return Container(
      padding: EdgeInsets.all(theme.spacing.md),
      decoration: BoxDecoration(
        color: theme.colors.neutral['50'],
        borderRadius: BorderRadius.circular(theme.borderRadius.card),
        border: Border.all(
          color: theme.colors.neutral['200'] ?? Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          _buildBasicSearchBar(theme),
          SizedBox(height: theme.spacing.md),
          _buildFilterChips(theme),
        ],
      ),
    );
  }

  Widget _buildFilterChips(theme) {
    return Wrap(
      spacing: theme.spacing.sm,
      children: [
        _buildFilterChip('All', true, theme),
        _buildFilterChip('Recent', false, theme),
        _buildFilterChip('Favorites', false, theme),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, AppTheme theme) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {},
      backgroundColor: theme.colors.neutral['100'],
      selectedColor: theme.colors.primary['100'],
      labelStyle: TextStyle(
        color: isSelected
          ? theme.colors.primary['700']
          : theme.colors.neutral['700'],
      ),
    );
  }
}

// FormField Molecule
class FormField extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldVariant variant;
  final bool isRequired;
  final bool isDisabled;

  const FormField({
    Key? key,
    required this.label,
    this.hintText,
    this.errorText,
    this.controller,
    this.onChanged,
    this.variant = FormFieldVariant.text,
    this.isRequired = false,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.fromTokens();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(theme),
        SizedBox(height: theme.spacing.xs),
        _buildInputField(theme),
        if (errorText != null) ...[
          SizedBox(height: theme.spacing.xs),
          _buildErrorText(theme),
        ],
      ],
    );
  }

  Widget _buildLabel(AppTheme theme) {
    return Row(
      children: [
        Text(
          label,
          style: theme.typography.getStyle(TextVariant.body).copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colors.neutral['700'],
          ),
        ),
        if (isRequired) ...[
          SizedBox(width: theme.spacing.xs),
          Text(
            '*',
            style: TextStyle(
              color: theme.colors.status['negative']?['500'] ?? Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInputField(AppTheme theme) {
    switch (variant) {
      case FormFieldVariant.text:
        return _buildTextInput(theme);
      case FormFieldVariant.email:
        return _buildEmailInput(theme);
      case FormFieldVariant.password:
        return _buildPasswordInput(theme);
      case FormFieldVariant.select:
        return _buildSelectInput(theme);
    }
  }

  Widget _buildTextInput(AppTheme theme) {
    return AppInput(
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      isDisabled: isDisabled,
      hasError: errorText != null,
    );
  }

  Widget _buildErrorText(AppTheme theme) {
    return Text(
      errorText!,
      style: theme.typography.getStyle(TextVariant.caption).copyWith(
        color: theme.colors.status['negative']?['500'] ?? Colors.red,
      ),
    );
  }
}
```

## 🦠 **Organisms - Complex Components**

### **Organism Implementation**

```dart
// Header Organism
class AppHeader extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showSearch;
  final bool showNotifications;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onNotificationPressed;

  const AppHeader({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.showSearch = false,
    this.showNotifications = false,
    this.onSearchPressed,
    this.onNotificationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.fromTokens();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.lg,
        vertical: theme.spacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colors.neutral['0'],
        border: Border(
          bottom: BorderSide(
            color: theme.colors.neutral['200'] ?? Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: theme.spacing.md),
          ],
          Expanded(
            child: Text(
              title,
              style: theme.typography.getStyle(TextVariant.h1).copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colors.neutral['900'],
              ),
            ),
          ),
          if (showSearch) ...[
            IconButton(
              onPressed: onSearchPressed,
              icon: Icon(
                Icons.search,
                color: theme.colors.neutral['600'],
              ),
            ),
          ],
          if (showNotifications) ...[
            IconButton(
              onPressed: onNotificationPressed,
              icon: Icon(
                Icons.notifications_outlined,
                color: theme.colors.neutral['600'],
              ),
            ),
          ],
          if (actions != null) ...[
            ...actions!,
          ],
        ],
      ),
    );
  }
}

// DataTable Organism
class AppDataTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> data;
  final bool isSortable;
  final bool isPaginated;
  final int currentPage;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<String>? onSort;

  const AppDataTable({
    Key? key,
    required this.headers,
    required this.data,
    this.isSortable = false,
    this.isPaginated = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.onPageChanged,
    this.onSort,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.fromTokens();

    return Column(
      children: [
        _buildTable(theme),
        if (isPaginated) ...[
          SizedBox(height: theme.spacing.md),
          _buildPagination(theme),
        ],
      ],
    );
  }

  Widget _buildTable(AppTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colors.neutral['0'],
        borderRadius: BorderRadius.circular(theme.borderRadius.card),
        border: Border.all(
          color: theme.colors.neutral['200'] ?? Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(theme),
          ...data.map((row) => _buildRow(row, theme)),
        ],
      ),
    );
  }

  Widget _buildHeader(AppTheme theme) {
    return Container(
      padding: EdgeInsets.all(theme.spacing.md),
      decoration: BoxDecoration(
        color: theme.colors.neutral['50'],
        border: Border(
          bottom: BorderSide(
            color: theme.colors.neutral['200'] ?? Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(
        children: headers.map((header) {
          return Expanded(
            child: Row(
              children: [
                Text(
                  header,
                  style: theme.typography.getStyle(TextVariant.body).copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colors.neutral['700'],
                  ),
                ),
                if (isSortable) ...[
                  SizedBox(width: theme.spacing.xs),
                  Icon(
                    Icons.arrow_upward,
                    size: 16,
                    color: theme.colors.neutral['400'],
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRow(List<String> rowData, AppTheme theme) {
    return Container(
      padding: EdgeInsets.all(theme.spacing.md),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colors.neutral['100'] ?? Colors.grey[100]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: rowData.map((cell) {
          return Expanded(
            child: Text(
              cell,
              style: theme.typography.getStyle(TextVariant.body).copyWith(
                color: theme.colors.neutral['600'],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPagination(AppTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton(
          text: 'Previous',
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: currentPage > 1
            ? () => onPageChanged?.call(currentPage - 1)
            : null,
        ),
        SizedBox(width: theme.spacing.md),
        Text(
          'Page $currentPage of $totalPages',
          style: theme.typography.getStyle(TextVariant.body),
        ),
        SizedBox(width: theme.spacing.md),
        AppButton(
          text: 'Next',
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: currentPage < totalPages
            ? () => onPageChanged?.call(currentPage + 1)
            : null,
        ),
      ],
    );
  }
}
```

## 🔄 **Component Composition**

### **Composition Pattern**

```dart
// Example: Creating a complex form using atoms and molecules
class UserProfileForm extends StatelessWidget {
  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;

  const UserProfileForm({
    Key? key,
    this.onSubmit,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.fromTokens();

    return Container(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Column(
        children: [
          // Header (Organism)
          AppHeader(
            title: 'User Profile',
            actions: [
              AppButton(
                text: 'Cancel',
                variant: ButtonVariant.text,
                size: ButtonSize.sm,
                onPressed: onCancel,
              ),
            ],
          ),
          SizedBox(height: theme.spacing.xl),

          // Form Fields (Molecules)
          FormField(
            label: 'Full Name',
            hintText: 'Enter your full name',
            isRequired: true,
          ),
          SizedBox(height: theme.spacing.md),

          FormField(
            label: 'Email',
            hintText: 'Enter your email',
            variant: FormFieldVariant.email,
            isRequired: true,
          ),
          SizedBox(height: theme.spacing.md),

          FormField(
            label: 'Phone',
            hintText: 'Enter your phone number',
          ),
          SizedBox(height: theme.spacing.xl),

          // Actions (Atoms)
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Save Changes',
                  variant: ButtonVariant.primary,
                  size: ButtonSize.lg,
                  onPressed: onSubmit,
                ),
              ),
              SizedBox(width: theme.spacing.md),
              Expanded(
                child: AppButton(
                  text: 'Reset',
                  variant: ButtonVariant.outline,
                  size: ButtonSize.lg,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

## 📊 **Architecture Benefits**

### **Advantages**

1. **🧩 Modularity**: Each component is self-contained
2. **🔄 Reusability**: Components can be reused across projects
3. **🎯 Consistency**: Atomic design ensures design consistency
4. **📈 Scalability**: Easy to add new components
5. **🧪 Testability**: Each component can be tested independently
6. **👥 Team Collaboration**: Clear component boundaries

### **Performance Metrics**

| **Metric**              | **Target** | **Measurement**                |
| ----------------------- | ---------- | ------------------------------ |
| **Component Load Time** | < 50ms     | Individual component rendering |
| **Memory Usage**        | < 10MB     | Component library footprint    |
| **Bundle Size**         | < 1MB      | Production bundle size         |
| **Reusability Rate**    | > 80%      | Components reused across apps  |

## 🚀 **Implementation Strategy**

### **Phase 1: Atoms (Week 1)**

- [ ] Implement core atoms (Button, Text, Input, Icon, Spacer)
- [ ] Add variant system for each atom
- [ ] Create comprehensive testing suite

### **Phase 2: Molecules (Week 2)**

- [ ] Build composite components using atoms
- [ ] Implement state management for molecules
- [ ] Add interaction patterns

### **Phase 3: Organisms (Week 3)**

- [ ] Create complex components using molecules
- [ ] Implement layout patterns
- [ ] Add accessibility features

### **Phase 4: Integration (Week 4)**

- [ ] Integrate with design token system
- [ ] Create documentation and examples
- [ ] Performance optimization

---

> **💡 Key Insight**: Atomic design provides a systematic approach to component architecture, enabling rapid development with consistent design patterns.

**🎯 Expected Outcome**: 70% faster UI development with 100% design consistency across all components.
