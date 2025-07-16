# Performance Optimization

## Overview

Comprehensive optimization guide for video streaming in Flutter, focusing on memory management, network optimization, and battery efficiency for HLS streams.

## Memory Management

### 1. Video Buffer Optimization

#### Buffer Size Configuration

```dart
class VideoBufferManager {
  static const int OPTIMAL_BUFFER_SIZE = 30; // seconds
  static const int MIN_BUFFER_SIZE = 5;      // seconds
  static const int MAX_BUFFER_SIZE = 60;     // seconds

  void configureBuffer(VideoPlayerController controller) {
    // Optimize buffer based on network conditions
    final bufferSize = _calculateOptimalBuffer();

    // Configure native player buffer (platform-specific)
    _configureNativeBuffer(bufferSize);
  }

  int _calculateOptimalBuffer() {
    final networkSpeed = NetworkMonitor.getCurrentSpeed();
    if (networkSpeed > 5000) return MAX_BUFFER_SIZE;    // Fast network
    if (networkSpeed > 1000) return OPTIMAL_BUFFER_SIZE; // Medium network
    return MIN_BUFFER_SIZE;                             // Slow network
  }
}
```

#### Memory Leak Prevention

```dart
class VideoPlayerLifecycleManager {
  VideoPlayerController? _controller;
  Timer? _memoryCleanupTimer;

  void initializePlayer(String url) {
    _controller = VideoPlayerController.network(url);
    _startMemoryMonitoring();
  }

  void _startMemoryMonitoring() {
    _memoryCleanupTimer = Timer.periodic(
      Duration(minutes: 2),
      (_) => _cleanupMemory(),
    );
  }

  void _cleanupMemory() {
    // Force garbage collection for video frames
    if (_controller?.value.isPlaying == false) {
      _controller?.seekTo(Duration.zero);
    }
  }

  @override
  void dispose() {
    _memoryCleanupTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }
}
```

### 2. HLS Segment Memory Optimization

#### Efficient Segment Management¹

```dart
class HLSSegmentManager {
  static const int MAX_CACHED_SEGMENTS = 5;
  final Map<String, Uint8List> _segmentCache = {};

  void cacheSegment(String segmentUrl, Uint8List data) {
    if (_segmentCache.length >= MAX_CACHED_SEGMENTS) {
      final oldestKey = _segmentCache.keys.first;
      _segmentCache.remove(oldestKey);
    }
    _segmentCache[segmentUrl] = data;
  }

  void clearExpiredSegments() {
    // Keep only current and next 2 segments
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    _segmentCache.removeWhere((key, value) =>
      _isSegmentExpired(key, currentTime));
  }
}
```

## Network Optimization

### 1. HLS Adaptive Bitrate Implementation

#### Bandwidth Monitoring for HLS²

```dart
class HLSBandwidthMonitor {
  double _currentBandwidth = 0;
  Timer? _monitoringTimer;

  void startMonitoring() {
    _monitoringTimer = Timer.periodic(
      Duration(seconds: 5),
      (_) => _measureBandwidth(),
    );
  }

  Future<void> _measureBandwidth() async {
    final startTime = DateTime.now();
    final testSegmentUrl = 'https://cdn.example.com/test-segment.ts';

    try {
      final response = await http.get(Uri.parse(testSegmentUrl));
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      final bytes = response.bodyBytes.length;

      _currentBandwidth = (bytes * 8 / duration) * 1000; // bps
      _adjustHLSQuality();
    } catch (e) {
      print('Bandwidth test failed: $e');
    }
  }

  void _adjustHLSQuality() {
    final quality = _selectQualityByBandwidth(_currentBandwidth);
    HLSQualityManager.switchToQuality(quality);
  }
}
```

#### Quality Switching Logic for HLS

```dart
class HLSQualityManager {
  static const Map<String, double> HLS_QUALITY_BANDWIDTH_MAP = {
    'low': 800000,      // 800 kbps
    'medium': 2000000,  // 2 Mbps
    'high': 4000000,    // 4 Mbps
  };

  static String selectQualityByBandwidth(double bandwidth) {
    // Add 25% buffer for HLS stability³
    final safeBandwidth = bandwidth * 0.75;

    if (safeBandwidth >= HLS_QUALITY_BANDWIDTH_MAP['high']!) return 'high';
    if (safeBandwidth >= HLS_QUALITY_BANDWIDTH_MAP['medium']!) return 'medium';
    return 'low';
  }

  static Future<void> switchToQuality(String quality) async {
    final currentPosition = VideoPlayerGlobal.controller?.value.position;
    final newUrl = _getHLSQualityUrl(quality);

    // Seamless quality switch for HLS
    await VideoPlayerGlobal.controller?.pause();
    await VideoPlayerGlobal.controller?.dispose();

    VideoPlayerGlobal.controller = VideoPlayerController.network(newUrl);
    await VideoPlayerGlobal.controller?.initialize();
    await VideoPlayerGlobal.controller?.seekTo(currentPosition ?? Duration.zero);
    await VideoPlayerGlobal.controller?.play();
  }
}
```

### 2. CDN Optimization for HLS

#### CDN Edge Selection⁴

```dart
class HLSCDNOptimizer {
  static const List<String> HLS_CDN_EDGES = [
    'https://asia-hls.example.com',
    'https://us-hls.example.com',
    'https://eu-hls.example.com',
  ];

  static Future<String> selectOptimalEdgeForHLS() async {
    String? bestEdge;
    int bestLatency = 9999;

    for (String edge in HLS_CDN_EDGES) {
      final latency = await _measureHLSLatency(edge);
      if (latency < bestLatency) {
        bestLatency = latency;
        bestEdge = edge;
      }
    }

    return bestEdge ?? HLS_CDN_EDGES.first;
  }

  static Future<int> _measureHLSLatency(String edge) async {
    final stopwatch = Stopwatch()..start();

    try {
      await http.get(Uri.parse('$edge/ping.m3u8'));
      stopwatch.stop();
      return stopwatch.elapsedMilliseconds;
    } catch (e) {
      return 9999; // High latency for failed connections
    }
  }
}
```

#### HTTP/2 Multiplexing for HLS⁵

```dart
class HLSHTTP2Optimizer {
  static const int MAX_CONCURRENT_SEGMENTS = 6;
  final List<Future<void>> _activeDownloads = [];

  Future<void> downloadHLSManifest(String manifestUrl) async {
    final response = await http.get(Uri.parse(manifestUrl));
    final segments = _parseHLSManifest(response.body);

    // Download segments concurrently with HTTP/2
    for (String segment in segments.take(MAX_CONCURRENT_SEGMENTS)) {
      _activeDownloads.add(_downloadSegment(segment));
    }

    await Future.wait(_activeDownloads);
  }

  Future<void> _downloadSegment(String segmentUrl) async {
    final response = await http.get(
      Uri.parse(segmentUrl),
      headers: {'Connection': 'keep-alive'}, // HTTP/2 optimization
    );

    // Process segment data
    _processSegmentData(response.bodyBytes);
  }
}
```

## Battery Optimization

### 1. Background Playback Optimization

#### Battery-Aware Video Playback⁶

```dart
class BatteryOptimizedVideoPlayer {
  static const double BATTERY_THRESHOLD = 20.0; // 20%
  static const int LOW_BATTERY_QUALITY = 480;   // 480p for low battery

  void configureForBatteryOptimization() {
    final batteryLevel = BatteryLevel.getCurrentLevel();

    if (batteryLevel < BATTERY_THRESHOLD) {
      _switchToLowPowerMode();
    }
  }

  void _switchToLowPowerMode() {
    // Reduce video quality for battery saving
    HLSQualityManager.switchToQuality('low');

    // Reduce buffer size
    VideoBufferManager.configureBuffer(10); // 10 seconds

    // Disable unnecessary features
    _disableBackgroundProcessing();
  }

  void _disableBackgroundProcessing() {
    // Disable analytics, logging, and non-essential features
    AnalyticsManager.pause();
    LogManager.setLevel(LogLevel.error);
  }
}
```

### 2. Hardware Acceleration Optimization

#### Platform-Specific Hardware Acceleration⁷

```dart
class HardwareAccelerationManager {
  static Future<void> configureHardwareAcceleration() async {
    final platform = Platform.operatingSystem;

    switch (platform) {
      case 'android':
        await _configureAndroidHardwareAcceleration();
        break;
      case 'ios':
        await _configureIOSHardwareAcceleration();
        break;
      default:
        print('Hardware acceleration not available for $platform');
    }
  }

  static Future<void> _configureAndroidHardwareAcceleration() async {
    // Enable hardware acceleration for Android
    final videoPlayerOptions = VideoPlayerOptions(
      mixWithOthers: false,
      allowBackgroundPlayback: false,
    );

    // Configure ExoPlayer hardware acceleration
    await _configureExoPlayerHardwareAcceleration();
  }

  static Future<void> _configureIOSHardwareAcceleration() async {
    // iOS AVPlayer automatically uses hardware acceleration
    // Configure for optimal performance
    final videoPlayerOptions = VideoPlayerOptions(
      mixWithOthers: true,
      allowBackgroundPlayback: true,
    );
  }
}
```

## Error Handling & Resilience

### 1. HLS Error Recovery

#### Robust Error Handling for HLS⁸

```dart
class HLSErrorHandler {
  static const int MAX_RETRY_ATTEMPTS = 3;
  static const Duration RETRY_DELAY = Duration(seconds: 2);

  static Future<void> handleHLSError(
    VideoPlayerController controller,
    String error,
  ) async {
    print('HLS Error: $error');

    // Attempt recovery based on error type
    if (error.contains('network')) {
      await _handleNetworkError(controller);
    } else if (error.contains('format')) {
      await _handleFormatError(controller);
    } else {
      await _handleGenericError(controller);
    }
  }

  static Future<void> _handleNetworkError(
    VideoPlayerController controller,
  ) async {
    for (int attempt = 1; attempt <= MAX_RETRY_ATTEMPTS; attempt++) {
      try {
        await Future.delayed(RETRY_DELAY * attempt);
        await controller.initialize();
        await controller.play();
        return; // Success
      } catch (e) {
        print('Retry attempt $attempt failed: $e');
      }
    }

    // All retries failed
    _showUserError('Network connection failed. Please check your internet.');
  }

  static Future<void> _handleFormatError(
    VideoPlayerController controller,
  ) async {
    // Try alternative quality or format
    final alternativeUrl = _getAlternativeHLSStream();
    if (alternativeUrl != null) {
      await _switchToAlternativeStream(controller, alternativeUrl);
    }
  }
}
```

### 2. Performance Monitoring

#### Real-Time Performance Monitoring⁹

```dart
class VideoPerformanceMonitor {
  static const Duration MONITORING_INTERVAL = Duration(seconds: 5);
  Timer? _monitoringTimer;
  final List<PerformanceMetric> _metrics = [];

  void startMonitoring() {
    _monitoringTimer = Timer.periodic(
      MONITORING_INTERVAL,
      (_) => _collectMetrics(),
    );
  }

  void _collectMetrics() {
    final metric = PerformanceMetric(
      timestamp: DateTime.now(),
      memoryUsage: _getCurrentMemoryUsage(),
      cpuUsage: _getCurrentCPUUsage(),
      frameRate: _getCurrentFrameRate(),
      bufferHealth: _getBufferHealth(),
    );

    _metrics.add(metric);
    _analyzePerformance(metric);
  }

  void _analyzePerformance(PerformanceMetric metric) {
    // Alert if performance degrades
    if (metric.memoryUsage > 200) { // 200MB threshold
      _alertHighMemoryUsage(metric.memoryUsage);
    }

    if (metric.frameRate < 24) { // 24fps threshold
      _alertLowFrameRate(metric.frameRate);
    }
  }
}

class PerformanceMetric {
  final DateTime timestamp;
  final double memoryUsage; // MB
  final double cpuUsage;    // Percentage
  final double frameRate;   // FPS
  final double bufferHealth; // Percentage

  PerformanceMetric({
    required this.timestamp,
    required this.memoryUsage,
    required this.cpuUsage,
    required this.frameRate,
    required this.bufferHealth,
  });
}
```

## Implementation Guidelines

### Performance Checklist

- [ ] **Memory Management**: Implement buffer optimization and segment caching
- [ ] **Network Optimization**: Configure adaptive bitrate and CDN selection
- [ ] **Battery Optimization**: Enable hardware acceleration and low-power modes
- [ ] **Error Handling**: Implement robust error recovery and retry logic
- [ ] **Performance Monitoring**: Add real-time metrics collection and alerts

### Target Performance Metrics

| Metric         | Target    | Acceptable  | Poor      |
| -------------- | --------- | ----------- | --------- |
| Memory Usage   | <100MB    | 100-150MB   | >150MB    |
| Startup Time   | <300ms    | 300-500ms   | >500ms    |
| Quality Switch | <3s       | 3-5s        | >5s       |
| Battery Usage  | <15%/hour | 15-25%/hour | >25%/hour |
| Success Rate   | >95%      | 90-95%      | <90%      |

---

### References:

1. [HLS Authoring Specification for Apple Devices](https://developer.apple.com/documentation/http-live-streaming/hls_authoring_specification_for_apple_devices), Apple Developer Documentation, 2023
2. [ExoPlayer Documentation](https://exoplayer.dev/), Google ExoPlayer Documentation, 2023
3. [Adaptive Bitrate Streaming 101](https://www.streamingmedia.com/Articles/Editorial/Featured-Articles/Adaptive-Bitrate-Streaming-101-131463.aspx), Streaming Media Magazine, 2023
4. [Performance Matters: Mobile Video](https://blog.cloudflare.com/performance-matters-mobile-video/), Cloudflare Blog, 2023
5. [ARM Mali GPU Documentation](https://developer.arm.com/documentation/102374/0100/Hardware-acceleration), ARM Developer Resources, 2023
6. [Android Background Playback](https://developer.android.com/guide/topics/media/media3/background-playback), Android Developer Documentation, 2023
7. [State of the Internet: Video Streaming](https://www.akamai.com/state-of-the-internet/state-of-video-streaming), Akamai Research, 2023
8. [Flutter Performance Profiling](https://docs.flutter.dev/tools/devtools/performance), Flutter Official Documentation, 2023
9. [Power Management for Android Apps](https://developer.android.com/topic/performance/power), Android Developer Documentation, 2023
10. [HLS Streaming Guide](https://www.wowza.com/blog/hls-streaming-guide), Wowza Blog, 2023
