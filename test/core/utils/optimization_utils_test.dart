import 'dart:convert';
import 'dart:typed_data';

import 'package:finchat/core/utils/optimization_utils.dart';
import 'package:flutter_test/flutter_test.dart';

// Modelo de prueba con constructor tear-off enviable a isolates
class Msg {
  Msg.fromJson(Map<String, dynamic> json) : id = json['id'] as String;
  final String id;
}

void main() {
  group('formatDuration', () {
    test('mm:ss', () {
      expect(OptimizationUtils.formatDuration(Duration.zero), '00:00');
      expect(OptimizationUtils.formatDuration(const Duration(seconds: 45)), '00:45');
      expect(OptimizationUtils.formatDuration(const Duration(seconds: 60)), '01:00');
      expect(OptimizationUtils.formatDuration(const Duration(milliseconds: 59999)), '00:59');
    });
    test('hours and negatives', () {
      expect(OptimizationUtils.formatDuration(const Duration(hours: 1, seconds: 5)), '1:00:05');
      expect(OptimizationUtils.formatDuration(const Duration(seconds: -3)), '00:00');
    });
  });

  group('formatBytes', () {
    test('units', () {
      expect(OptimizationUtils.formatBytes(0), '0 B');
      expect(OptimizationUtils.formatBytes(-5), '0 B');
      expect(OptimizationUtils.formatBytes(512), '512 B');
      expect(OptimizationUtils.formatBytes(1024), '1.0 KB');
      expect(OptimizationUtils.formatBytes(240000), '234.4 KB');
      expect(OptimizationUtils.formatBytes(4650000), '4.4 MB');
      expect(OptimizationUtils.formatBytes(3 * 1024 * 1024 * 1024), '3.0 GB');
      expect(OptimizationUtils.formatBytes(1536, decimals: 2), '1.50 KB');
    });
  });

  group('formatChatTimestamp', () {
    final now = DateTime(2026, 10, 12, 18);
    String fmt(DateTime d) => OptimizationUtils.formatChatTimestamp(d, now: now);

    test('today uses 12h time', () {
      expect(fmt(DateTime(2026, 10, 12, 10, 45)), '10:45 AM');
      expect(fmt(DateTime(2026, 10, 12, 0, 5)), '12:05 AM');
      expect(fmt(DateTime(2026, 10, 12, 12)), '12:00 PM');
      expect(fmt(DateTime(2026, 10, 12, 17, 9)), '5:09 PM');
    });
    test('yesterday, weekday and full date', () {
      expect(fmt(DateTime(2026, 10, 11, 23, 59)), 'Ayer');
      expect(fmt(DateTime(2026, 10, 8)), 'Jueves');
      expect(fmt(DateTime(2026, 10, 5)), '05/10/2026');
    });
    test('crosses month and year boundaries', () {
      final jan1 = DateTime(2027, 1, 1, 9);
      expect(OptimizationUtils.formatChatTimestamp(DateTime(2026, 12, 31), now: jan1), 'Ayer');
    });
  });

  group('savings', () {
    test('calculateSavingsPercentage', () {
      expect(OptimizationUtils.calculateSavingsPercentage(1000, 250), 75);
      expect(OptimizationUtils.calculateSavingsPercentage(1000, 1000), 0);
      expect(OptimizationUtils.calculateSavingsPercentage(1000, 1500), 0);
      expect(OptimizationUtils.calculateSavingsPercentage(0, 0), 0);
      expect(OptimizationUtils.calculateSavingsPercentage(1000, -1), 0);
    });
    test('audio estimate for 60s note', () {
      final e = OptimizationUtils.estimateAudioCompression(const Duration(seconds: 60));
      expect(e.compressedBytes, 240000);
      expect(e.savingsPercentage, greaterThan(97));
      expect(e.savedBytes, e.originalBytes - e.compressedBytes);
    });
  });

  group('file metrics', () {
    test('crc32 matches known vector', () {
      final bytes = Uint8List.fromList(utf8.encode('123456789'));
      expect(crc32Hex(bytes), 'cbf43926');
      expect(crc32Hex(Uint8List(0)), '00000000');
    });
    test('mime detection by magic bytes', () {
      Uint8List b(List<int> v) => Uint8List.fromList([...v, ...List.filled(8, 0)]);
      expect(detectMimeType(b([0xFF, 0xD8, 0xFF, 0xE0])), 'image/jpeg');
      expect(detectMimeType(b([0x89, 0x50, 0x4E, 0x47])), 'image/png');
      expect(
        detectMimeType(b([0x52, 0x49, 0x46, 0x46, 0, 0, 0, 0, 0x57, 0x45, 0x42, 0x50])),
        'image/webp',
      );
      expect(
        detectMimeType(b([0, 0, 0, 0x20, 0x66, 0x74, 0x79, 0x70, 0x4D, 0x34, 0x41, 0x20])),
        'audio/mp4',
      );
      expect(detectMimeType(Uint8List(2)), 'application/octet-stream');
    });
  });

  group('JSON helpers', () {
    test('decodeJsonList validates shape', () {
      expect(decodeJsonList('[{"a":1}]'), [
        {'a': 1},
      ]);
      expect(() => decodeJsonList('{"a":1}'), throwsFormatException);
      expect(() => decodeJsonList('[1]'), throwsFormatException);
    });
  });

  group('background dispatch via compute()', () {
    final big = List.generate(2000, (i) => {'id': 'm$i', 'text': 'x' * 20});
    final source = jsonEncode(big);

    test('payload exceeds isolate threshold', () {
      expect(source.length, greaterThan(OptimizationUtils.jsonIsolateThreshold));
    });

    test('round-trip large batch in isolates', () async {
      final encoded = await OptimizationUtils.encodeJsonListInBackground(big);
      final decoded = await OptimizationUtils.decodeJsonListInBackground(encoded);
      expect(decoded, big);
    });

    test('decodes into models in an isolate', () async {
      final models =
          await OptimizationUtils.decodeModelsInBackground(source, Msg.fromJson);
      expect(models.length, 2000);
      expect(models.last.id, 'm1999');
    });

    test('analyzes large file in an isolate', () async {
      final bytes = Uint8List(OptimizationUtils.fileIsolateThreshold + 1)
        ..setAll(0, [0xFF, 0xD8, 0xFF]);
      final m = await OptimizationUtils.analyzeFileInBackground(bytes);
      expect(m.sizeBytes, bytes.length);
      expect(m.isImage, isTrue);
      expect(m, analyzeFileBytes(bytes));
    });
  });
}
