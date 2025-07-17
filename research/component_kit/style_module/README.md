# Theme Manager Module Documentation

## Overview

The Theme Manager module provides a centralized way to manage your Flutter app's visual styling, including colors and spacing, loaded from a `styles.json` configuration file. It allows for consistent theming across the app and easy style updates without code changes.

## Setup

1. **Add `styles.json` to Assets**
   - Create a `styles.json` file in your project's `assets` folder with the following structure:

     ```json
     {
       "sys-color": {
          "light": {
            "background": {
              "primary": {
                "subdued": {
                  "value": "#9fedec"
                },
              }
            }
          }
       }
     }
     ```

2. **Update `pubspec.yaml`**
   - Include the `styles.json` file in your `pubspec.yaml`:

     ```yaml
     flutter:
       assets:
         - assets/styles.json
     ```

3. **Initialize Theme Manager**
   - In your `main.dart`, initialize the Theme Manager before running the app:

     ```dart
     import 'package:flutter/material.dart';
     import 'package:style_module/theme/theme_manager.dart';

     void main() async {
       WidgetsFlutterBinding.ensureInitialized();
       await ThemeManager.loadStyles();
       runApp(const MyApp());
     }
     ```

4. **Apply Theme**
   - Use the `AppTheme.lightTheme` or `AppTheme.darkTheme` to set the app's theme:

     ```dart
     class MyApp extends StatelessWidget {
       const MyApp({super.key});

       @override
       Widget build(BuildContext context) {
         return MaterialApp(
            // Theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            home: const MyHomePage(),
         );
       }
     }
     ```

## Usage

### Applying Theme
- Set the app's theme using `AppTheme.lightTheme` or `AppTheme.darkTheme` in the `MaterialApp` widget.
- Change theme using `context.read<AppBloc>().add(AppThemeChanged(value));`:
  ```dart
  BlocBuilder<AppBloc, AppState>(
    builder: (context, state) {
      return ListTile(
        leading: Icon(
          state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        ),
        title: Text(l10n.darkMode),
        trailing: Switch(
          value: state.isDarkMode,
          onChanged: (value) {
            context.read<AppBloc>().add(AppThemeChanged(value));
          },
        ),
      );
    },
  ),
  ```

- Access theme properties in your widgets using `state.themeColors`:
  ```dart
  BlocBuilder<AppBloc, AppState>(
    builder: (context, state) {
      return Text(
        'Styled Text',
        style: TextStyle(
          color: state.themeColors.text.neutral.normal,
        ),
      );
    },
  ),
  ```

### Using Spacing
- Access spacing values using `AppSpacing`:
- In your `my_home_page.dart`, import the App Spacing before running the app:

  ```dart
  import 'package:flutter/material.dart';
  import 'package:style_module/theme/app_spacing.dart';

  SizedBox(height: AppSpacing.cardToCard),
  ```

### Updating Styles
- Modify `styles.json` to change colors or spacing values. The app will reflect these changes on the next run without requiring code changes.

## API Reference

### Classes

#### `AppColors`
- **Description**: Defines color properties for the app.
- **Properties**:
  - `light`: `ThemeColors`.
  - `dark`: `ThemeColors`.
- **Init**:
  ```dart
  AppColors.init(SystemColor sysColor);
  ```

#### `AppDimension`
- **Description**: Defines dimension values for consistent size/padding/margins.
- **Properties**:
  - `dm2`: `double` - Size 2px.
  - `dm4`: `double` - Size 4px.
  - `dm8`: `double` - Size 8px.
  - `dm10`: `double` - Size 10px.
  - `dm12`: `double` - Size 12px.
  - ...
- **Init**:
  ```dart
  AppDimension.init(RefDm dimension);
  ```


#### `AppRadius`
- **Description**: Defines spacing values for consistent padding/margins.
- **Properties**:
  - `card`: `double` - Border Radius value of Card (e.g., 8px).
  - `button`: `double` - Border Radius value of Button (e.g., 12px).
  - `input`: `double` - Border Radius value of Input (e.g., 16px).
  - `badge`: `double` - Border Radius value of Badge (e.g., 1000px).
  - `chipTag`: `double` - Border Radius value of Chip and Tag (e.g., 1000px).
- **Init**:
  ```dart
  AppRadius.init(DesignRadius designRadius);
  ```

#### `AppSpacing`
- **Description**: Defines spacing values for consistent padding/margins.
- **Properties**:
  - `blockToBlock`: `double` - Spacing value between Block to Block (e.g., 8.0).
  - `cardToCard`: `double` - Spacing value between Card to Card (e.g., 12.0).
  - `titleToContent`: `double` - Spacing value between Title to Content (e.g., 16.0).
  - `subTitleToContent`: `double` - Spacing value between Subtitle to Content (e.g., 20.0).
  - `inputForm`: `double` - Spacing value inputForm (e.g., 24.0).
- **Init**:
  ```dart
  AppSpacing.init(Spacing spacing);
  ```

#### `ThemeManager`
- **Description**: Manages loading and applying styles from `styles.json`.
- **Static Methods**:
  - `Future<void> loadStyles()`: Loads styles from `assets/styles.json`.
  - `AppColors.init(SystemColor sysColor);`: Set `SystemColor` object configured for `AppColors`.
  - `AppDimension.init(RefDm dimension);`: Set `RefDm` object configured for `AppDimension`.
  - `AppRadius.init(DesignRadius designRadius);`: Set `DesignRadius` object configured for `AppRadius`.
  - `AppSpacing.init(Spacing spacing);`: Set `Spacing` object configured for `AppSpacing`.
  - `AppTheme.init()`: Created `ThemeData` object configured with loaded colors.

### Helper Methods (Internal)
- `colorFromJson(Map<String, dynamic> json)`: Converts a map json (e.g., { value: "#6200EA" }) to a `Color` object.
- `doubleFromJson(Map<String, dynamic> json)`: Converts a map json (e.g., { value: "12px" }) to a `double` object.
- `fontNameFromJson(Map<String, dynamic> json)`: Converts a map json (e.g., { value: "Barlow Semi Condensed" }) to a `String` object.

## Error Handling
- If `styles.json` fails to load or is malformed, the module logs an error to the console and uses default values:
  - Theme: `AppTheme.lightTheme`
  - Color: `AppColors.light.background.neutral.accent`
  - Radius: `Radius.circular(AppRadius.card)`
  - Spacing: `AppSpacing.cardToCard`

## Example
Below is an example of a home page using the Theme Manager:

```dart
import 'package:style_module/theme/app_dimension.dart';
import 'package:style_module/theme/app_radius.dart';
import 'package:style_module/theme/app_spacing.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Manager Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                return Text(
                  'Styled Text',
                  style: TextStyle(
                    fontSize: AppDimension.dm20,
                    fontWeight: FontWeight.bold,
                    color: state.themeColors.text.neutral.normal,
                  ),
                );
              },
            ),
            SizedBox(height: AppSpacing.cardToCard),
            Container(
              color: Theme.of(context).colorScheme.secondary,
              height: 50,
              width: 100,
            ),
            SizedBox(height: AppSpacing.cardToCard),
            Text(
              'Sample Text with Theme',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
```

## Notes
- Ensure `styles.json` is correctly formatted to avoid parsing errors.
- Spacing values should be pixel strings.