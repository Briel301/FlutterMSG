import 'package:finchat/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Ratio de contraste WCAG entre dos colores
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  test('themes use Material 3 with correct brightness and extension', () {
    final light = AppTheme.lightTheme;
    final dark = AppTheme.darkTheme;
    expect(light.useMaterial3, isTrue);
    expect(dark.useMaterial3, isTrue);
    expect(light.brightness, Brightness.light);
    expect(dark.brightness, Brightness.dark);
    expect(light.extension<ChatColors>(), ChatColors.light);
    expect(dark.extension<ChatColors>(), ChatColors.dark);
  });

  group('WCAG AA contrast', () {
    for (final entry in <String, (ThemeData, double)>{
      'light': (AppTheme.lightTheme, 4.5),
      'dark': (AppTheme.darkTheme, 4.5),
    }.entries) {
      test('${entry.key} scheme text pairs', () {
        final (theme, min) = entry.value;
        final s = theme.colorScheme;
        expect(contrast(s.onPrimary, s.primary), greaterThanOrEqualTo(min));
        expect(contrast(s.onSurface, s.surface), greaterThanOrEqualTo(min));
        expect(contrast(s.onSurfaceVariant, s.surface), greaterThanOrEqualTo(min));
        expect(contrast(s.onError, s.error), greaterThanOrEqualTo(min));
        expect(contrast(s.onSurface, theme.scaffoldBackgroundColor),
            greaterThanOrEqualTo(min));
      });
    }

    for (final c in [ChatColors.light, ChatColors.dark]) {
      test('chat bubbles ${c == ChatColors.light ? 'light' : 'dark'}', () {
        expect(contrast(c.incomingText, c.incomingBubble), greaterThanOrEqualTo(4.5));
        expect(contrast(c.outgoingText, c.outgoingBubble), greaterThanOrEqualTo(4.5));
        expect(contrast(c.incomingMeta, c.incomingBubble), greaterThanOrEqualTo(4.5));
        expect(contrast(c.outgoingMeta, c.outgoingBubble), greaterThanOrEqualTo(4.5));
        expect(contrast(c.readReceipt, c.outgoingBubble), greaterThanOrEqualTo(3));
        expect(contrast(c.sentReceipt, c.outgoingBubble), greaterThanOrEqualTo(3));
      });
    }
  });

  test('ChatColors lerp interpolates', () {
    final mid = ChatColors.light.lerp(ChatColors.dark, 1);
    expect(mid.outgoingBubble, ChatColors.dark.outgoingBubble);
  });
}
