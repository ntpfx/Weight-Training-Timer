import 'package:flutter/services.dart';

class HapticService {
  static bool enabled = true;

  static void light() {
    if (!enabled) return;
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}
  }

  static void medium() {
    if (!enabled) return;
    try {
      HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  static void heavy() {
    if (!enabled) return;
    try {
      HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  static void countdownTick() {
    if (!enabled) return;
    try {
      HapticFeedback.selectionClick();
    } catch (_) {}
  }

  static void timerFinished() {
    if (!enabled) return;
    try {
      HapticFeedback.vibrate();
      Future.delayed(const Duration(milliseconds: 150), () {
        HapticFeedback.heavyImpact();
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        HapticFeedback.heavyImpact();
      });
    } catch (_) {}
  }
}
