import 'package:flutter/material.dart';
import '../widgets/device_info_display.dart';

class DeviceInfoScreen extends StatelessWidget {
  const DeviceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Information'),
        centerTitle: true,
      ),
      body: const DeviceInfoDisplay(),
    );
  }
}