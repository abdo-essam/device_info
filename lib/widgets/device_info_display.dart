import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../widgets/info_card.dart';

class DeviceInfoDisplay extends StatefulWidget {
  const DeviceInfoDisplay({super.key});

  @override
  State<DeviceInfoDisplay> createState() => _DeviceInfoDisplayState();
}

class _DeviceInfoDisplayState extends State<DeviceInfoDisplay> {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  Map<String, String> _deviceData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await _deviceInfo.androidInfo;
        if (!mounted) return;

        setState(() {
          _deviceData = {
            'Device Model': androidInfo.model,
            'OS Version': 'Android ${androidInfo.version.release}',
            'Brand': androidInfo.brand,
            'Manufacturer': androidInfo.manufacturer,
          };
        });
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        if (!mounted) return;

        setState(() {
          _deviceData = {
            'Device Model': iosInfo.model ?? 'Unknown',
            'OS Version': 'iOS ${iosInfo.systemVersion ?? 'Unknown'}',
            'System Name': iosInfo.systemName ?? 'Unknown',
            'Name': iosInfo.name ?? 'Unknown',
          };
        });
      } else {
        setState(() {
          _deviceData = {
            'Platform': defaultTargetPlatform.toString(),
            'Note': 'Detailed info not available for this platform',
          };
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Error getting device info: $e');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          _deviceData = {
            'Error': 'Failed to get device information',
            'Details': e.toString(),
          };
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _deviceData.entries.map((entry) {
            return InfoCard(
              title: entry.key,
              value: entry.value,
            );
          }).toList(),
        ),
      ),
    );
  }
}