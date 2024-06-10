// bluetooth_controller.dart

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothController {
  // Instance of FlutterBlue, which provides Bluetooth functionalities.
  FlutterBlue flutterBlue = FlutterBlue.instance;

  // Method to start scanning for Bluetooth devices.
  void startScan() {
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
  }

  // Method to stop scanning for Bluetooth devices.
  void stopScan() {
    flutterBlue.stopScan();
  }

  // Stream of scanned Bluetooth devices.
  Stream<List<ScanResult>> get scanResults => flutterBlue.scanResults.map((results) => results.toList());

  // Method to get the state of the Bluetooth (on/off).
  Stream<BluetoothState> get state => flutterBlue.state;
}
