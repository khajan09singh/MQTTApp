import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:testproject/MQTTManager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MQTTManager manager;

  void _configureAndConnect() {
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    manager = MQTTManager(
      host: "192.168.1.73",
      topic: "app/temp",
      identifier: osPrefix,
    );
    manager.initializeMQTTClient();
    manager.connect();
  }

  void _disconnect() {
    manager.disconnect();
  }

  void _publishMessage(String text) {
    String osPrefix = "mobile_client";
    final String message = osPrefix + ' says: ' + text;
    manager.publish(message);
  }

  @override
  void initState() {
    _configureAndConnect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Demo',
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(100, 200, 0, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(240, 50),
                  ),
                  onPressed: () {
                    try {
                      _publishMessage("Refresh");
                    } on ConnectionException catch (e) {
                      print(e);
                      final snackBar = SnackBar(
                        content: const Text('Connecting...'),
                        backgroundColor: (Colors.black),
                        duration: const Duration(seconds: 1),
                        action: SnackBarAction(
                          label: 'Dismiss',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text(
                    "Refresh",
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 17.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    _disconnect();
    super.deactivate();
  }
}
