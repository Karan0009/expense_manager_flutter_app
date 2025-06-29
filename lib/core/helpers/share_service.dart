import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class SharingService {
  static final SharingService _instance = SharingService._internal();
  factory SharingService() => _instance;
  SharingService._internal();

  final _sharedImages = <SharedMediaFile>[];
  String? _sharedText;

  StreamSubscription<List<SharedMediaFile>>? _intentSub;

  List<SharedMediaFile> get sharedImages => _sharedImages;
  String? get sharedText => _sharedText;

  void init({
    required Function(List<SharedMediaFile> images, String? text)
        onDataReceived,
  }) {
    _listenToIncomingMedia(onDataReceived);
    _handleInitialSharedData(onDataReceived);
  }

  void _listenToIncomingMedia(
    Function(List<SharedMediaFile> images, String? text) onDataReceived,
  ) {
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((files) {
      _processSharedMedia(files, onDataReceived, source: 'Live');
    }, onError: (err) {
      debugPrint("❌ Error receiving media stream: $err");
    });
  }

  Future<void> _handleInitialSharedData(
    Function(List<SharedMediaFile> images, String? text) onDataReceived,
  ) async {
    try {
      final files = await ReceiveSharingIntent.instance.getInitialMedia();
      _processSharedMedia(files, onDataReceived, source: 'Initial');
      ReceiveSharingIntent.instance.reset();
    } catch (e) {
      debugPrint("❌ Error receiving initial shared media: $e");
    }
  }

  void _processSharedMedia(
    List<SharedMediaFile> files,
    Function(List<SharedMediaFile> images, String? text) onDataReceived, {
    required String source,
  }) {
    _sharedImages.clear();
    _sharedText = null;

    for (var file in files) {
      switch (file.type) {
        case SharedMediaType.image:
          _sharedImages.add(file);
          break;
        case SharedMediaType.text:
          _sharedText = file.path; // `path` carries text in this case
          break;
        default:
          debugPrint("⚠️ Skipped unsupported media type: ${file.type}");
      }
    }

    onDataReceived(_sharedImages, _sharedText);

    debugPrint("📦 [$source] Images: ${_sharedImages.map((f) => f.path)}");
    debugPrint("📝 [$source] Text: $_sharedText");
  }

  void dispose() {
    _intentSub?.cancel();
  }

  void reset() {
    _sharedImages.clear();
    _sharedText = null;
    ReceiveSharingIntent.instance.reset();
  }
}
