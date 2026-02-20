import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityService {
  StreamSubscription? _subscription;
  final ValueNotifier<bool> isNear = ValueNotifier(false);

  void startListening() {
    try {
      _subscription = ProximitySensor.events.listen((int event) {
        // event = 1 means near, 0 means far
        isNear.value = event == 1;
      });
    } catch (e) {
      debugPrint('Proximity sensor not available: $e');
    }
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    isNear.value = false;
  }

  void dispose() {
    stopListening();
    isNear.dispose();
  }
}
