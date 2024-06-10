// home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '/controllers/bluetooth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instance of the BluetoothController.
  final BluetoothController bluetoothController = BluetoothController();

  @override
  void initState() {
    super.initState();
    // Start scanning for Bluetooth devices when the screen is initialized.
    bluetoothController.startScan();
  }

  @override
  void dispose() {
    // Stop scanning for Bluetooth devices when the screen is disposed.
    bluetoothController.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
      ),
      body: StreamBuilder<List<ScanResult>>(
        // Listen to the stream of scanned Bluetooth devices.
        stream: bluetoothController.scanResults,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If there are scanned devices, display them in a ListView.
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                // Get the device name and address.
                final device = snapshot.data![index].device;
                return ListTile(
                  title: Text(device.name.isEmpty ? 'Unknown Device' : device.name),
                  subtitle: Text(device.id.toString()),
                );
              },
            );
          } else if (snapshot.hasError) {
            // If there's an error, display an error message.
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // While scanning, show a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
