# Thiết Kế Cấu Trúc Thư Mục - Flutter Base Source

## Cấu Trúc Thư Mục Tổng Quan

```
lib/
├── core/                           # Core foundation
│   ├── base/                      # Base classes
│   ├── constants/                 # App constants
│   ├── extensions/                # Dart extensions
│   ├── utils/                     # Utility functions
│   └── errors/                    # Error handling
├── config/                        # Configuration
│   ├── app_config.dart           # App configuration
│   ├── environment_config.dart   # Environment settings
│   └── injection_container.dart  # Dependency injection
├── shared/                        # Shared modules
│   ├── data/                     # Shared data layer
│   ├── domain/                   # Shared domain layer
│   ├── presentation/             # Shared UI components
│   └── services/                 # Shared services
├── features/                      # Feature modules
│   ├── authentication/           # Auth feature
│   ├── profile/                  # Profile feature
│   ├── dashboard/                # Dashboard feature
│   ├── settings/                 # Settings feature
│   └── notifications/            # Notification feature
├── ui_kit/                       # UI Component Library
│   ├── components/               # Reusable components
│   ├── themes/                   # Theme definitions
│   ├── colors/                   # Color schemes
│   ├── typography/               # Text styles
│   └── layouts/                  # Layout components
├── navigation/                   # Navigation system
│   ├── app_router.dart          # Main router
│   ├── route_names.dart         # Route constants
│   └── navigation_service.dart   # Navigation utilities
└── main.dart                     # App entry point
```

## Chi Tiết Từng Thư Mục

### 1. Core Foundation (`lib/core/`)

```
core/
├── base/
│   ├── base_widget.dart          # Base widget class
│   ├── base_state.dart           # Base state management
│   ├── base_repository.dart      # Base repository pattern
│   ├── base_use_case.dart        # Base use case pattern
│   └── base_model.dart           # Base data model
├── constants/
│   ├── app_constants.dart        # General constants
│   ├── api_constants.dart        # API endpoints
│   ├── storage_keys.dart         # Storage key constants
│   └── regex_patterns.dart       # Validation patterns
├── extensions/
│   ├── string_extensions.dart    # String utilities
│   ├── context_extensions.dart   # BuildContext extensions
│   ├── datetime_extensions.dart  # DateTime utilities
│   └── widget_extensions.dart    # Widget helpers
├── utils/
│   ├── validators.dart           # Input validation
│   ├── formatters.dart          # Data formatting
│   ├── helpers.dart             # Helper functions
│   └── logger.dart              # Logging utility
└── errors/
    ├── exceptions.dart           # Custom exceptions
    ├── failures.dart            # Failure handling
    └── error_handler.dart       # Global error handler
```

### 2. Configuration (`lib/config/`)

```
config/
├── app_config.dart              # Main app configuration
├── environment_config.dart      # Dev/Staging/Prod configs
├── injection_container.dart     # Service locator setup
├── route_config.dart           # Route configuration
└── theme_config.dart           # Theme configuration
```

### 3. Shared Modules (`lib/shared/`)

```
shared/
├── data/
│   ├── datasources/            # Remote & local data sources
│   ├── models/                 # Data models
│   ├── repositories/           # Repository implementations
│   └── providers/              # Data providers
├── domain/
│   ├── entities/               # Domain entities
│   ├── repositories/           # Repository contracts
│   ├── usecases/              # Business logic
│   └── value_objects/         # Value objects
├── presentation/
│   ├── widgets/               # Common widgets
│   ├── pages/                 # Shared pages
│   ├── bloc/                  # Shared state management
│   └── providers/             # UI providers
└── services/
    ├── api_service.dart       # HTTP client
    ├── storage_service.dart   # Local storage
    ├── cache_service.dart     # Caching logic
    ├── notification_service.dart # Push notifications
    └── analytics_service.dart # Analytics tracking
```

### 4. Feature Modules (`lib/features/`)

```
features/
├── authentication/
│   ├── data/
│   │   ├── datasources/       # Auth API calls
│   │   ├── models/           # Auth models
│   │   └── repositories/     # Auth repository impl
│   ├── domain/
│   │   ├── entities/         # User entity
│   │   ├── repositories/     # Auth repository contract
│   │   └── usecases/         # Login, logout, register
│   └── presentation/
│       ├── pages/            # Login, register pages
│       ├── widgets/          # Auth-specific widgets
│       └── bloc/             # Auth state management
├── profile/
├── dashboard/
├── settings/
└── notifications/
```

### 5. UI Kit (`lib/ui_kit/`)

```
ui_kit/
├── components/
│   ├── buttons/              # Button variants
│   ├── inputs/               # Input field variants
│   ├── cards/                # Card components
│   ├── dialogs/              # Dialog components
│   ├── lists/                # List components
│   ├── navigation/           # Navigation components
│   ├── indicators/           # Progress, loading indicators
│   └── media/                # Image, video components
├── themes/
│   ├── app_theme.dart        # Main theme definition
│   ├── light_theme.dart      # Light theme
│   ├── dark_theme.dart       # Dark theme
│   └── theme_extensions.dart # Custom theme extensions
├── colors/
│   ├── app_colors.dart       # Color palette
│   ├── color_schemes.dart    # Material color schemes
│   └── brand_colors.dart     # Brand-specific colors
├── typography/
│   ├── app_text_styles.dart  # Text style definitions
│   ├── font_weights.dart     # Font weight constants
│   └── font_sizes.dart       # Font size scales
└── layouts/
    ├── responsive_layout.dart # Responsive containers
    ├── grid_layout.dart      # Grid system
    └── spacing.dart          # Spacing constants
```

### 6. Navigation (`lib/navigation/`)

```
navigation/
├── app_router.dart           # GoRouter configuration
├── route_names.dart          # Route name constants
├── navigation_service.dart   # Navigation utilities
├── route_guards.dart         # Route protection
└── deep_link_handler.dart    # Deep link handling
```

## Assets Structure

```
assets/
├── images/
│   ├── icons/               # App icons
│   ├── logos/               # Brand logos
│   ├── illustrations/       # Illustrations
│   └── backgrounds/         # Background images
├── fonts/                   # Custom fonts
├── animations/              # Lottie animations
└── config/                  # Asset configurations
    └── app_config.json      # App configuration file
```

## Lợi Ích Cấu Trúc

### 1. Tách Biệt Rõ Ràng (Separation of Concerns)

- Core logic tách biệt với UI
- Feature modules độc lập
- Shared code tái sử dụng được

### 2. Dễ Bảo Trì (Maintainable)

- Tìm file nhanh chóng
- Cấu trúc logic rõ ràng
- Dễ refactor và nâng cấp

### 3. Mở Rộng Dễ Dàng (Scalable)

- Thêm feature mới đơn giản
- Không ảnh hưởng code cũ
- Team có thể làm việc song song

### 4. Tái Sử Dụng Cao (Reusable)

- Component library sẵn sàng
- Utilities và helpers chung
- Theme system linh hoạt

## Best Practices

### 1. Naming Convention

- **Files**: snake_case
- **Classes**: PascalCase
- **Variables**: camelCase
- **Constants**: UPPER_SNAKE_CASE

### 2. Import Organization

```dart
// Dart imports
import 'dart:async';

// Flutter imports
import 'package:flutter/material.dart';

// Package imports
import 'package:bloc/bloc.dart';

// Project imports
import 'package:app/core/core.dart';
import 'package:app/shared/shared.dart';
```

### 3. Export Files

- Mỗi thư mục có file barrel export
- Đơn giản hóa imports
- Kiểm soát public API
