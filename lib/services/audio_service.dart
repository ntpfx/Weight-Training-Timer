import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal() {
    _initPlayers();
  }

  AudioPlayer? _countdownPlayer;
  AudioPlayer? _finishPlayer;
  bool isMuted = false;

  void _initPlayers() {
    try {
      _countdownPlayer = AudioPlayer();
      _finishPlayer = AudioPlayer();

      _countdownPlayer?.setReleaseMode(ReleaseMode.stop);
      _finishPlayer?.setReleaseMode(ReleaseMode.stop);
    } catch (e) {
      // Audio might not be supported on some test environments
    }
  }

  Future<void> playCountdownBeep() async {
    if (isMuted) return;
    try {
      if (_countdownPlayer != null) {
        await _countdownPlayer!.stop();
        await _countdownPlayer!.play(AssetSource('sounds/beep_countdown.wav'), volume: 1.0);
      } else {
        SystemSound.play(SystemSoundType.click);
      }
    } catch (_) {
      try {
        SystemSound.play(SystemSoundType.click);
      } catch (_) {}
    }
  }

  Future<void> playFinishBeep() async {
    if (isMuted) return;
    try {
      if (_finishPlayer != null) {
        await _finishPlayer!.stop();
        await _finishPlayer!.play(AssetSource('sounds/beep_finish.wav'), volume: 1.0);
      } else {
        SystemSound.play(SystemSoundType.click);
      }
    } catch (_) {
      try {
        SystemSound.play(SystemSoundType.click);
      } catch (_) {}
    }
  }

  void toggleMute() {
    isMuted = !isMuted;
  }

  void dispose() {
    _countdownPlayer?.dispose();
    _finishPlayer?.dispose();
  }
}
