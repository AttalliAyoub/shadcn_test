import 'dart:ui';
import 'dart:math';

extension PathExtension on Path {
  double get totalLength =>
      computeMetrics().fold(0.0, (value, metric) => value + metric.length);

  /// Extracts a portion of the path.
  /// If [isClosedLoop] is true, it allows wrapping (e.g., start > end).
  Path getSubPath(
    double startLength,
    double endLength, {
    bool isClosedLoop = true,
  }) {
    final total = totalLength;
    if (total <= 0) return Path();

    if (!isClosedLoop) {
      // Original safety logic for non-looping paths
      final start = startLength.clamp(0.0, total);
      final end = endLength.clamp(0.0, total);
      return _extract(start, end);
    }

    // --- Closed Loop Logic ---
    // 1. Normalize values using Modulo to handle negative or > total inputs
    final start = startLength % total;
    final end = endLength % total;

    if ((start - end).abs() < 1e-6 && startLength != endLength) {
      // If they are mathematically the same but the input distance was different,
      // user likely wants the full loop.
      return this;
    }

    if (start <= end) {
      // Normal case: No wrapping needed
      return _extract(start, end);
    } else {
      // Wrapping case: Get [start to total] AND [0 to end]
      final resultPath = _extract(start, total);
      resultPath.addPath(_extract(0, end), Offset.zero);
      return resultPath;
    }
  }

  /// Internal helper to extract segments without recursion
  Path _extract(double start, double end) {
    final subPath = Path();
    final metrics = computeMetrics();
    double accumulatedLength = 0.0;

    for (final metric in metrics) {
      final metricLength = metric.length;
      final metricEnd = accumulatedLength + metricLength;

      if (start < metricEnd && end > accumulatedLength) {
        final localStart = max(0.0, start - accumulatedLength);
        final localEnd = min(metricLength, end - accumulatedLength);
        subPath.addPath(metric.extractPath(localStart, localEnd), Offset.zero);
      }
      accumulatedLength = metricEnd;
      if (accumulatedLength >= end) break;
    }
    return subPath;
  }
}
