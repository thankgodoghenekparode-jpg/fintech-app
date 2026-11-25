import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reports whether the device has a network interface. This does not imply
/// that the internet or banking API is reachable; HTTP errors remain distinct.
final deviceNetworkAvailableProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  List<ConnectivityResult> initial;
  try {
    initial = await connectivity.checkConnectivity();
  } catch (_) {
    // If the platform plugin is unavailable, don't falsely label the app offline.
    yield true;
    return;
  }
  yield _hasNetworkInterface(initial);
  yield* connectivity.onConnectivityChanged.map(_hasNetworkInterface);
});

bool _hasNetworkInterface(List<ConnectivityResult> results) =>
    results.any((result) => result != ConnectivityResult.none);
