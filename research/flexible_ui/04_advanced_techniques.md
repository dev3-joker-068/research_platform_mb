# Advanced Techniques for Flexible Flutter UI

## Overview

This document explores advanced techniques for building highly flexible and performant UI systems in Flutter, including animations, responsive design, performance optimization, and advanced configuration patterns.

## 1. Animation Systems

### 1.1 Configurable Animation Engine

**Concept**: Define animations through configuration files

```dart
class AnimationConfig {
  final String type;
  final Duration duration;
  final Curve curve;
  final Map<String, dynamic> properties;

  AnimationConfig({
    required this.type,
    required this.duration,
    required this.curve,
    required this.properties,
  });

  static AnimationConfig fromJson(Map<String, dynamic> json) {
    return AnimationConfig(
      type: json['type'],
      duration: Duration(milliseconds: json['duration_ms'] ?? 300),
      curve: _parseCurve(json['curve']),
      properties: json['properties'] ?? {},
    );
  }

  static Curve _parseCurve(String? curve) {
    switch (curve) {
      case 'easeIn': return Curves.easeIn;
      case 'easeOut': return Curves.easeOut;
      case 'easeInOut': return Curves.easeInOut;
      case 'bounce': return Curves.bounceOut;
      case 'elastic': return Curves.elasticOut;
      default: return Curves.easeInOut;
    }
  }
}

class AnimatedFlexibleWidget extends StatefulWidget {
  final Widget child;
  final AnimationConfig? animationConfig;

  const AnimatedFlexibleWidget({
    Key? key,
    required this.child,
    this.animationConfig,
  }) : super(key: key);

  @override
  _AnimatedFlexibleWidgetState createState() => _AnimatedFlexibleWidgetState();
}

class _AnimatedFlexibleWidgetState extends State<AnimatedFlexibleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationConfig?.duration ?? Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationConfig?.curve ?? Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _buildAnimatedWidget();
      },
    );
  }

  Widget _buildAnimatedWidget() {
    final config = widget.animationConfig;
    if (config == null) return widget.child;

    switch (config.type) {
      case 'fade':
        return FadeTransition(
          opacity: _animation,
          child: widget.child,
        );
      case 'slide':
        final offset = config.properties['offset'] ?? Offset(0, 50);
        return SlideTransition(
          position: Tween<Offset>(
            begin: offset,
            end: Offset.zero,
          ).animate(_animation),
          child: widget.child,
        );
      case 'scale':
        return ScaleTransition(
          scale: _animation,
          child: widget.child,
        );
      case 'rotate':
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(_animation),
          child: widget.child,
        );
      default:
        return widget.child;
    }
  }
}
```

### 1.2 Staggered Animations

```dart
class StaggeredAnimationController {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  void addAnimation(AnimationConfig config) {
    final controller = AnimationController(
      duration: config.duration,
      vsync: TickerProvider(),
    );

    final animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: config.curve,
    ));

    _controllers.add(controller);
    _animations.add(animation);
  }

  void playSequentially() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        _controllers[i].forward();
      });
    }
  }

  void playSimultaneously() {
    for (final controller in _controllers) {
      controller.forward();
    }
  }

  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
  }
}
```

## 2. Responsive Design Systems

### 2.1 Breakpoint-Based Layout

```dart
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  static String getBreakpoint(double width) {
    if (width < mobile) return 'mobile';
    if (width < tablet) return 'tablet';
    if (width < desktop) return 'desktop';
    return 'large';
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Map<String, Widget> layouts;
  final Widget? fallback;

  const ResponsiveLayout({
    Key? key,
    required this.layouts,
    this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = ResponsiveBreakpoints.getBreakpoint(constraints.maxWidth);
        return layouts[breakpoint] ?? fallback ?? Container();
      },
    );
  }

  static Widget fromConfig(Map<String, dynamic> config) {
    final layouts = <String, Widget>{};

    if (config['mobile'] != null) {
      layouts['mobile'] = _buildWidget(config['mobile']);
    }
    if (config['tablet'] != null) {
      layouts['tablet'] = _buildWidget(config['tablet']);
    }
    if (config['desktop'] != null) {
      layouts['desktop'] = _buildWidget(config['desktop']);
    }
    if (config['large'] != null) {
      layouts['large'] = _buildWidget(config['large']);
    }

    return ResponsiveLayout(
      layouts: layouts,
      fallback: config['fallback'] != null
        ? _buildWidget(config['fallback'])
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

### 2.2 Adaptive Components

```dart
class AdaptiveTextField extends StatelessWidget {
  final String? hint;
  final bool isPassword;
  final Map<String, dynamic> responsiveConfig;

  const AdaptiveTextField({
    Key? key,
    this.hint,
    this.isPassword = false,
    required this.responsiveConfig,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = ResponsiveBreakpoints.getBreakpoint(constraints.maxWidth);
        final config = responsiveConfig[breakpoint] ?? responsiveConfig['default'] ?? {};

        return CustomTextField(
          hint: hint,
          isPassword: isPassword,
          borderRadius: config['border_radius']?.toDouble() ?? 8.0,
          margin: PropertyParser.parseEdgeInsets(config['margin']),
          backgroundColor: PropertyParser.parseColor(config['background_color']),
          textStyle: PropertyParser.parseTextStyle(config['text_style']),
        );
      },
    );
  }
}
```

## 3. Performance Optimization

### 3.1 Widget Caching System

```dart
class WidgetCache {
  static final Map<String, Widget> _cache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);

  static Widget getCached(String key, WidgetBuilder builder) {
    final now = DateTime.now();

    // Check if cache is expired
    if (_cacheTimestamps.containsKey(key)) {
      final timestamp = _cacheTimestamps[key]!;
      if (now.difference(timestamp) > _cacheExpiry) {
        _cache.remove(key);
        _cacheTimestamps.remove(key);
      }
    }

    if (!_cache.containsKey(key)) {
      _cache[key] = builder();
      _cacheTimestamps[key] = now;
    }

    return _cache[key]!;
  }

  static void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  static void removeFromCache(String key) {
    _cache.remove(key);
    _cacheTimestamps.remove(key);
  }
}
```

### 3.2 Lazy Loading Components

```dart
class LazyLoadingWidget extends StatefulWidget {
  final Future<Widget> Function() widgetBuilder;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const LazyLoadingWidget({
    Key? key,
    required this.widgetBuilder,
    this.loadingWidget,
    this.errorWidget,
  }) : super(key: key);

  @override
  _LazyLoadingWidgetState createState() => _LazyLoadingWidgetState();
}

class _LazyLoadingWidgetState extends State<LazyLoadingWidget> {
  Widget? _cachedWidget;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  Future<void> _loadWidget() async {
    try {
      final widget = await widget.widgetBuilder();
      if (mounted) {
        setState(() {
          _cachedWidget = widget;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loadingWidget ?? CircularProgressIndicator();
    }

    if (_error != null) {
      return widget.errorWidget ?? Text('Error: $_error');
    }

    return _cachedWidget ?? Container();
  }
}
```

### 3.3 Memory Management

```dart
class MemoryManager {
  static final List<Disposable> _disposables = [];

  static void register(Disposable disposable) {
    _disposables.add(disposable);
  }

  static void dispose() {
    for (final disposable in _disposables) {
      disposable.dispose();
    }
    _disposables.clear();
  }

  static void remove(Disposable disposable) {
    _disposables.remove(disposable);
  }
}

abstract class Disposable {
  void dispose();
}

class ConfigurableWidget extends StatefulWidget implements Disposable {
  final Map<String, dynamic> config;

  const ConfigurableWidget({Key? key, required this.config}) : super(key: key);

  @override
  _ConfigurableWidgetState createState() => _ConfigurableWidgetState();

  @override
  void dispose() {
    // Clean up resources
  }
}

class _ConfigurableWidgetState extends State<ConfigurableWidget> {
  @override
  void initState() {
    super.initState();
    MemoryManager.register(widget);
  }

  @override
  void dispose() {
    MemoryManager.remove(widget);
    widget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ComponentRegistry.build(
      widget.config['type'],
      widget.config['properties'] ?? {},
    );
  }
}
```

## 4. Advanced Configuration Patterns

### 4.1 Conditional Rendering

```dart
class ConditionalWidget extends StatelessWidget {
  final Map<String, dynamic> condition;
  final Widget trueWidget;
  final Widget? falseWidget;

  const ConditionalWidget({
    Key? key,
    required this.condition,
    required this.trueWidget,
    this.falseWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_evaluateCondition(condition)) {
      return trueWidget;
    }
    return falseWidget ?? Container();
  }

  bool _evaluateCondition(Map<String, dynamic> condition) {
    final type = condition['type'];
    final value = condition['value'];

    switch (type) {
      case 'user_logged_in':
        return AuthService.isLoggedIn;
      case 'has_permission':
        return PermissionService.hasPermission(value);
      case 'screen_size':
        final screenSize = MediaQuery.of(context).size;
        return _evaluateScreenSizeCondition(value, screenSize);
      case 'theme_mode':
        return Theme.of(context).brightness == _parseBrightness(value);
      default:
        return false;
    }
  }

  bool _evaluateScreenSizeCondition(Map<String, dynamic> value, Size screenSize) {
    final operator = value['operator'];
    final targetSize = value['size'].toDouble();

    switch (operator) {
      case 'width_greater_than':
        return screenSize.width > targetSize;
      case 'width_less_than':
        return screenSize.width < targetSize;
      case 'height_greater_than':
        return screenSize.height > targetSize;
      case 'height_less_than':
        return screenSize.height < targetSize;
      default:
        return false;
    }
  }

  Brightness _parseBrightness(String brightness) {
    switch (brightness) {
      case 'dark': return Brightness.dark;
      case 'light': return Brightness.light;
      default: return Brightness.light;
    }
  }
}
```

### 4.2 Dynamic Theme System

```dart
class DynamicThemeManager extends ChangeNotifier {
  static final Map<String, ThemeData> _themes = {};
  static String _currentTheme = 'default';

  static void registerTheme(String name, ThemeData theme) {
    _themes[name] = theme;
  }

  static ThemeData getCurrentTheme() {
    return _themes[_currentTheme] ?? ThemeData.light();
  }

  static void setTheme(String name) {
    if (_themes.containsKey(name)) {
      _currentTheme = name;
      // Notify listeners
    }
  }

  static ThemeData fromConfig(Map<String, dynamic> config) {
    return ThemeData(
      brightness: _parseBrightness(config['brightness']),
      primaryColor: PropertyParser.parseColor(config['primary_color']),
      colorScheme: ColorScheme.fromSeed(
        seedColor: PropertyParser.parseColor(config['seed_color']) ?? Colors.blue,
        brightness: _parseBrightness(config['brightness']),
      ),
      textTheme: _parseTextTheme(config['text_theme']),
    );
  }

  static Brightness _parseBrightness(String? brightness) {
    switch (brightness) {
      case 'dark': return Brightness.dark;
      case 'light': return Brightness.light;
      default: return Brightness.light;
    }
  }

  static TextTheme _parseTextTheme(Map<String, dynamic>? textTheme) {
    if (textTheme == null) return TextTheme();

    return TextTheme(
      headlineLarge: _parseTextStyle(textTheme['headline_large']),
      headlineMedium: _parseTextStyle(textTheme['headline_medium']),
      bodyLarge: _parseTextStyle(textTheme['body_large']),
      bodyMedium: _parseTextStyle(textTheme['body_medium']),
    );
  }

  static TextStyle? _parseTextStyle(Map<String, dynamic>? style) {
    if (style == null) return null;

    return TextStyle(
      fontSize: style['font_size']?.toDouble(),
      fontWeight: _parseFontWeight(style['font_weight']),
      color: PropertyParser.parseColor(style['color']),
    );
  }

  static FontWeight _parseFontWeight(String? weight) {
    switch (weight) {
      case 'bold': return FontWeight.bold;
      case 'w500': return FontWeight.w500;
      case 'w600': return FontWeight.w600;
      default: return FontWeight.normal;
    }
  }
}
```

## 5. State Management Integration

### 5.1 Configurable State Management

```dart
class ConfigurableBloc extends Bloc<ConfigurableEvent, ConfigurableState> {
  final Map<String, dynamic> config;

  ConfigurableBloc(this.config) : super(ConfigurableInitial()) {
    on<LoadConfiguration>(_onLoadConfiguration);
    on<UpdateConfiguration>(_onUpdateConfiguration);
  }

  Future<void> _onLoadConfiguration(
    LoadConfiguration event,
    Emitter<ConfigurableState> emit,
  ) async {
    emit(ConfigurableLoading());

    try {
      final configuration = await ConfigLoader.loadConfig(event.configName);
      emit(ConfigurableLoaded(configuration));
    } catch (e) {
      emit(ConfigurableError(e.toString()));
    }
  }

  Future<void> _onUpdateConfiguration(
    UpdateConfiguration event,
    Emitter<ConfigurableState> emit,
  ) async {
    final currentState = state;
    if (currentState is ConfigurableLoaded) {
      final updatedConfig = Map<String, dynamic>.from(currentState.config);
      updatedConfig.addAll(event.updates);
      emit(ConfigurableLoaded(updatedConfig));
    }
  }
}

abstract class ConfigurableEvent {}

class LoadConfiguration extends ConfigurableEvent {
  final String configName;
  LoadConfiguration(this.configName);
}

class UpdateConfiguration extends ConfigurableEvent {
  final Map<String, dynamic> updates;
  UpdateConfiguration(this.updates);
}

abstract class ConfigurableState {}

class ConfigurableInitial extends ConfigurableState {}

class ConfigurableLoading extends ConfigurableState {}

class ConfigurableLoaded extends ConfigurableState {
  final Map<String, dynamic> config;
  ConfigurableLoaded(this.config);
}

class ConfigurableError extends ConfigurableState {
  final String message;
  ConfigurableError(this.message);
}
```

## 6. Testing Advanced Features

### 6.1 Animation Testing

```dart
class AnimationTestUtils {
  static Future<void> testAnimation(
    WidgetTester tester,
    Widget widget,
    AnimationConfig config,
  ) async {
    await tester.pumpWidget(widget);

    // Wait for animation to complete
    await tester.pump(config.duration);

    // Verify animation completed
    expect(find.byType(widget.runtimeType), findsOneWidget);
  }

  static Future<void> testStaggeredAnimation(
    WidgetTester tester,
    List<AnimationConfig> configs,
  ) async {
    final totalDuration = configs.fold<Duration>(
      Duration.zero,
      (total, config) => total + config.duration,
    );

    await tester.pump(totalDuration);

    // Verify all animations completed
    for (final config in configs) {
      expect(find.byType(AnimatedFlexibleWidget), findsWidgets);
    }
  }
}
```

### 6.2 Performance Testing

```dart
class PerformanceTestUtils {
  static Future<void> testWidgetPerformance(
    WidgetTester tester,
    Widget widget,
  ) async {
    final stopwatch = Stopwatch()..start();

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    stopwatch.stop();

    // Assert performance is within acceptable limits
    expect(stopwatch.elapsedMilliseconds, lessThan(100));
  }

  static Future<void> testMemoryUsage(
    WidgetTester tester,
    Widget widget,
  ) async {
    final initialMemory = ProcessInfo.currentRss;

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    final finalMemory = ProcessInfo.currentRss;
    final memoryIncrease = finalMemory - initialMemory;

    // Assert memory usage is reasonable (less than 10MB increase)
    expect(memoryIncrease, lessThan(10 * 1024 * 1024));
  }
}
```

## 7. Advanced Configuration Examples

### 7.1 Complex Animation Configuration

```json
{
  "screen_type": "animated_login",
  "animations": {
    "entrance": {
      "type": "staggered",
      "delay": 100,
      "animations": [
        {
          "type": "fade",
          "duration_ms": 500,
          "curve": "easeIn"
        },
        {
          "type": "slide",
          "duration_ms": 600,
          "curve": "bounce",
          "properties": {
            "offset": { "x": 0, "y": 50 }
          }
        }
      ]
    }
  },
  "components": [
    {
      "type": "animated_container",
      "properties": {
        "animation": "entrance",
        "child": {
          "type": "text_field",
          "properties": {
            "hint": "Email",
            "border_radius": 12
          }
        }
      }
    }
  ]
}
```

### 7.2 Responsive Configuration

```json
{
  "screen_type": "responsive_login",
  "responsive_config": {
    "mobile": {
      "layout": "column",
      "padding": { "left": 16, "right": 16 },
      "spacing": 12
    },
    "tablet": {
      "layout": "row",
      "padding": { "left": 32, "right": 32 },
      "spacing": 16
    },
    "desktop": {
      "layout": "grid",
      "padding": { "left": 48, "right": 48 },
      "spacing": 24
    }
  },
  "components": [
    {
      "type": "adaptive_text_field",
      "properties": {
        "hint": "Email",
        "responsive_config": {
          "mobile": {
            "border_radius": 8,
            "margin": { "bottom": 8 }
          },
          "tablet": {
            "border_radius": 12,
            "margin": { "bottom": 12 }
          },
          "desktop": {
            "border_radius": 16,
            "margin": { "bottom": 16 }
          }
        }
      }
    }
  ]
}
```

## Conclusion

Advanced flexible UI techniques provide:

1. **Smooth Animations**: Configurable animation systems
2. **Responsive Design**: Adaptive layouts for all screen sizes
3. **Performance**: Optimized rendering and memory management
4. **Advanced Configuration**: Complex conditional rendering and dynamic theming
5. **State Management**: Integration with modern state management patterns
6. **Testing**: Comprehensive testing utilities for all features

These techniques enable building highly sophisticated and performant flexible UI systems that can adapt to various requirements and user preferences.
