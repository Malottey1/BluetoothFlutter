import 'package:flutter/material.dart'; // Importing the Material package for Flutter's UI components
import 'package:flutter_blue/flutter_blue.dart'; // Importing the FlutterBlue package to work with Bluetooth

// Entry point of the Flutter application
void main() {
  runApp(MyApp());
}

// The root widget of the application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Scanner', // Setting the title of the application
      theme: ThemeData(
        primarySwatch: Colors.blue, // Setting the primary color theme
      ),
      home: BluetoothScanner(), // Setting the home screen of the app to be the BluetoothScanner widget
    );
  }
}

// Stateful widget to manage Bluetooth scanning
class BluetoothScanner extends StatefulWidget {
  @override
  _BluetoothScannerState createState() => _BluetoothScannerState();
}

// State class for BluetoothScanner to manage its state
class _BluetoothScannerState extends State<BluetoothScanner> {
  FlutterBlue flutterBlue = FlutterBlue.instance; // Singleton instance of FlutterBlue
  List<ScanResult> scanResults = []; // List to store scan results
  bool isScanning = false; // Boolean to track if scanning is in progress

  @override
  void initState() {
    super.initState();
    // Listening to the Bluetooth state changes
    flutterBlue.state.listen((state) {
      if (state == BluetoothState.on) {
        startScan(); // Start scanning if Bluetooth is turned on
      } else {
        stopScan(); // Stop scanning if Bluetooth is turned off
      }
    });
  }

  // Method to start scanning for Bluetooth devices
  void startScan() {
    setState(() {
      isScanning = true; // Update UI to show scanning is in progress
    });

    // Start scanning with a timeout of 4 seconds
    flutterBlue.startScan(timeout: Duration(seconds: 4)).then((_) {
      setState(() {
        isScanning = false; // Update UI to show scanning is completed
      });
    });

    // Listen to scan results and update the UI
    flutterBlue.scanResults.listen((results) {
      setState(() {
        scanResults = results; // Store the scan results
      });
    });
  }

  // Method to stop scanning for Bluetooth devices
  void stopScan() {
    flutterBlue.stopScan(); // Stop scanning
    setState(() {
      isScanning = false; // Update UI to show scanning is stopped
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Scanner'), // Title of the AppBar
        actions: [
          // Action button to start/stop scanning
          IconButton(
            icon: Icon(isScanning ? Icons.stop : Icons.search), // Display stop icon if scanning, else search icon
            onPressed: isScanning ? stopScan : startScan, // Toggle scanning on button press
          )
        ],
      ),
      // Displaying the list of scan results
      body: ListView.builder(
        itemCount: scanResults.length, // Number of items in the list
        itemBuilder: (context, index) {
          var result = scanResults[index]; // Get the scan result at the given index
          return ListTile(
            title: Text(result.device.name.isEmpty
                ? '(unknown device)' // Display '(unknown device)' if no name
                : result.device.name), // Else display the device name
            subtitle: Text(result.device.id.toString()), // Display the device ID
            trailing: Text('${result.rssi} dBm'), // Display the signal strength
          );
        },
      ),
    );
  }
}
