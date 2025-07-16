# Chiến Lược Tính Module Của Feature - Flutter Base Source

## Triết Lý Feature Modularity

### Domain-Driven Design (DDD)

```
Bounded Context (Feature Module)
├── Domain Layer (Business Logic)
├── Application Layer (Use Cases)
├── Infrastructure Layer (Data)
└── Presentation Layer (UI)
```

### Nguyên Tắc Cốt Lõi

- **Autonomous Features**: Mỗi feature hoạt động độc lập
- **Minimal Coupling**: Ít phụ thuộc lẫn nhau
- **Clear Boundaries**: Ranh giới rõ ràng giữa features
- **Easy Integration**: Dễ dàng tích hợp features mới

## Feature Module Structure

### Standard Feature Template

```
features/
├── authentication/
│   ├── domain/
│   │   ├── entities/user.dart
│   │   ├── repositories/auth_repository.dart
│   │   └── usecases/login_usecase.dart
│   ├── application/
│   │   ├── bloc/auth_bloc.dart
│   │   └── services/auth_service.dart
│   ├── infrastructure/
│   │   ├── datasources/auth_remote_datasource.dart
│   │   └── repositories/auth_repository_impl.dart
│   ├── presentation/
│   │   ├── pages/login_page.dart
│   │   └── widgets/login_form.dart
│   ├── auth_feature.dart          # Feature registration
│   └── auth_exports.dart          # Public API exports
```

### Feature Registration System

```dart
abstract class FeatureModule {
  String get name;
  List<String> get dependencies;

  void registerServices(GetIt container);
  void registerRoutes(GoRouter router);
  List<NavigationItem> get navigationItems;

  Future<void> initialize();
  Future<void> dispose();
}

class AuthFeature implements FeatureModule {
  @override
  String get name => 'authentication';

  @override
  List<String> get dependencies => ['core', 'networking'];

  @override
  void registerServices(GetIt container) {
    container.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: container(),
        localDataSource: container(),
      ),
    );

    container.registerFactory<AuthBloc>(
      () => AuthBloc(loginUseCase: container()),
    );
  }
}
```

## Feature Communication Patterns

### 1. Event-Driven Communication

```dart
abstract class FeatureEvent {
  final String featureName;
  final DateTime timestamp;
}

class UserLoggedInEvent extends FeatureEvent {
  final User user;
  UserLoggedInEvent(this.user) : super('authentication');
}

class EventBus {
  static final StreamController<FeatureEvent> _controller =
      StreamController<FeatureEvent>.broadcast();

  static Stream<T> on<T extends FeatureEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  static void fire(FeatureEvent event) {
    _controller.add(event);
  }
}
```

### 2. Shared Contracts

```dart
abstract class UserProvider {
  Future<User?> getCurrentUser();
  Stream<User?> get userStream;
}

abstract class NotificationProvider {
  Future<void> showNotification(String message);
  Future<void> showError(String error);
}

// Features depend on contracts, not implementations
class OrderFeature implements FeatureModule {
  @override
  void registerServices(GetIt container) {
    container.registerFactory<CreateOrderUseCase>(
      () => CreateOrderUseCase(
        userProvider: container<UserProvider>(),
        notificationProvider: container<NotificationProvider>(),
      ),
    );
  }
}
```

## Feature Manager

```dart
class FeatureManager {
  static final Map<String, FeatureModule> _features = {};
  static final Map<String, bool> _featureStates = {};

  static void registerFeature(FeatureModule feature) {
    _features[feature.name] = feature;
    _featureStates[feature.name] = false;
  }

  static Future<void> initializeFeatures() async {
    final sortedFeatures = _topologicalSort(_features.values.toList());

    for (final feature in sortedFeatures) {
      try {
        await feature.initialize();
        feature.registerServices(GetIt.instance);
        _featureStates[feature.name] = true;

        print('✅ Feature "${feature.name}" initialized');
      } catch (e) {
        print('❌ Failed to initialize "${feature.name}": $e');
        _featureStates[feature.name] = false;
      }
    }
  }

  static bool isFeatureAvailable(String featureName) {
    return _featureStates[featureName] ?? false;
  }
}
```

## Feature Templates

### CRUD Feature Template

```dart
abstract class CrudFeature<T> implements FeatureModule {
  String get entityName;

  Widget createListPage();
  Widget createDetailPage(String id);
  Widget createEditPage(String? id);

  UseCase<List<T>, NoParams> getListUseCase();
  UseCase<T, String> getByIdUseCase();
  UseCase<T, T> createUseCase();
  UseCase<T, T> updateUseCase();
  UseCase<void, String> deleteUseCase();
}

class ProductFeature extends CrudFeature<Product> {
  @override
  String get entityName => 'product';

  @override
  String get name => 'products';

  @override
  Widget createListPage() => ProductListPage();
}
```

## Feature Configuration

```dart
class FeatureConfig {
  final String name;
  final bool enabled;
  final Map<String, dynamic> settings;
  final List<String> enabledEnvironments;
}

class FeatureConfigManager {
  static final Map<String, FeatureConfig> _configs = {};

  static Future<void> loadConfigurations() async {
    final remoteConfig = await RemoteConfigService.getFeatureConfigs();
    final localConfig = await LocalConfigService.getFeatureConfigs();

    final mergedConfig = {...localConfig, ...remoteConfig};

    for (final entry in mergedConfig.entries) {
      _configs[entry.key] = FeatureConfig.fromMap(entry.value);
    }
  }

  static bool isFeatureEnabled(String featureName) {
    final config = _configs[featureName];
    if (config == null) return false;

    final currentEnv = Environment.current;
    if (!config.enabledEnvironments.contains(currentEnv)) return false;

    return config.enabled;
  }
}
```

## Testing Strategy

### Feature Isolation Testing

```dart
testWidgets('Auth feature works in isolation', (tester) async {
  final testContainer = GetIt.asNewInstance();
  final authFeature = AuthFeature();
  authFeature.registerServices(testContainer);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(MockAuthRepository()),
      ],
      child: MaterialApp(home: LoginPage()),
    ),
  );

  await tester.enterText(find.byKey(Key('email_field')), 'test@test.com');
  await tester.tap(find.byKey(Key('login_button')));

  expect(find.text('Welcome!'), findsOneWidget);
});
```

## Benefits

### Development Benefits

- **Parallel Development**: Teams làm việc độc lập
- **Clear Ownership**: Mỗi team sở hữu feature riêng
- **Easier Testing**: Test feature độc lập
- **Faster Build Times**: Build chỉ feature thay đổi

### Maintenance Benefits

- **Isolated Changes**: Thay đổi không ảnh hưởng features khác
- **Easy Debugging**: Bug isolation dễ dàng
- **Gradual Migration**: Migrate từng feature một
- **Feature Toggling**: Bật/tắt feature dễ dàng

### Business Benefits

- **Feature Experimentation**: A/B test features
- **Rapid Deployment**: Deploy feature riêng biệt
- **Market Adaptation**: Thêm/bớt features theo thị trường
- **Customer Customization**: Tùy chỉnh features cho từng khách hàng

## Implementation Guidelines

### Feature Design Checklist

- [ ] Clear domain boundaries
- [ ] Minimal external dependencies
- [ ] Well-defined public API
- [ ] Comprehensive test coverage
- [ ] Documentation complete
- [ ] Performance optimized
- [ ] Accessibility compliant
- [ ] Error handling robust

### Development Workflow

1. **Analysis**: Domain analysis và requirements
2. **Design**: API design và architecture
3. **Implementation**: Clean architecture layers
4. **Testing**: Unit, integration, e2e tests
5. **Documentation**: API docs, usage examples
6. **Integration**: Feature registration và testing
7. **Deployment**: Feature flag rollout
