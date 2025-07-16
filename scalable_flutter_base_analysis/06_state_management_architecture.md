# Kiến Trúc Quản Lý State - Flutter Base Source

## Triết Lý State Management

### Layered State Architecture

```
UI Layer (Presentation)
├── Widget State (Local)
├── Screen State (BLoC/Cubit)
└── Form State (FormBLoC)

Business Layer (Application)
├── Feature State (Feature BLoCs)
├── Cross-Feature State (Global BLoCs)
└── Use Case State (Command Pattern)

Data Layer (Infrastructure)
├── Repository State (Caching)
├── Network State (API Status)
└── Storage State (Persistence)
```

### State Management Principles

- **Single Source of Truth**: Mỗi piece of data có một source duy nhất
- **Unidirectional Data Flow**: Data flow theo một hướng rõ ràng
- **Immutable State**: State không thể thay đổi trực tiếp
- **Predictable Updates**: State updates có thể dự đoán được

## State Management Stack

### 1. BLoC Pattern Implementation

```dart
// Base BLoC class
abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  BaseBloc(super.initialState) {
    on<Event>((event, emit) async {
      try {
        await handleEvent(event, emit);
      } catch (error, stackTrace) {
        handleError(error, stackTrace, emit);
      }
    });
  }

  Future<void> handleEvent(Event event, Emitter<State> emit);

  void handleError(Object error, StackTrace stackTrace, Emitter<State> emit) {
    // Global error handling
    AppLogger.error('BLoC Error', error, stackTrace);

    if (state is BaseState) {
      emit((state as BaseState).copyWith(isLoading: false, error: error.toString()));
    }
  }
}

// Base State class
abstract class BaseState {
  final bool isLoading;
  final String? error;
  final DateTime lastUpdated;

  const BaseState({
    this.isLoading = false,
    this.error,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  BaseState copyWith({
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  });
}
```

### 2. Feature-Specific BLoCs

```dart
// Authentication BLoC
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       super(const AuthState.initial());

  @override
  Future<void> handleEvent(AuthEvent event, Emitter<AuthState> emit) async {
    switch (event) {
      case LoginRequested():
        await _handleLogin(event, emit);
        break;
      case LogoutRequested():
        await _handleLogout(event, emit);
        break;
      case CheckAuthStatus():
        await _handleCheckAuthStatus(event, emit);
        break;
    }
  }

  Future<void> _handleLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _loginUseCase(LoginParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }
}

// Authentication State
sealed class AuthState extends BaseState {
  const AuthState({
    super.isLoading,
    super.error,
    super.lastUpdated,
  });

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.authenticated({required User user}) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
}

class AuthInitial extends AuthState {
  const AuthInitial() : super();

  @override
  AuthState copyWith({
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return AuthInitial();
  }
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({
    required this.user,
    super.isLoading,
    super.error,
    super.lastUpdated,
  });

  @override
  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return AuthAuthenticated(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
```

### 3. Global State Management

```dart
// App-wide state
class AppBloc extends BaseBloc<AppEvent, AppState> {
  final ThemeService _themeService;
  final LocaleService _localeService;
  final ConnectivityService _connectivityService;

  AppBloc({
    required ThemeService themeService,
    required LocaleService localeService,
    required ConnectivityService connectivityService,
  }) : _themeService = themeService,
       _localeService = localeService,
       _connectivityService = connectivityService,
       super(AppState.initial());

  @override
  Future<void> handleEvent(AppEvent event, Emitter<AppState> emit) async {
    switch (event) {
      case AppInitialized():
        await _handleAppInitialized(emit);
        break;
      case ThemeChanged():
        await _handleThemeChanged(event, emit);
        break;
      case LocaleChanged():
        await _handleLocaleChanged(event, emit);
        break;
      case ConnectivityChanged():
        await _handleConnectivityChanged(event, emit);
        break;
    }
  }

  Future<void> _handleAppInitialized(Emitter<AppState> emit) async {
    emit(state.copyWith(isLoading: true));

    // Initialize app-wide services
    await Future.wait([
      _themeService.initialize(),
      _localeService.initialize(),
      _connectivityService.initialize(),
    ]);

    final theme = await _themeService.getCurrentTheme();
    final locale = await _localeService.getCurrentLocale();
    final isOnline = await _connectivityService.isConnected();

    emit(state.copyWith(
      isLoading: false,
      theme: theme,
      locale: locale,
      isOnline: isOnline,
    ));
  }
}

class AppState extends BaseState {
  final ThemeMode theme;
  final Locale locale;
  final bool isOnline;
  final String? deepLink;

  const AppState({
    this.theme = ThemeMode.system,
    this.locale = const Locale('en'),
    this.isOnline = true,
    this.deepLink,
    super.isLoading,
    super.error,
    super.lastUpdated,
  });

  factory AppState.initial() => const AppState();

  @override
  AppState copyWith({
    ThemeMode? theme,
    Locale? locale,
    bool? isOnline,
    String? deepLink,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return AppState(
      theme: theme ?? this.theme,
      locale: locale ?? this.locale,
      isOnline: isOnline ?? this.isOnline,
      deepLink: deepLink ?? this.deepLink,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
```

## State Persistence Strategy

### 1. Hydrated BLoC

```dart
// Persisted BLoC for important state
class PersistedBloc<Event, State> extends HydratedBloc<Event, State> {
  PersistedBloc(super.initialState);

  @override
  State? fromJson(Map<String, dynamic> json) {
    try {
      return fromJsonImplementation(json);
    } catch (e) {
      AppLogger.error('Failed to restore state from JSON', e);
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(State state) {
    try {
      return toJsonImplementation(state);
    } catch (e) {
      AppLogger.error('Failed to serialize state to JSON', e);
      return null;
    }
  }

  // Subclasses implement these
  State? fromJsonImplementation(Map<String, dynamic> json);
  Map<String, dynamic>? toJsonImplementation(State state);
}

// Settings BLoC with persistence
class SettingsBloc extends PersistedBloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState.initial());

  @override
  SettingsState? fromJsonImplementation(Map<String, dynamic> json) {
    return SettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJsonImplementation(SettingsState state) {
    return state.toJson();
  }
}
```

### 2. State Caching Strategy

```dart
class StateCache {
  static final Map<String, dynamic> _cache = {};
  static final Map<String, DateTime> _expiry = {};

  static void put<T>(String key, T value, {Duration? ttl}) {
    _cache[key] = value;

    if (ttl != null) {
      _expiry[key] = DateTime.now().add(ttl);
    }
  }

  static T? get<T>(String key) {
    // Check if expired
    final expiry = _expiry[key];
    if (expiry != null && DateTime.now().isAfter(expiry)) {
      _cache.remove(key);
      _expiry.remove(key);
      return null;
    }

    return _cache[key] as T?;
  }

  static void clear([String? key]) {
    if (key != null) {
      _cache.remove(key);
      _expiry.remove(key);
    } else {
      _cache.clear();
      _expiry.clear();
    }
  }
}
```

## State Synchronization

### 1. Cross-BLoC Communication

```dart
// Event bus for BLoC communication
class BlocEventBus {
  static final StreamController<BlocEvent> _controller =
      StreamController<BlocEvent>.broadcast();

  static Stream<T> on<T extends BlocEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  static void fire(BlocEvent event) {
    _controller.add(event);
  }
}

abstract class BlocEvent {
  final String source;
  final DateTime timestamp;

  BlocEvent(this.source) : timestamp = DateTime.now();
}

class UserUpdatedEvent extends BlocEvent {
  final User user;

  UserUpdatedEvent(this.user) : super('auth');
}

// Profile BLoC listening to auth events
class ProfileBloc extends BaseBloc<ProfileEvent, ProfileState> {
  late StreamSubscription _authSubscription;

  ProfileBloc() : super(ProfileState.initial()) {
    _authSubscription = BlocEventBus.on<UserUpdatedEvent>().listen((event) {
      add(ProfileEvent.userUpdated(event.user));
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
```

### 2. State Synchronization Service

```dart
class StateSyncService {
  final List<SyncableBloc> _blocs = [];
  Timer? _syncTimer;

  void registerBloc(SyncableBloc bloc) {
    _blocs.add(bloc);
  }

  void startSync({Duration interval = const Duration(minutes: 5)}) {
    _syncTimer = Timer.periodic(interval, (_) => _syncAll());
  }

  Future<void> _syncAll() async {
    for (final bloc in _blocs) {
      try {
        await bloc.sync();
      } catch (e) {
        AppLogger.error('Failed to sync ${bloc.runtimeType}', e);
      }
    }
  }

  void stopSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }
}

abstract class SyncableBloc {
  Future<void> sync();
}
```

## Performance Optimization

### 1. State Selector Pattern

```dart
// Efficient state selection
class StateSelector<T> extends BlocSelector<AppBloc, AppState, T> {
  StateSelector({
    required T Function(AppState) selector,
    required Widget Function(BuildContext, T) builder,
  }) : super(
    selector: selector,
    builder: (context, state) => builder(context, state),
  );
}

// Usage
StateSelector<ThemeMode>(
  selector: (state) => state.theme,
  builder: (context, theme) => ThemeWidget(theme: theme),
)

// Or with custom widget
class ThemeConsumer extends StateSelector<ThemeMode> {
  ThemeConsumer({required Widget Function(BuildContext, ThemeMode) builder})
    : super(
        selector: (state) => state.theme,
        builder: builder,
      );
}
```

### 2. State Debouncing

```dart
// Debounced BLoC for search
class SearchBloc extends BaseBloc<SearchEvent, SearchState> {
  final SearchRepository _repository;
  Timer? _debounceTimer;

  SearchBloc({required SearchRepository repository})
    : _repository = repository,
      super(SearchState.initial());

  @override
  Future<void> handleEvent(SearchEvent event, Emitter<SearchState> emit) async {
    switch (event) {
      case SearchQueryChanged():
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          add(SearchEvent.performSearch(event.query));
        });
        break;
      case SearchPerformSearch():
        await _performSearch(event, emit);
        break;
    }
  }

  Future<void> _performSearch(SearchPerformSearch event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) {
      emit(SearchState.initial());
      return;
    }

    emit(state.copyWith(isLoading: true));

    final result = await _repository.search(event.query);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (results) => emit(SearchState.loaded(
        query: event.query,
        results: results,
      )),
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
```

## Testing Strategy

### 1. BLoC Testing

```dart
group('AuthBloc', () {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      logoutUseCase: mockLogoutUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  blocTest<AuthBloc, AuthState>(
    'emits [loading, authenticated] when login succeeds',
    build: () {
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => Right(testUser));
      return authBloc;
    },
    act: (bloc) => bloc.add(AuthEvent.loginRequested(
      email: 'test@test.com',
      password: 'password',
    )),
    expect: () => [
      const AuthState.initial().copyWith(isLoading: true),
      AuthState.authenticated(user: testUser),
    ],
    verify: (_) {
      verify(() => mockLoginUseCase(LoginParams(
        email: 'test@test.com',
        password: 'password',
      ))).called(1);
    },
  );
});
```

### 2. State Integration Testing

```dart
testWidgets('App state integration test', (tester) async {
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppBloc()),
        BlocProvider(create: (_) => AuthBloc()),
      ],
      child: MaterialApp(
        home: HomePage(),
      ),
    ),
  );

  // Test initial state
  expect(find.text('Welcome'), findsOneWidget);

  // Trigger login
  await tester.tap(find.byKey(Key('login_button')));
  await tester.pumpAndSettle();

  // Verify state changes
  expect(find.text('Dashboard'), findsOneWidget);
});
```

## Benefits

### Development Benefits

- **Predictable State**: State changes có thể dự đoán
- **Easy Testing**: Test BLoCs độc lập
- **Clear Data Flow**: Luồng dữ liệu rõ ràng
- **Hot Reload**: Preserve state during development

### Performance Benefits

- **Selective Rebuilds**: Chỉ rebuild widgets cần thiết
- **State Caching**: Cache frequently used state
- **Lazy Loading**: Load state khi cần
- **Memory Management**: Auto cleanup unused state

### Maintenance Benefits

- **Centralized Logic**: Business logic tập trung
- **Separation of Concerns**: UI tách biệt khỏi business logic
- **Error Handling**: Centralized error handling
- **Debugging**: Easy state debugging with BLoC Inspector
