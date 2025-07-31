import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Stream controller for broadcasting connectivity changes
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  Future<void> init() async {
    // Initialize connectivity service and start listening
    _startListening();
  }

  /// Check current connectivity status
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return await _connectivity.checkConnectivity();
  }

  /// Check if device has internet connectivity
  Future<bool> hasInternetConnection() async {
    final connectivityResult = await checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }

    // Additional check to verify actual internet connectivity
    return await _hasActualInternetConnection();
  }

  /// Verify actual internet connectivity by pinging reliable hosts
  Future<bool> _hasActualInternetConnection() async {
    // TODO: IS THIS THE RIGHT APPROACH?
    // List of reliable DNS servers and domains to check
    final List<String> testHosts = [
      '8.8.8.8', // Google DNS
      '1.1.1.1', // Cloudflare DNS
      'dns.google.com', // Google DNS over HTTPS
      'cloudflare-dns.com', // Cloudflare DNS
    ];

    // Try each host until one succeeds
    for (final host in testHosts) {
      try {
        final result = await InternetAddress.lookup(host)
            .timeout(const Duration(seconds: 3));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } on SocketException catch (_) {
        continue; // Try next host
      } on TimeoutException catch (_) {
        continue; // Try next host
      }
    }

    return false; // All hosts failed
  }

  /// Get connectivity stream that returns bool (true = connected, false = disconnected)
  Stream<bool> get connectivityStream {
    return _connectivityController.stream;
  }

  /// Get raw connectivity result stream
  Stream<List<ConnectivityResult>> get rawConnectivityStream {
    return _connectivity.onConnectivityChanged;
  }

  /// Check if connected to WiFi
  Future<bool> isConnectedToWiFi() async {
    final connectivityResult = await checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.wifi);
  }

  /// Check if connected to mobile data
  Future<bool> isConnectedToMobile() async {
    final connectivityResult = await checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile);
  }

  /// Get connectivity type as string
  Future<String> getConnectivityType() async {
    final connectivityResult = await checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return 'Mobile Data';
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    } else {
      return 'No Connection';
    }
  }

  /// Start listening to connectivity changes
  void _startListening() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> result) async {
        final hasConnection = await hasInternetConnection();
        _connectivityController.add(hasConnection);
      },
    );
  }

  /// Stop listening to connectivity changes
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityController.close();
  }
}
