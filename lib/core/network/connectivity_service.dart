import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Firma de la verificación de salida real a internet.
typedef ReachabilityProbe = Future<bool> Function();

/// Servicio reactivo de conectividad para la arquitectura Offline-First.
///
/// Combina los eventos de [Connectivity] con una verificación DNS real para
/// descartar falsos positivos (p. ej. WiFi sin salida a internet).
///
/// Se integra con `Provider` mediante `ChangeNotifierProvider.value` y expone
/// [onConnectivityChanged] para oyentes en segundo plano.
class ConnectivityService extends ChangeNotifier {
  /// Devuelve la instancia compartida del servicio.
  factory ConnectivityService() =>
      _instance ??= ConnectivityService._(Connectivity(), _defaultProbe);

  /// Crea una instancia aislada con dependencias inyectadas (solo pruebas).
  @visibleForTesting
  factory ConnectivityService.withDependencies({
    required Connectivity connectivity,
    required ReachabilityProbe probe,
  }) =>
      ConnectivityService._(connectivity, probe);

  ConnectivityService._(this._connectivity, this._probe);

  static ConnectivityService? _instance;

  /// Host usado para la verificación DNS.
  static const String lookupHost = 'google.com';

  /// Tiempo máximo de espera de la verificación DNS.
  static const Duration lookupTimeout = Duration(seconds: 5);

  final Connectivity _connectivity;
  final ReachabilityProbe _probe;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _hasInternet = true;
  bool _isSimulatedOffline = false;
  bool _isInitialized = false;
  bool _isDisposed = false;
  int _checkToken = 0;

  /// Indica si hay acceso real a internet en este momento.
  bool get isOnline => !_isSimulatedOffline && _hasInternet;

  /// Indica si la desconexión simulada está activa.
  bool get isSimulatedOffline => _isSimulatedOffline;

  /// Indica si el servicio ya está escuchando cambios de red.
  bool get isInitialized => _isInitialized;

  /// Emite el nuevo estado cada vez que [isOnline] cambia.
  Stream<bool> get onConnectivityChanged => _controller.stream;

  /// Comienza a escuchar cambios de red y realiza un chequeo inicial.
  ///
  /// Es idempotente: llamadas sucesivas no crean suscripciones duplicadas.
  Future<void> initialize() async {
    if (_isInitialized || _isDisposed) return;
    _isInitialized = true;

    _subscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('[ConnectivityService] Error en stream de red: $error');
      },
    );

    await checkConnection();
  }

  /// Verifica bajo demanda el acceso real a internet y actualiza el estado.
  Future<bool> checkConnection() async {
    final token = ++_checkToken;
    final results = await _safeCheckConnectivity();
    final hasInternet = await _evaluate(results);
    if (token == _checkToken) _updateStatus(hasInternet);
    return isOnline;
  }

  /// Activa o desactiva la desconexión simulada para pruebas del modo Offline.
  void toggleOfflineSimulation(bool simulateOffline) {
    if (_isDisposed || _isSimulatedOffline == simulateOffline) return;
    final previous = isOnline;
    _isSimulatedOffline = simulateOffline;
    _notifyIfChanged(previous);
  }

  // Reacciona a eventos del sistema descartando chequeos obsoletos
  Future<void> _handleConnectivityChange(List<ConnectivityResult> results) async {
    final token = ++_checkToken;
    final hasInternet = await _evaluate(results);
    if (token == _checkToken) _updateStatus(hasInternet);
  }

  // Consulta el tipo de red sin propagar fallos del plugin
  Future<List<ConnectivityResult>?> _safeCheckConnectivity() async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (error) {
      debugPrint('[ConnectivityService] checkConnectivity falló: $error');
      return null;
    }
  }

  // Sin interfaz de red no hay internet; con interfaz, se confirma por DNS
  Future<bool> _evaluate(List<ConnectivityResult>? results) async {
    if (results != null &&
        (results.isEmpty || results.every((r) => r == ConnectivityResult.none))) {
      return false;
    }
    try {
      return await _probe();
    } catch (error) {
      debugPrint('[ConnectivityService] Verificación de alcance falló: $error');
      return false;
    }
  }

  // Aplica el nuevo estado real de red
  void _updateStatus(bool hasInternet) {
    if (_isDisposed || _hasInternet == hasInternet) return;
    final previous = isOnline;
    _hasInternet = hasInternet;
    _notifyIfChanged(previous);
  }

  // Notifica a UI y stream solo si el estado efectivo cambió
  void _notifyIfChanged(bool previous) {
    final current = isOnline;
    if (previous == current) return;
    _controller.add(current);
    notifyListeners();
  }

  // Lookup DNS ligero; en Web no hay DNS nativo y se confía en el plugin
  static Future<bool> _defaultProbe() async {
    if (kIsWeb) return true;
    try {
      final addresses =
          await InternetAddress.lookup(lookupHost).timeout(lookupTimeout);
      return addresses.isNotEmpty && addresses.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  }

  /// Cancela la suscripción, cierra el stream y libera la instancia compartida.
  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _checkToken++;
    unawaited(_subscription?.cancel());
    unawaited(_controller.close());
    if (identical(_instance, this)) _instance = null;
    super.dispose();
  }
}
