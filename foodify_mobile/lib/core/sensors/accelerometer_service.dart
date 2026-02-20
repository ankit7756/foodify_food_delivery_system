import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerService {
  static const double _shakeThreshold = 15.0;
  static const int _shakeCooldownMs = 2000;

  StreamSubscription? _subscription;
  DateTime? _lastShakeTime;
  final VoidCallback onShake;

  AccelerometerService({required this.onShake});

  void startListening() {
    _subscription = accelerometerEventStream().listen((event) {
      final double magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      final double force = (magnitude - 9.8).abs();

      if (force > _shakeThreshold) {
        final now = DateTime.now();
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!).inMilliseconds > _shakeCooldownMs) {
          _lastShakeTime = now;
          onShake();
        }
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }
}
