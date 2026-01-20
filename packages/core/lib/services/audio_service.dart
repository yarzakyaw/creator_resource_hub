import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AudioService {
  AudioService._internal();
  static final AudioService instance = AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _initialized = false;
  String? _currentUrl;

  AudioPlayer get player => _player;

  /// Must be called once (app startup or first use)
  Future<void> init() async {
    if (_initialized) return;

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _initialized = true;
  }

  /// Load audio (cached if possible)
  Future<void> load(String url) async {
    if (_currentUrl == url) return;

    final file = await _getCachedFile(url);

    await _player.setAudioSource(AudioSource.uri(Uri.file(file.path)));

    _currentUrl = url;
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();

  Future<void> dispose() async {
    await _player.dispose();
  }

  /// Cache or retrieve audio file
  Future<File> _getCachedFile(String url) async {
    final cache = DefaultCacheManager();

    final cached = await cache.getFileFromCache(url);
    if (cached != null) {
      return cached.file;
    }

    final downloaded = await cache.downloadFile(url);
    return downloaded.file;
  }
}
