# WebView Architecture & Communication Integration

## 🏗️ Architecture Overview

A clean, maintainable 5-layer architecture for Flutter-WebView integration with robust communication strategies.

## 📐 System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App Layer                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │ UI/Screens  │  │ User Actions│  │  App State  │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
├─────────────────────────────────────────────────────────┤
│               WebView Management Layer                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │ WebView     │  │ Lifecycle   │  │ Performance │     │
│  │ Manager     │  │ Manager     │  │ Monitor     │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
├─────────────────────────────────────────────────────────┤
│                 Bridge Layer                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │ Message     │  │ Security    │  │ Event       │     │
│  │ Router      │  │ Validator   │  │ Handler     │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
├─────────────────────────────────────────────────────────┤
│                   WebView Layer                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │ InAppWebView│  │ JavaScript  │  │ Web Content │     │
│  │ Controller  │  │ Bridge      │  │ Handler     │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
├─────────────────────────────────────────────────────────┤
│                     Web Content Layer                  │
│           HTML + CSS + JavaScript + APIs               │
└─────────────────────────────────────────────────────────┘
```

## 🎯 Layer 1: WebView Management

### WebViewManager (Singleton Pattern)

```dart
class WebViewManager extends ChangeNotifier {
  static final WebViewManager _instance = WebViewManager._internal();
  factory WebViewManager() => _instance;
  WebViewManager._internal();

  final Map<String, InAppWebViewController> _controllers = {};
  final WebViewLifecycleManager _lifecycle = WebViewLifecycleManager();
  final WebViewPerformanceMonitor _performance = WebViewPerformanceMonitor();

  // Create and manage WebView instances
  Future<InAppWebViewController> createWebView(
    String id,
    WebViewConfig config
  ) async {
    final controller = await _createController(config);
    _controllers[id] = controller;
    _lifecycle.register(id, controller);
    _performance.startMonitoring(id);
    return controller;
  }

  // Get existing WebView
  InAppWebViewController? getWebView(String id) => _controllers[id];

  // Remove WebView with cleanup
  void removeWebView(String id) {
    _performance.stopMonitoring(id);
    _lifecycle.unregister(id);
    _controllers.remove(id);
    notifyListeners();
  }

  // Get performance metrics
  WebViewMetrics getMetrics(String id) => _performance.getMetrics(id);
}
```

### WebViewLifecycleManager

```dart
class WebViewLifecycleManager {
  final Map<String, InAppWebViewController> _activeControllers = {};
  final Map<String, DateTime> _lastActivity = {};
  final Map<String, WebViewState> _states = {};

  void register(String id, InAppWebViewController controller) {
    _activeControllers[id] = controller;
    _lastActivity[id] = DateTime.now();
    _states[id] = WebViewState.created;
    _setupLifecycleListeners(id, controller);
  }

  void _setupLifecycleListeners(String id, InAppWebViewController controller) {
    controller.addJavaScriptHandler(
      handlerName: 'lifecycle',
      callback: (args) => _handleLifecycleEvent(id, args),
    );
  }

  void _handleLifecycleEvent(String id, List<dynamic> args) {
    final event = args[0] as String;
    switch (event) {
      case 'load_start':
        _states[id] = WebViewState.loading;
        break;
      case 'load_finish':
        _states[id] = WebViewState.loaded;
        _updateActivity(id);
        break;
      case 'error':
        _states[id] = WebViewState.error;
        break;
    }
  }

  // Cleanup inactive WebViews
  void cleanupInactive({Duration threshold = const Duration(minutes: 10)}) {
    final now = DateTime.now();
    final toRemove = <String>[];

    _lastActivity.forEach((id, lastActivity) {
      if (now.difference(lastActivity) > threshold) {
        toRemove.add(id);
      }
    });

    for (final id in toRemove) {
      WebViewManager().removeWebView(id);
    }
  }

  void _updateActivity(String id) {
    _lastActivity[id] = DateTime.now();
  }
}
```

## 🌉 Layer 2: Bridge Communication

### MessageRouter

```dart
class MessageRouter {
  static final MessageRouter _instance = MessageRouter._internal();
  factory MessageRouter() => _instance;
  MessageRouter._internal();

  final Map<String, MessageHandler> _handlers = {};
  final SecurityValidator _validator = SecurityValidator();
  final MessageQueue _queue = MessageQueue();

  // Register message handler
  void registerHandler(String type, MessageHandler handler) {
    _handlers[type] = handler;
  }

  // Route incoming messages from WebView
  Future<dynamic> routeMessage(WebViewMessage message) async {
    // Security validation
    if (!await _validator.validateMessage(message)) {
      throw SecurityException('Message validation failed');
    }

    // Queue management for high-throughput scenarios
    await _queue.enqueue(message);

    // Find and execute handler
    final handler = _handlers[message.type];
    if (handler == null) {
      throw UnsupportedError('No handler for: ${message.type}');
    }

    return await handler.handle(message);
  }

  // Send message to WebView
  Future<void> sendToWebView(String webViewId, WebViewMessage message) async {
    final controller = WebViewManager().getWebView(webViewId);
    if (controller == null) {
      throw StateError('WebView not found: $webViewId');
    }

    // Add security signature
    message.signature = _validator.generateSignature(message);

    await controller.evaluateJavascript(source: '''
      if (window.handleFlutterMessage) {
        window.handleFlutterMessage(${jsonEncode(message.toJson())});
      }
    ''');
  }
}
```

### SecurityValidator

```dart
class SecurityValidator {
  static const String _secretKey = 'your-app-secret-key-change-this';
  static const Duration _messageTimeout = Duration(minutes: 5);

  Future<bool> validateMessage(WebViewMessage message) async {
    // Check message age (prevent replay attacks)
    if (_isMessageExpired(message.timestamp)) {
      return false;
    }

    // Validate message signature
    if (!_validateSignature(message)) {
      return false;
    }

    // Check allowed origins
    if (!_isAllowedOrigin(message.origin)) {
      return false;
    }

    // Validate message structure
    if (!_validateMessageStructure(message)) {
      return false;
    }

    return true;
  }

  bool _validateSignature(WebViewMessage message) {
    final expectedSignature = generateSignature(message);
    return expectedSignature == message.signature;
  }

  String generateSignature(WebViewMessage message) {
    final payload = '${message.type}:${message.data}:${message.timestamp}:$_secretKey';
    final bytes = utf8.encode(payload);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool _isMessageExpired(int timestamp) {
    final messageTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    return now.difference(messageTime) > _messageTimeout;
  }

  bool _isAllowedOrigin(String origin) {
    const allowedOrigins = [
      'https://yourdomain.com',
      'https://api.yourdomain.com',
      'https://auth.yourdomain.com',
    ];
    return allowedOrigins.contains(origin);
  }
}
```

## 📡 Communication Strategies

### 1. Flutter → WebView Communication

```dart
class FlutterToWebCommunication {
  final MessageRouter _router = MessageRouter();

  // Send data to WebView
  Future<void> sendDataToWeb(
    String webViewId,
    Map<String, dynamic> data
  ) async {
    final message = WebViewMessage(
      type: 'data_update',
      data: data,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      origin: 'flutter_app',
    );

    await _router.sendToWebView(webViewId, message);
  }

  // Update WebView theme
  Future<void> updateTheme(String webViewId, AppTheme theme) async {
    final message = WebViewMessage(
      type: 'theme_update',
      data: theme.toJson(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
      origin: 'flutter_app',
    );

    await _router.sendToWebView(webViewId, message);
  }

  // Navigate WebView
  Future<void> navigateWebView(String webViewId, String url) async {
    final controller = WebViewManager().getWebView(webViewId);
    await controller?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
  }

  // Execute JavaScript
  Future<void> executeJavaScript(String webViewId, String script) async {
    final controller = WebViewManager().getWebView(webViewId);
    await controller?.evaluateJavascript(source: script);
  }
}
```

### 2. WebView → Flutter Communication

```dart
class WebToFlutterCommunication {
  final MessageRouter _router = MessageRouter();

  void initialize(InAppWebViewController controller) {
    // Setup JavaScript handlers
    _setupJavaScriptHandlers(controller);
    _injectBridgeScript(controller);
  }

  void _setupJavaScriptHandlers(InAppWebViewController controller) {
    // Main communication channel
    controller.addJavaScriptHandler(
      handlerName: 'flutterBridge',
      callback: (args) => _handleBridgeMessage(args),
    );

    // User action tracking
    controller.addJavaScriptHandler(
      handlerName: 'userAction',
      callback: (args) => _handleUserAction(args),
    );

    // Navigation requests
    controller.addJavaScriptHandler(
      handlerName: 'navigate',
      callback: (args) => _handleNavigation(args),
    );

    // Error reporting
    controller.addJavaScriptHandler(
      handlerName: 'errorReport',
      callback: (args) => _handleError(args),
    );
  }

  Future<void> _handleBridgeMessage(List<dynamic> args) async {
    try {
      final messageData = args[0] as Map<String, dynamic>;
      final message = WebViewMessage.fromJson(messageData);
      await _router.routeMessage(message);
    } catch (e) {
      print('Bridge message error: $e');
    }
  }

  void _injectBridgeScript(InAppWebViewController controller) {
    controller.evaluateJavascript(source: '''
      // Flutter Bridge JavaScript
      window.FlutterBridge = {
        // Send message to Flutter
        send: function(type, data) {
          const message = {
            type: type,
            data: data,
            timestamp: Date.now(),
            origin: window.location.origin
          };
          window.flutter_inappwebview.callHandler('flutterBridge', message);
        },

        // Track user actions
        trackAction: function(action, params) {
          window.flutter_inappwebview.callHandler('userAction', {
            action: action,
            params: params,
            page: window.location.pathname,
            timestamp: Date.now()
          });
        },

        // Request navigation
        navigate: function(route, params) {
          window.flutter_inappwebview.callHandler('navigate', {
            route: route,
            params: params || {}
          });
        },

        // Report errors
        reportError: function(error, context) {
          window.flutter_inappwebview.callHandler('errorReport', {
            error: error.toString(),
            context: context,
            url: window.location.href,
            timestamp: Date.now()
          });
        }
      };

      // Auto-track clicks
      document.addEventListener('click', function(e) {
        if (e.target.dataset.flutterAction) {
          FlutterBridge.trackAction(e.target.dataset.flutterAction, {
            element: e.target.tagName,
            text: e.target.textContent,
            id: e.target.id
          });
        }
      });

      // Global error handler
      window.onerror = function(msg, url, line, col, error) {
        FlutterBridge.reportError(error || msg, {
          url: url,
          line: line,
          column: col
        });
      };
    ''');
  }
}
```

## 🔄 State Synchronization

### Bidirectional State Management

```dart
class WebViewStateSync extends ChangeNotifier {
  final Map<String, dynamic> _sharedState = {};
  final List<String> _connectedWebViews = [];

  // Sync Flutter state to all WebViews
  void syncStateToWebViews(Map<String, dynamic> state) {
    _sharedState.addAll(state);

    for (final webViewId in _connectedWebViews) {
      FlutterToWebCommunication().sendDataToWeb(webViewId, _sharedState);
    }

    notifyListeners();
  }

  // Update state from WebView
  void updateFromWebView(String webViewId, Map<String, dynamic> updates) {
    _sharedState.addAll(updates);

    // Sync to other WebViews (excluding sender)
    for (final otherId in _connectedWebViews) {
      if (otherId != webViewId) {
        FlutterToWebCommunication().sendDataToWeb(otherId, updates);
      }
    }

    notifyListeners();
  }

  // Register WebView for state sync
  void connectWebView(String webViewId) {
    if (!_connectedWebViews.contains(webViewId)) {
      _connectedWebViews.add(webViewId);
      // Send initial state
      FlutterToWebCommunication().sendDataToWeb(webViewId, _sharedState);
    }
  }

  void disconnectWebView(String webViewId) {
    _connectedWebViews.remove(webViewId);
  }
}
```

## 🎮 WebView Service Layer

### High-level WebView Service

```dart
class WebViewService {
  final WebViewManager _manager = WebViewManager();
  final FlutterToWebCommunication _toWeb = FlutterToWebCommunication();
  final WebToFlutterCommunication _fromWeb = WebToFlutterCommunication();
  final WebViewStateSync _stateSync = WebViewStateSync();

  // Create configured WebView
  Future<String> createWebView({
    required String url,
    WebViewConfig? config,
    Map<String, dynamic>? initialData,
  }) async {
    final webViewId = _generateWebViewId();
    final webViewConfig = config ?? WebViewConfig.defaultConfig();

    final controller = await _manager.createWebView(webViewId, webViewConfig);
    _fromWeb.initialize(controller);
    _stateSync.connectWebView(webViewId);

    // Load URL
    await controller.loadUrl(urlRequest: URLRequest(url: WebUri(url)));

    // Send initial data if provided
    if (initialData != null) {
      await _toWeb.sendDataToWeb(webViewId, initialData);
    }

    return webViewId;
  }

  // Remove WebView
  void removeWebView(String webViewId) {
    _stateSync.disconnectWebView(webViewId);
    _manager.removeWebView(webViewId);
  }

  // Send data to specific WebView
  Future<void> sendData(String webViewId, Map<String, dynamic> data) async {
    await _toWeb.sendDataToWeb(webViewId, data);
  }

  // Update theme for all WebViews
  Future<void> updateTheme(AppTheme theme) async {
    final activeWebViews = _manager.getActiveWebViews();
    for (final webViewId in activeWebViews) {
      await _toWeb.updateTheme(webViewId, theme);
    }
  }

  String _generateWebViewId() {
    return 'webview_${DateTime.now().millisecondsSinceEpoch}';
  }
}
```

## 📊 Performance Monitoring

### WebViewPerformanceMonitor

```dart
class WebViewPerformanceMonitor {
  final Map<String, WebViewMetrics> _metrics = {};
  final Map<String, Timer> _monitors = {};

  void startMonitoring(String webViewId) {
    _metrics[webViewId] = WebViewMetrics();

    _monitors[webViewId] = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _collectMetrics(webViewId),
    );
  }

  void stopMonitoring(String webViewId) {
    _monitors[webViewId]?.cancel();
    _monitors.remove(webViewId);
  }

  Future<void> _collectMetrics(String webViewId) async {
    final controller = WebViewManager().getWebView(webViewId);
    if (controller == null) return;

    try {
      // Get memory usage
      final memoryResult = await controller.evaluateJavascript(source: '''
        JSON.stringify({
          usedJSHeapSize: performance.memory?.usedJSHeapSize || 0,
          totalJSHeapSize: performance.memory?.totalJSHeapSize || 0,
          jsHeapSizeLimit: performance.memory?.jsHeapSizeLimit || 0
        })
      ''');

      final memoryData = jsonDecode(memoryResult.toString());
      _metrics[webViewId]?.updateMemory(memoryData);

      // Get page load metrics
      final performanceResult = await controller.evaluateJavascript(source: '''
        JSON.stringify({
          loadEventEnd: performance.timing.loadEventEnd,
          navigationStart: performance.timing.navigationStart,
          domContentLoadedEventEnd: performance.timing.domContentLoadedEventEnd
        })
      ''');

      final performanceData = jsonDecode(performanceResult.toString());
      _metrics[webViewId]?.updatePerformance(performanceData);

    } catch (e) {
      print('Performance monitoring error: $e');
    }
  }

  WebViewMetrics getMetrics(String webViewId) {
    return _metrics[webViewId] ?? WebViewMetrics();
  }
}
```

## 🎯 Benefits & Use Cases

### Architecture Benefits

✅ **Separation of Concerns** - Clear layer boundaries
✅ **Maintainability** - Easy to debug and extend  
✅ **Security** - Built-in validation and protection
✅ **Performance** - Optimized resource management
✅ **Scalability** - Support multiple WebView instances
✅ **Testability** - Each layer can be tested independently

### Common Implementation Patterns

#### 1. Authentication Flow

```dart
final authWebViewId = await WebViewService().createWebView(
  url: 'https://auth.yourdomain.com/login',
  initialData: {'returnUrl': '/dashboard'}
);
```

#### 2. Payment Gateway

```dart
final paymentWebViewId = await WebViewService().createWebView(
  url: 'https://payment.gateway.com/checkout',
  config: WebViewConfig(
    securityLevel: SecurityLevel.high,
    allowFileAccess: false,
  ),
);
```

#### 3. Content Display

```dart
final contentWebViewId = await WebViewService().createWebView(
  url: 'https://cms.yourdomain.com/content',
  initialData: {
    'theme': currentTheme.toJson(),
    'user': currentUser.toJson(),
  },
);
```

#### 4. Hybrid Dashboard

```dart
final dashboardWebViewId = await WebViewService().createWebView(
  url: 'https://dashboard.yourdomain.com',
  config: WebViewConfig(
    enableJavaScript: true,
    enableCaching: true,
  ),
);
```

This architecture provides a robust foundation for seamless Flutter-WebView integration with enterprise-grade security, performance, and maintainability.
