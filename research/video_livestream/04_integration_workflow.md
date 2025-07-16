# Integration Workflow

## Overview

Detailed workflow design for interaction between video/live stream and other components in Flutter application, focusing on architecture design, state management, and data flow for HLS streaming.

## System Architecture Overview

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Application                     │
├─────────────────────────────────────────────────────────────┤
│  UI Layer (Widgets)                                        │
│  ├── Video Player UI                                       │
│  ├── Controls & Overlays                                   │
│  └── Interactive Elements                                  │
├─────────────────────────────────────────────────────────────┤
│  Business Logic Layer                                      │
│  ├── Video Player Manager                                  │
│  ├── HLS Streaming Service                                 │
│  ├── State Management (Bloc/Provider)                     │
│  └── Event Handlers                                       │
├─────────────────────────────────────────────────────────────┤
│  Data Layer                                               │
│  ├── Video Repository                                     │
│  ├── HLS Cache Manager                                    │
│  ├── Network Client                                       │
│  └── Local Storage                                        │
├─────────────────────────────────────────────────────────────┤
│  Platform Layer                                           │
│  ├── Native Video Players (iOS/Android)                  │
│  ├── Network Stack                                        │
│  └── Hardware Acceleration                                │
└─────────────────────────────────────────────────────────────┘
```

## Component Interaction Workflow

### 1. HLS Video Initialization Flow

```dart
class HLSVideoInitializationWorkflow {
  static Future<void> initializeHLSVideo(String hlsUrl) async {
    // Step 1: Validate HLS URL format (.m3u8)
    final isValidHLS = await HLSValidator.validateUrl(hlsUrl);
    if (!isValidHLS) throw InvalidHLSUrlException();

    // Step 2: Initialize HLS-optimized player
    final player = await VideoPlayerFactory.createHLSPlayer();

    // Step 3: Configure HLS-specific settings
    await HLSConfigManager.configurePlayer(player);

    // Step 4: Setup HLS event listeners
    EventManager.setupHLSEventListeners(player);

    // Step 5: Initialize UI components
    UIManager.initializeVideoUI(player);

    // Step 6: Start loading HLS stream
    await player.load(hlsUrl);
  }
}
```

### 2. State Management Flow

#### Video Player State Architecture

```dart
// HLS Video Player States
enum HLSVideoPlayerState {
  uninitialized,
  loadingManifest,
  manifestLoaded,
  loadingSegments,
  playing,
  paused,
  buffering,
  qualitySwitching,
  ended,
  error,
}

// HLS Quality States
enum HLSQuality {
  auto,
  low_480p,
  medium_720p,
  high_1080p,
}

class HLSVideoPlayerBloc extends Bloc<HLSVideoPlayerEvent, HLSVideoPlayerState> {
  final VideoRepository repository;
  final HLSNetworkMonitor networkMonitor;

  HLSVideoPlayerBloc({
    required this.repository,
    required this.networkMonitor,
  }) : super(HLSVideoPlayerUninitialized()) {
    on<HLSVideoPlayerInitialize>(_onInitialize);
    on<HLSVideoPlayerPlay>(_onPlay);
    on<HLSVideoPlayerPause>(_onPause);
    on<HLSVideoPlayerSeek>(_onSeek);
    on<HLSQualityChange>(_onQualityChange);
    on<HLSVideoPlayerError>(_onError);
  }

  Future<void> _onInitialize(
    HLSVideoPlayerInitialize event,
    Emitter<HLSVideoPlayerState> emit,
  ) async {
    emit(HLSVideoPlayerLoadingManifest());

    try {
      // Initialize HLS player
      await repository.initializeHLSPlayer(event.hlsUrl);

      // Setup HLS network monitoring
      networkMonitor.startMonitoring();

      emit(HLSVideoPlayerManifestLoaded());
    } catch (e) {
      emit(HLSVideoPlayerError(error: e.toString()));
    }
  }
}
```

### 3. HLS Streaming Workflow

```dart
class HLSStreamingWorkflow {
  final NetworkClient networkClient;
  final HLSCacheManager cacheManager;
  final HLSQualityManager qualityManager;

  Future<Stream<HLSSegment>> startHLSStreaming(String hlsUrl) async {
    // Step 1: Parse HLS manifest
    final manifest = await _parseHLSManifest(hlsUrl);

    // Step 2: Select initial quality based on network
    final networkInfo = await NetworkMonitor.getCurrentInfo();
    final initialQuality = qualityManager.selectInitialQuality(networkInfo);

    // Step 3: Setup adaptive quality monitoring
    qualityManager.setupAdaptiveStreaming(networkInfo.bandwidth);

    // Step 4: Start segment streaming
    return _createHLSSegmentStream(manifest, initialQuality);
  }

  Stream<HLSSegment> _createHLSSegmentStream(
    HLSManifest manifest,
    HLSQuality quality
  ) async* {
    final segmentUrls = manifest.getSegmentUrls(quality);

    for (final segmentUrl in segmentUrls) {
      // Check cache first
      HLSSegment? cachedSegment = await cacheManager.getSegment(segmentUrl);

      if (cachedSegment != null) {
        yield cachedSegment;
      } else {
        // Download and cache segment
        final segment = await networkClient.downloadSegment(segmentUrl);
        await cacheManager.cacheSegment(segmentUrl, segment);
        yield segment;
      }
    }
  }
}
```

## Event-Driven Architecture

### 1. HLS Video Player Events

```dart
// Core HLS Video Events
abstract class HLSVideoPlayerEvent {}

class HLSVideoPlayerInitialize extends HLSVideoPlayerEvent {
  final String hlsUrl;
  final Map<String, dynamic> configuration;

  HLSVideoPlayerInitialize({
    required this.hlsUrl,
    this.configuration = const {},
  });
}

class HLSVideoPlayerPlay extends HLSVideoPlayerEvent {}
class HLSVideoPlayerPause extends HLSVideoPlayerEvent {}

class HLSVideoPlayerSeek extends HLSVideoPlayerEvent {
  final Duration position;
  HLSVideoPlayerSeek(this.position);
}

class HLSQualityChange extends HLSVideoPlayerEvent {
  final HLSQuality quality;
  HLSQualityChange(this.quality);
}

class HLSVideoPlayerError extends HLSVideoPlayerEvent {
  final String error;
  HLSVideoPlayerError({required this.error});
}
```

### 2. Event Handling Implementation

```dart
class HLSVideoPlayerEventHandler {
  final VideoPlayerController controller;
  final HLSQualityManager qualityManager;
  final HLSErrorHandler errorHandler;

  void setupEventHandlers() {
    // HLS manifest loading events
    controller.addListener(_onHLSManifestLoaded);

    // HLS segment loading events
    controller.addListener(_onHLSSegmentLoaded);

    // HLS quality switching events
    controller.addListener(_onHLSQualityChanged);

    // HLS error events
    controller.addListener(_onHLSError);
  }

  void _onHLSManifestLoaded() {
    if (controller.value.isInitialized) {
      // HLS manifest successfully loaded
      EventBus.emit(HLSManifestLoadedEvent(
        duration: controller.value.duration,
        availableQualities: qualityManager.getAvailableQualities(),
      ));
    }
  }

  void _onHLSSegmentLoaded() {
    // Monitor HLS segment loading progress
    final buffered = controller.value.buffered;
    if (buffered.isNotEmpty) {
      EventBus.emit(HLSBufferingProgressEvent(
        bufferedRanges: buffered,
        currentPosition: controller.value.position,
      ));
    }
  }

  void _onHLSQualityChanged() {
    // Handle HLS quality adaptation
    final currentQuality = qualityManager.getCurrentQuality();
    EventBus.emit(HLSQualityChangedEvent(quality: currentQuality));
  }

  void _onHLSError() {
    // Handle HLS-specific errors
    if (controller.value.hasError) {
      final error = controller.value.errorDescription;
      errorHandler.handleHLSError(error);
    }
  }
}
```

## Data Flow Architecture

### 1. HLS Data Repository Pattern

```dart
abstract class VideoRepository {
  Future<VideoPlayerController> initializeHLSPlayer(String hlsUrl);
  Future<void> disposePlayer();
  Future<HLSManifest> getHLSManifest(String hlsUrl);
  Future<List<HLSSegment>> getHLSSegments(String manifestUrl);
}

class HLSVideoRepository implements VideoRepository {
  final NetworkClient networkClient;
  final HLSCacheManager cacheManager;
  final HLSValidator validator;

  @override
  Future<VideoPlayerController> initializeHLSPlayer(String hlsUrl) async {
    // Validate HLS URL
    if (!await validator.isValidHLSUrl(hlsUrl)) {
      throw InvalidHLSUrlException();
    }

    // Create HLS-optimized controller
    final controller = VideoPlayerController.network(
      hlsUrl,
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: false,
        allowBackgroundPlayback: false,
      ),
    );

    // Initialize with HLS-specific configuration
    await controller.initialize();

    return controller;
  }

  @override
  Future<HLSManifest> getHLSManifest(String hlsUrl) async {
    // Check cache first
    HLSManifest? cachedManifest = await cacheManager.getManifest(hlsUrl);
    if (cachedManifest != null) {
      return cachedManifest;
    }

    // Download and parse manifest
    final response = await networkClient.get(hlsUrl);
    final manifest = HLSManifestParser.parse(response.body);

    // Cache manifest
    await cacheManager.cacheManifest(hlsUrl, manifest);

    return manifest;
  }
}
```

### 2. HLS Cache Management

```dart
class HLSCacheManager {
  static const int MAX_MANIFEST_CACHE_SIZE = 10;
  static const int MAX_SEGMENT_CACHE_SIZE = 50;
  static const Duration MANIFEST_CACHE_DURATION = Duration(minutes: 5);
  static const Duration SEGMENT_CACHE_DURATION = Duration(minutes: 10);

  final Map<String, CachedManifest> _manifestCache = {};
  final Map<String, CachedSegment> _segmentCache = {};

  Future<HLSManifest?> getManifest(String hlsUrl) async {
    final cached = _manifestCache[hlsUrl];
    if (cached != null && !_isExpired(cached.timestamp, MANIFEST_CACHE_DURATION)) {
      return cached.manifest;
    }
    return null;
  }

  Future<void> cacheManifest(String hlsUrl, HLSManifest manifest) async {
    // Implement LRU cache eviction
    if (_manifestCache.length >= MAX_MANIFEST_CACHE_SIZE) {
      final oldestKey = _manifestCache.keys.first;
      _manifestCache.remove(oldestKey);
    }

    _manifestCache[hlsUrl] = CachedManifest(
      manifest: manifest,
      timestamp: DateTime.now(),
    );
  }

  Future<HLSSegment?> getSegment(String segmentUrl) async {
    final cached = _segmentCache[segmentUrl];
    if (cached != null && !_isExpired(cached.timestamp, SEGMENT_CACHE_DURATION)) {
      return cached.segment;
    }
    return null;
  }

  Future<void> cacheSegment(String segmentUrl, HLSSegment segment) async {
    // Implement LRU cache eviction
    if (_segmentCache.length >= MAX_SEGMENT_CACHE_SIZE) {
      final oldestKey = _segmentCache.keys.first;
      _segmentCache.remove(oldestKey);
    }

    _segmentCache[segmentUrl] = CachedSegment(
      segment: segment,
      timestamp: DateTime.now(),
    );
  }

  void clearExpiredCache() {
    final now = DateTime.now();

    // Clear expired manifests
    _manifestCache.removeWhere((key, value) =>
      _isExpired(value.timestamp, MANIFEST_CACHE_DURATION));

    // Clear expired segments
    _segmentCache.removeWhere((key, value) =>
      _isExpired(value.timestamp, SEGMENT_CACHE_DURATION));
  }

  bool _isExpired(DateTime timestamp, Duration duration) {
    return DateTime.now().difference(timestamp) > duration;
  }
}
```

## UI Integration Workflow

### 1. Video Player Widget Architecture

```dart
class HLSVideoPlayerWidget extends StatefulWidget {
  final String hlsUrl;
  final Map<String, dynamic> configuration;
  final VoidCallback? onVideoEnded;
  final Function(String)? onError;

  const HLSVideoPlayerWidget({
    Key? key,
    required this.hlsUrl,
    this.configuration = const {},
    this.onVideoEnded,
    this.onError,
  }) : super(key: key);

  @override
  State<HLSVideoPlayerWidget> createState() => _HLSVideoPlayerWidgetState();
}

class _HLSVideoPlayerWidgetState extends State<HLSVideoPlayerWidget> {
  late HLSVideoPlayerBloc _bloc;
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _bloc = context.read<HLSVideoPlayerBloc>();

    // Initialize HLS video player
    _bloc.add(HLSVideoPlayerInitialize(
      hlsUrl: widget.hlsUrl,
      configuration: widget.configuration,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HLSVideoPlayerBloc, HLSVideoPlayerState>(
      builder: (context, state) {
        return _buildVideoPlayerUI(state);
      },
    );
  }

  Widget _buildVideoPlayerUI(HLSVideoPlayerState state) {
    switch (state.runtimeType) {
      case HLSVideoPlayerUninitialized:
        return _buildLoadingUI();

      case HLSVideoPlayerLoadingManifest:
        return _buildManifestLoadingUI();

      case HLSVideoPlayerManifestLoaded:
        return _buildVideoPlayerUI();

      case HLSVideoPlayerPlaying:
        return _buildPlayingUI();

      case HLSVideoPlayerBuffering:
        return _buildBufferingUI();

      case HLSVideoPlayerError:
        return _buildErrorUI(state as HLSVideoPlayerError);

      default:
        return _buildLoadingUI();
    }
  }
}
```

### 2. HLS-Specific UI Components

```dart
class HLSQualitySelector extends StatelessWidget {
  final List<HLSQuality> availableQualities;
  final HLSQuality currentQuality;
  final Function(HLSQuality) onQualityChanged;

  const HLSQualitySelector({
    Key? key,
    required this.availableQualities,
    required this.currentQuality,
    required this.onQualityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<HLSQuality>(
      onSelected: onQualityChanged,
      itemBuilder: (context) => availableQualities.map((quality) {
        return PopupMenuItem(
          value: quality,
          child: Row(
            children: [
              Text(_getQualityLabel(quality)),
              if (quality == currentQuality)
                const Icon(Icons.check, size: 16),
            ],
          ),
        );
      }).toList(),
      child: const Icon(Icons.settings),
    );
  }

  String _getQualityLabel(HLSQuality quality) {
    switch (quality) {
      case HLSQuality.auto:
        return 'Auto';
      case HLSQuality.low_480p:
        return '480p';
      case HLSQuality.medium_720p:
        return '720p';
      case HLSQuality.high_1080p:
        return '1080p';
    }
  }
}

class HLSBufferingIndicator extends StatelessWidget {
  final bool isBuffering;
  final double bufferingProgress;

  const HLSBufferingIndicator({
    Key? key,
    required this.isBuffering,
    this.bufferingProgress = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isBuffering) return const SizedBox.shrink();

    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Buffering... ${(bufferingProgress * 100).toInt()}%',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Error Handling & Recovery

### 1. HLS-Specific Error Handling

```dart
class HLSErrorHandler {
  static const int MAX_RETRY_ATTEMPTS = 3;
  static const Duration RETRY_DELAY = Duration(seconds: 2);

  static Future<void> handleHLSError(
    String error,
    HLSVideoPlayerBloc bloc,
  ) async {
    // Log error for debugging
    print('HLS Error: $error');

    // Categorize error type
    if (error.contains('network') || error.contains('timeout')) {
      await _handleNetworkError(bloc);
    } else if (error.contains('format') || error.contains('codec')) {
      await _handleFormatError(bloc);
    } else if (error.contains('manifest') || error.contains('playlist')) {
      await _handleManifestError(bloc);
    } else {
      await _handleGenericError(bloc, error);
    }
  }

  static Future<void> _handleNetworkError(HLSVideoPlayerBloc bloc) async {
    // Try quality fallback first
    final currentQuality = bloc.currentQuality;
    final fallbackQuality = _getFallbackQuality(currentQuality);

    if (fallbackQuality != null) {
      bloc.add(HLSQualityChange(fallbackQuality));
      return;
    }

    // Retry with exponential backoff
    for (int attempt = 1; attempt <= MAX_RETRY_ATTEMPTS; attempt++) {
      await Future.delayed(RETRY_DELAY * attempt);

      try {
        bloc.add(HLSVideoPlayerRetry());
        return;
      } catch (e) {
        if (attempt == MAX_RETRY_ATTEMPTS) {
          bloc.add(HLSVideoPlayerFatalError(
            error: 'Network connection failed after $attempt attempts'
          ));
        }
      }
    }
  }

  static HLSQuality? _getFallbackQuality(HLSQuality currentQuality) {
    switch (currentQuality) {
      case HLSQuality.high_1080p:
        return HLSQuality.medium_720p;
      case HLSQuality.medium_720p:
        return HLSQuality.low_480p;
      case HLSQuality.low_480p:
        return null; // No fallback available
      case HLSQuality.auto:
        return HLSQuality.low_480p;
    }
  }
}
```

## Testing Strategy

### 1. HLS Integration Testing

```dart
class HLSIntegrationTest {
  group('HLS Video Player Integration', () {
    late HLSVideoPlayerBloc bloc;
    late MockVideoRepository mockRepository;
    late MockHLSNetworkMonitor mockNetworkMonitor;

    setUp(() {
      mockRepository = MockVideoRepository();
      mockNetworkMonitor = MockHLSNetworkMonitor();
      bloc = HLSVideoPlayerBloc(
        repository: mockRepository,
        networkMonitor: mockNetworkMonitor,
      );
    });

    test('should initialize HLS player successfully', () async {
      // Arrange
      const hlsUrl = 'https://example.com/stream.m3u8';
      when(mockRepository.initializeHLSPlayer(hlsUrl))
          .thenAnswer((_) async => MockVideoPlayerController());

      // Act
      bloc.add(HLSVideoPlayerInitialize(hlsUrl: hlsUrl));

      // Assert
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HLSVideoPlayerLoadingManifest>(),
          isA<HLSVideoPlayerManifestLoaded>(),
        ]),
      );
    });

    test('should handle HLS manifest loading error', () async {
      // Arrange
      const hlsUrl = 'https://example.com/invalid.m3u8';
      when(mockRepository.initializeHLSPlayer(hlsUrl))
          .thenThrow(InvalidHLSUrlException());

      // Act
      bloc.add(HLSVideoPlayerInitialize(hlsUrl: hlsUrl));

      // Assert
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HLSVideoPlayerLoadingManifest>(),
          isA<HLSVideoPlayerError>(),
        ]),
      );
    });
  });
}
```

## Performance Monitoring

### 1. HLS Performance Metrics

```dart
class HLSPerformanceMonitor {
  static const Duration MONITORING_INTERVAL = Duration(seconds: 5);
  Timer? _monitoringTimer;
  final List<HLSPerformanceMetric> _metrics = [];

  void startMonitoring() {
    _monitoringTimer = Timer.periodic(
      MONITORING_INTERVAL,
      (_) => _collectHLSMetrics(),
    );
  }

  void _collectHLSMetrics() {
    final metric = HLSPerformanceMetric(
      timestamp: DateTime.now(),
      manifestLoadTime: _getManifestLoadTime(),
      segmentLoadTime: _getAverageSegmentLoadTime(),
      qualitySwitchTime: _getQualitySwitchTime(),
      bufferHealth: _getBufferHealth(),
      networkBandwidth: _getCurrentBandwidth(),
    );

    _metrics.add(metric);
    _analyzeHLSPerformance(metric);
  }

  void _analyzeHLSPerformance(HLSPerformanceMetric metric) {
    // Alert if HLS performance degrades
    if (metric.manifestLoadTime > 3000) { // 3 seconds threshold
      _alertSlowManifestLoading(metric.manifestLoadTime);
    }

    if (metric.segmentLoadTime > 2000) { // 2 seconds threshold
      _alertSlowSegmentLoading(metric.segmentLoadTime);
    }

    if (metric.bufferHealth < 0.5) { // 50% buffer health threshold
      _alertLowBufferHealth(metric.bufferHealth);
    }
  }
}

class HLSPerformanceMetric {
  final DateTime timestamp;
  final int manifestLoadTime;    // milliseconds
  final int segmentLoadTime;     // milliseconds
  final int qualitySwitchTime;   // milliseconds
  final double bufferHealth;     // percentage
  final double networkBandwidth; // bps

  HLSPerformanceMetric({
    required this.timestamp,
    required this.manifestLoadTime,
    required this.segmentLoadTime,
    required this.qualitySwitchTime,
    required this.bufferHealth,
    required this.networkBandwidth,
  });
}
```

## Implementation Guidelines

### Best Practices for HLS Integration

1. **Architecture Design**

   - Use layered architecture for clear separation of concerns
   - Implement event-driven design for loose coupling
   - Separate HLS-specific logic from general video logic

2. **State Management**

   - Use Bloc pattern for predictable state management
   - Handle HLS-specific states (manifest loading, quality switching)
   - Implement proper error states and recovery

3. **Performance Optimization**

   - Implement efficient HLS segment caching
   - Monitor and optimize quality switching performance
   - Use background processing for non-critical operations

4. **Error Handling**

   - Implement robust HLS error recovery
   - Provide quality fallback mechanisms
   - Log errors for debugging and monitoring

5. **Testing Strategy**
   - Test HLS manifest loading and parsing
   - Validate quality switching functionality
   - Test error recovery scenarios

### Success Metrics

| Metric              | Target | Acceptable | Poor |
| ------------------- | ------ | ---------- | ---- |
| Manifest Load Time  | <1s    | 1-3s       | >3s  |
| Segment Load Time   | <2s    | 2-5s       | >5s  |
| Quality Switch Time | <3s    | 3-8s       | >8s  |
| Buffer Health       | >80%   | 50-80%     | <50% |
| Error Recovery Rate | >95%   | 90-95%     | <90% |

---

This integration workflow provides a comprehensive framework for implementing HLS video streaming in Flutter applications with proper architecture, state management, and error handling.
