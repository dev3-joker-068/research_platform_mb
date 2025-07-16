# Best Practices Guide - Flutter Base Source

## Code Organization

### Naming Conventions

```dart
// Files: snake_case
user_profile_page.dart
auth_repository_impl.dart

// Classes: PascalCase
class UserProfilePage {}
class AuthRepositoryImpl {}

// Variables: camelCase
String userName = 'John';
void getUserData() {}

// Constants: UPPER_SNAKE_CASE
const String API_BASE_URL = 'https://api.example.com';
```

### Import Organization

```dart
// 1. Dart imports
import 'dart:async';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

// 4. Project imports
import 'package:app/core/core.dart';
import 'package:app/shared/shared.dart';
```

## Architecture Best Practices

### Clean Architecture Layers

```dart
// Domain Layer - Pure business logic
abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
}

// Data Layer - Implementation details
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await localDataSource.saveUser(user);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
```

### Dependency Injection

```dart
// ✅ Good: Use dependency injection
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrderUseCase _createOrderUseCase;

  OrderBloc({required CreateOrderUseCase createOrderUseCase})
    : _createOrderUseCase = createOrderUseCase,
      super(OrderState.initial());
}

// ❌ Bad: Direct instantiation
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderState.initial()) {
    final repository = OrderRepositoryImpl(); // Tight coupling
  }
}
```

## Widget Best Practices

### Widget Composition

```dart
// ✅ Good: Small, focused widgets
class UserProfileCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;

  const UserProfileCard({
    Key? key,
    required this.user,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: UserAvatar(user: user),
        title: UserName(user: user),
        subtitle: UserEmail(user: user),
        onTap: onTap,
      ),
    );
  }
}
```

### Performance Optimization

```dart
// Use const constructors
const AppButton(
  text: 'Click me',
  onPressed: handleClick,
);

// Use ListView.builder for large lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
);

// Cache expensive computations
final processedData = useMemoized(
  () => processData(data),
  [data],
);
```

## Testing Best Practices

### Unit Testing

```dart
group('AuthBloc', () {
  late AuthBloc authBloc;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    authBloc = AuthBloc(repository: mockRepository);
  });

  blocTest<AuthBloc, AuthState>(
    'emits [loading, authenticated] when login succeeds',
    build: () {
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => Right(testUser));
      return authBloc;
    },
    act: (bloc) => bloc.add(LoginRequested('email', 'password')),
    expect: () => [
      AuthState.loading(),
      AuthState.authenticated(testUser),
    ],
  );
});
```

### Widget Testing

```dart
testWidgets('displays login form', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider(
        create: (_) => MockAuthBloc(),
        child: LoginPage(),
      ),
    ),
  );

  expect(find.byKey(Key('email_field')), findsOneWidget);
  expect(find.byKey(Key('password_field')), findsOneWidget);
  expect(find.byKey(Key('login_button')), findsOneWidget);
});
```

## Security Best Practices

### Data Protection

```dart
// Use secure storage for sensitive data
class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
```

### Network Security

```dart
// Use certificate pinning and auth interceptors
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorageService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

## Documentation Best Practices

### Code Documentation

````dart
/// A widget that displays user information in a card format.
///
/// Example usage:
/// ```dart
/// UserCard(
///   user: currentUser,
///   onTap: () => navigateToProfile(),
/// )
/// ```
class UserCard extends StatelessWidget {
  /// The user whose information to display.
  final User user;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  const UserCard({
    Key? key,
    required this.user,
    this.onTap,
  }) : super(key: key);
}
````

## Accessibility Best Practices

### Semantic Widgets

```dart
// Use Semantics for custom widgets
Semantics(
  label: 'User profile picture',
  button: true,
  onTap: () => selectProfilePicture(),
  child: CircleAvatar(
    backgroundImage: NetworkImage(user.avatarUrl),
  ),
);

// Provide meaningful labels
TextField(
  decoration: InputDecoration(
    labelText: 'Email address',
    hintText: 'Enter your email',
  ),
  keyboardType: TextInputType.emailAddress,
);
```

## Error Handling Best Practices

### Centralized Error Handling

```dart
class ErrorHandler {
  static String getMessage(Object error) {
    switch (error.runtimeType) {
      case ServerException:
        return 'Server error occurred';
      case NetworkException:
        return 'Network connection failed';
      case ValidationException:
        return (error as ValidationException).message;
      default:
        return 'An unexpected error occurred';
    }
  }
}

// Use Result/Either pattern
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
```

## Performance Best Practices

### Memory Management

```dart
// Dispose resources properly
class VideoPlayerWidget extends StatefulWidget {
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('url');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### Build Optimization

```dart
// ✅ Good: Create objects once
class MyWidget extends StatelessWidget {
  static const EdgeInsets _padding = EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      child: Text('Hello'),
    );
  }
}

// ❌ Bad: Create every build
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0), // Created every build
      child: Text('Hello'),
    );
  }
}
```

## Quality Assurance

### Code Quality Checks

```bash
# Automated quality checks
flutter analyze
flutter test --coverage
flutter format --check

# Quality gate in CI/CD
if [[ $coverage -lt 80 ]]; then
  echo "Coverage below 80%"
  exit 1
fi
```

### Linting Rules

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    - always_declare_return_types
    - avoid_print
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - sort_pub_dependencies
```

## Key Takeaways

### Development Principles

- **Consistency**: Follow established patterns
- **Simplicity**: Keep code simple and readable
- **Testability**: Write testable code
- **Performance**: Optimize for smooth UX
- **Security**: Protect user data
- **Accessibility**: Make apps inclusive

### Team Collaboration

- **Code Reviews**: Mandatory for all changes
- **Documentation**: Keep docs up to date
- **Testing**: Maintain high test coverage
- **Standards**: Follow coding standards
- **Communication**: Clear commit messages and PR descriptions
