import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Provider untuk status koneksi internet aktual (ping DNS agar pasti online).
class NetworkStatusProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  // Sejak connectivity_plus 6.x stream mengirim List<ConnectivityResult>
  StreamSubscription<List<ConnectivityResult>>? _sub;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  ConnectivityResult _last = ConnectivityResult.none;
  ConnectivityResult get lastConnectivity => _last;

  NetworkStatusProvider() {
    _init();
  }

  Future<void> _init() async {
    final initialList = await _connectivity.checkConnectivity();
    // Ambil prioritas: wifi > ethernet > mobile > lainnya
    _last = _pickPrimary(initialList);
    _isOnline = await _verify(_last);
    notifyListeners();

    _sub = _connectivity.onConnectivityChanged.listen((results) async {
      final picked = _pickPrimary(results);
      _last = picked;
      final online = await _verify(picked);
      if (online != _isOnline) {
        _isOnline = online;
        if (kDebugMode) {
          debugPrint('[NetworkStatus] online=$_isOnline via $picked');
        }
        notifyListeners();
      }
    });
  }

  ConnectivityResult _pickPrimary(List<ConnectivityResult> list) {
    if (list.isEmpty) return ConnectivityResult.none;
    const priority = [
      ConnectivityResult.wifi,
      ConnectivityResult.ethernet,
      ConnectivityResult.mobile,
      ConnectivityResult.bluetooth,
      ConnectivityResult.vpn,
    ];
    for (final p in priority) {
      if (list.contains(p)) return p;
    }
    return list.first;
  }

  Future<bool> _verify(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) return false;
    try {
      final socket = await Socket.connect('dns.google', 53, timeout: const Duration(milliseconds: 900));
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
