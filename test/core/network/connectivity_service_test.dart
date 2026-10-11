import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finchat/core/network/connectivity_service.dart';
import 'package:flutter_test/flutter_test.dart';

// Fake controlable del plugin de conectividad
class FakeConnectivity implements Connectivity {
  final StreamController<List<ConnectivityResult>> controller =
      StreamController<List<ConnectivityResult>>.broadcast();
  List<ConnectivityResult> current = [ConnectivityResult.wifi];

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => controller.stream;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => current;
}

void main() {
  late FakeConnectivity fake;
  late bool probeResult;
  late ConnectivityService service;

  setUp(() {
    fake = FakeConnectivity();
    probeResult = true;
    service = ConnectivityService.withDependencies(
      connectivity: fake,
      probe: () async => probeResult,
    );
  });

  tearDown(() => service.dispose());

  test('initialize sets online when network and DNS are available', () async {
    await service.initialize();
    expect(service.isOnline, isTrue);
  });

  test('WiFi without internet is reported offline', () async {
    probeResult = false;
    expect(await service.checkConnection(), isFalse);
    expect(service.isOnline, isFalse);
  });

  test('stream and listeners react to connectivity changes', () async {
    await service.initialize();
    var notifications = 0;
    service.addListener(() => notifications++);
    final emitted = <bool>[];
    final sub = service.onConnectivityChanged.listen(emitted.add);

    fake.controller.add([ConnectivityResult.none]);
    await Future<void>.delayed(Duration.zero);
    fake.controller.add([ConnectivityResult.mobile]);
    await Future<void>.delayed(Duration.zero);

    expect(emitted, [false, true]);
    expect(notifications, 2);
    await sub.cancel();
  });

  test('probe exceptions are handled as offline', () async {
    final failing = ConnectivityService.withDependencies(
      connectivity: fake,
      probe: () async => throw TimeoutException('dns'),
    );
    expect(await failing.checkConnection(), isFalse);
    failing.dispose();
  });

  test('offline simulation overrides real status', () async {
    await service.initialize();
    service.toggleOfflineSimulation(true);
    expect(service.isOnline, isFalse);
    service.toggleOfflineSimulation(false);
    expect(service.isOnline, isTrue);
  });
}
