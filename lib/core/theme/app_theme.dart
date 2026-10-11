import 'package:flutter/material.dart';

/// Paleta institucional de FinChat.
///
/// Los pares texto/fondo indicados cumplen WCAG AA (≥ 4.5:1 en texto normal,
/// ≥ 3:1 en iconos y texto grande).
abstract final class AppColors {
  // Marca
  /// Teal institucional profundo; contraste 7.6:1 con blanco.
  static const Color tealDark = Color(0xFF075E54);

  /// Teal Fintech vibrante; primario en modo oscuro.
  static const Color teal = Color(0xFF00A884);

  /// Acento verde azulado financiero.
  static const Color tealAccent = Color(0xFF128C7E);

  /// Verde de éxito/acción; secundario en modo oscuro.
  static const Color green = Color(0xFF25D366);

  // Fondos y superficies
  static const Color backgroundLight = Color(0xFFF0F2F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121B22);
  static const Color surfaceDark = Color(0xFF1F2C34);
  static const Color surfaceDarkHigh = Color(0xFF2A3942);

  // Fondo del área de conversación
  static const Color chatWallpaperLight = Color(0xFFEFEAE2);
  static const Color chatWallpaperDark = Color(0xFF0B141A);

  // Burbujas de mensaje
  static const Color bubbleIncomingLight = Color(0xFFFFFFFF);
  static const Color bubbleIncomingDark = Color(0xFF202C33);
  static const Color bubbleOutgoingLight = Color(0xFFE7FFDB);
  static const Color bubbleOutgoingDark = Color(0xFF005C4B);

  // Texto alta legibilidad
  static const Color textPrimaryLight = Color(0xFF111B21);
  static const Color textSecondaryLight = Color(0xFF54656F);
  static const Color textPrimaryDark = Color(0xFFE9EDEF);
  static const Color textSecondaryDark = Color(0xFF8696A0);

  /// Texto secundario sobre burbuja saliente oscura (5:1).
  static const Color textOnOutgoingDark = Color(0xFFB3D4CE);

  // Bordes y divisores
  static const Color outlineLight = Color(0xFFD1D7DB);
  static const Color outlineDark = Color(0xFF374248);

  // Estados
  static const Color errorLight = Color(0xFFB3261E);
  static const Color errorDark = Color(0xFFF2B8B5);
  static const Color onErrorDark = Color(0xFF601410);
  static const Color successLight = Color(0xFF1B7F3B);
  static const Color successDark = Color(0xFF25D366);
  static const Color warningLight = Color(0xFF9A6700);
  static const Color warningDark = Color(0xFFFFC857);

  // Mensajería
  /// Doble check azul de leído (marca); usado sobre burbujas oscuras.
  static const Color readReceipt = Color(0xFF53BDEB);

  /// Variante accesible del doble check para burbujas claras (4.3:1).
  static const Color readReceiptLight = Color(0xFF027EB5);

  /// Indicador de usuario en línea.
  static const Color online = Color(0xFF25D366);
}

/// Colores específicos de mensajería expuestos como [ThemeExtension].
///
/// Uso: `Theme.of(context).extension<ChatColors>()!` o `context.chatColors`.
@immutable
class ChatColors extends ThemeExtension<ChatColors> {
  /// Crea un conjunto de colores de chat.
  const ChatColors({
    required this.wallpaper,
    required this.incomingBubble,
    required this.outgoingBubble,
    required this.incomingText,
    required this.outgoingText,
    required this.incomingMeta,
    required this.outgoingMeta,
    required this.readReceipt,
    required this.sentReceipt,
    required this.online,
    required this.typing,
    required this.systemBubble,
    required this.systemText,
  });

  /// Fondo del área de conversación.
  final Color wallpaper;

  /// Burbuja de mensaje recibido.
  final Color incomingBubble;

  /// Burbuja de mensaje enviado.
  final Color outgoingBubble;

  /// Texto de mensaje recibido.
  final Color incomingText;

  /// Texto de mensaje enviado.
  final Color outgoingText;

  /// Hora y metadatos en burbuja recibida.
  final Color incomingMeta;

  /// Hora y metadatos en burbuja enviada.
  final Color outgoingMeta;

  /// Doble check de leído.
  final Color readReceipt;

  /// Check de enviado/entregado.
  final Color sentReceipt;

  /// Indicador de presencia en línea.
  final Color online;

  /// Indicador "escribiendo…".
  final Color typing;

  /// Burbuja de avisos del sistema (fechas, cifrado).
  final Color systemBubble;

  /// Texto de avisos del sistema.
  final Color systemText;

  /// Colores de chat para modo claro.
  static const ChatColors light = ChatColors(
    wallpaper: AppColors.chatWallpaperLight,
    incomingBubble: AppColors.bubbleIncomingLight,
    outgoingBubble: AppColors.bubbleOutgoingLight,
    incomingText: AppColors.textPrimaryLight,
    outgoingText: AppColors.textPrimaryLight,
    incomingMeta: AppColors.textSecondaryLight,
    outgoingMeta: AppColors.textSecondaryLight,
    readReceipt: AppColors.readReceiptLight,
    sentReceipt: AppColors.textSecondaryLight,
    online: AppColors.successLight,
    typing: AppColors.tealDark,
    systemBubble: Color(0xFFFFF5C4),
    systemText: AppColors.textSecondaryLight,
  );

  /// Colores de chat para modo oscuro.
  static const ChatColors dark = ChatColors(
    wallpaper: AppColors.chatWallpaperDark,
    incomingBubble: AppColors.bubbleIncomingDark,
    outgoingBubble: AppColors.bubbleOutgoingDark,
    incomingText: AppColors.textPrimaryDark,
    outgoingText: AppColors.textPrimaryDark,
    incomingMeta: AppColors.textSecondaryDark,
    outgoingMeta: AppColors.textOnOutgoingDark,
    readReceipt: AppColors.readReceipt,
    sentReceipt: AppColors.textOnOutgoingDark,
    online: AppColors.online,
    typing: AppColors.teal,
    systemBubble: Color(0xFF182229),
    systemText: AppColors.textSecondaryDark,
  );

  @override
  ChatColors copyWith({
    Color? wallpaper,
    Color? incomingBubble,
    Color? outgoingBubble,
    Color? incomingText,
    Color? outgoingText,
    Color? incomingMeta,
    Color? outgoingMeta,
    Color? readReceipt,
    Color? sentReceipt,
    Color? online,
    Color? typing,
    Color? systemBubble,
    Color? systemText,
  }) {
    return ChatColors(
      wallpaper: wallpaper ?? this.wallpaper,
      incomingBubble: incomingBubble ?? this.incomingBubble,
      outgoingBubble: outgoingBubble ?? this.outgoingBubble,
      incomingText: incomingText ?? this.incomingText,
      outgoingText: outgoingText ?? this.outgoingText,
      incomingMeta: incomingMeta ?? this.incomingMeta,
      outgoingMeta: outgoingMeta ?? this.outgoingMeta,
      readReceipt: readReceipt ?? this.readReceipt,
      sentReceipt: sentReceipt ?? this.sentReceipt,
      online: online ?? this.online,
      typing: typing ?? this.typing,
      systemBubble: systemBubble ?? this.systemBubble,
      systemText: systemText ?? this.systemText,
    );
  }

  @override
  ChatColors lerp(ThemeExtension<ChatColors>? other, double t) {
    if (other is! ChatColors) return this;
    return ChatColors(
      wallpaper: Color.lerp(wallpaper, other.wallpaper, t)!,
      incomingBubble: Color.lerp(incomingBubble, other.incomingBubble, t)!,
      outgoingBubble: Color.lerp(outgoingBubble, other.outgoingBubble, t)!,
      incomingText: Color.lerp(incomingText, other.incomingText, t)!,
      outgoingText: Color.lerp(outgoingText, other.outgoingText, t)!,
      incomingMeta: Color.lerp(incomingMeta, other.incomingMeta, t)!,
      outgoingMeta: Color.lerp(outgoingMeta, other.outgoingMeta, t)!,
      readReceipt: Color.lerp(readReceipt, other.readReceipt, t)!,
      sentReceipt: Color.lerp(sentReceipt, other.sentReceipt, t)!,
      online: Color.lerp(online, other.online, t)!,
      typing: Color.lerp(typing, other.typing, t)!,
      systemBubble: Color.lerp(systemBubble, other.systemBubble, t)!,
      systemText: Color.lerp(systemText, other.systemText, t)!,
    );
  }
}

/// Acceso abreviado a las extensiones de tema de FinChat.
extension FinChatThemeContext on BuildContext {
  /// Colores de mensajería del tema activo.
  ChatColors get chatColors =>
      Theme.of(this).extension<ChatColors>() ?? ChatColors.light;
}

/// Sistema de diseño Material 3 de FinChat (modo claro y oscuro).
abstract final class AppTheme {
  // Radios y espaciados compartidos
  /// Radio estándar de componentes.
  static const double radius = 12;

  /// Radio de burbujas de chat.
  static const double bubbleRadius = 10;

  /// Padding interno de campos de texto.
  static const EdgeInsets inputPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 14);

  // Alias heredados usados por las vistas existentes
  static const Color primaryColor = AppColors.tealDark;
  static const Color primaryDark = Color(0xFF054C44);
  static const Color accentColor = AppColors.teal;
  static const Color backgroundColor = AppColors.backgroundLight;
  static const Color surfaceColor = AppColors.surfaceLight;
  static const Color chatBubbleMe = AppColors.bubbleOutgoingLight;
  static const Color chatBubbleOther = AppColors.bubbleIncomingLight;
  static const Color blueCheckColor = AppColors.readReceipt;
  static const Color errorColor = AppColors.errorLight;
  static const Color textDark = AppColors.textPrimaryLight;
  static const Color textMuted = AppColors.textSecondaryLight;

  /// Tema claro.
  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.tealDark,
      primary: AppColors.tealDark,
      onPrimary: Colors.white,
      secondary: AppColors.tealAccent,
      onSecondary: Colors.white,
      tertiary: AppColors.teal,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      onSurfaceVariant: AppColors.textSecondaryLight,
      outline: AppColors.outlineLight,
      outlineVariant: AppColors.outlineLight,
      error: AppColors.errorLight,
      onError: Colors.white,
    );
    return _build(
      scheme: scheme,
      background: AppColors.backgroundLight,
      appBarBackground: AppColors.tealDark,
      appBarForeground: Colors.white,
      inputFill: AppColors.surfaceLight,
      chatColors: ChatColors.light,
    );
  }

  /// Tema oscuro.
  static ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      brightness: Brightness.dark,
      primary: AppColors.teal,
      onPrimary: AppColors.chatWallpaperDark,
      secondary: AppColors.green,
      onSecondary: AppColors.chatWallpaperDark,
      tertiary: AppColors.tealAccent,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      onSurfaceVariant: AppColors.textSecondaryDark,
      surfaceContainerHighest: AppColors.surfaceDarkHigh,
      outline: AppColors.outlineDark,
      outlineVariant: AppColors.outlineDark,
      error: AppColors.errorDark,
      onError: AppColors.onErrorDark,
    );
    return _build(
      scheme: scheme,
      background: AppColors.backgroundDark,
      appBarBackground: AppColors.surfaceDark,
      appBarForeground: AppColors.textPrimaryDark,
      inputFill: AppColors.surfaceDarkHigh,
      chatColors: ChatColors.dark,
    );
  }

  // Construye ThemeData común a ambos modos
  static ThemeData _build({
    required ColorScheme scheme,
    required Color background,
    required Color appBarBackground,
    required Color appBarForeground,
    required Color inputFill,
    required ChatColors chatColors,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: scheme.brightness,
    );
    final textTheme = _textTheme(base.textTheme, scheme);
    final rounded = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );

    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      visualDensity: VisualDensity.standard,
      extensions: <ThemeExtension<dynamic>>[chatColors],

      // Barra superior
      appBarTheme: AppBarThemeData(
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: appBarForeground,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: appBarForeground),
      ),

      // Botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 0,
          shape: rounded,
          textStyle: textTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: rounded,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(64, 48),
          side: BorderSide(color: scheme.outline),
          shape: rounded,
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.secondary,
        foregroundColor: scheme.onSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Campos de texto
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: inputFill,
        contentPadding: inputPadding,
        hintStyle: textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        labelStyle: textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        floatingLabelStyle: TextStyle(color: scheme.primary),
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
        border: inputBorder(scheme.outline),
        enabledBorder: inputBorder(scheme.outline),
        focusedBorder: inputBorder(scheme.primary, 2),
        errorBorder: inputBorder(scheme.error),
        focusedErrorBorder: inputBorder(scheme.error, 2),
        disabledBorder: inputBorder(scheme.outline.withValues(alpha: 0.5)),
      ),

      // Tarjetas y listas
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        clipBehavior: Clip.antiAlias,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        minVerticalPadding: 10,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 0.6,
        space: 1,
      ),

      // Navegación
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withValues(alpha: 0.16),
        surfaceTintColor: Colors.transparent,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected)
                ? scheme.onSurface
                : scheme.onSurfaceVariant,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: appBarForeground,
        unselectedLabelColor: appBarForeground.withValues(alpha: 0.7),
        indicatorColor: appBarForeground,
        labelStyle: textTheme.titleSmall,
        dividerColor: Colors.transparent,
      ),

      // Superposiciones
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: rounded,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.primary,
        selectionColor: scheme.primary.withValues(alpha: 0.3),
        selectionHandleColor: scheme.primary,
      ),
    );
  }

  // Tipografía legible con pesos ajustados
  static TextTheme _textTheme(TextTheme base, ColorScheme scheme) {
    return base
        .copyWith(
          titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          bodyLarge: base.bodyLarge?.copyWith(fontSize: 16, height: 1.4),
          bodyMedium: base.bodyMedium?.copyWith(fontSize: 15, height: 1.4),
          labelLarge: base.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        )
        .apply(
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
        );
  }
}
