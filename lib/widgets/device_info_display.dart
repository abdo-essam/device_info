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
        final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        setState(() {
          _deviceData = {
            'Device Model': androidInfo.model ?? 'Unknown',
            'OS Version': androidInfo.version.release ?? 'Unknown',
            'Android SDK': androidInfo.version.sdkInt.toString() ?? 'Unknown',
            'Brand': androidInfo.brand ?? 'Unknown',
            'Manufacturer': androidInfo.manufacturer ?? 'Unknown',
            'Device': androidInfo.device ?? 'Unknown',
            'Product': androidInfo.product ?? 'Unknown',
            'Hardware': androidInfo.hardware ?? 'Unknown',
            'Display': androidInfo.display ?? 'Unknown',
            'Physical Device': androidInfo.isPhysicalDevice == null
                ? 'Unknown'
                : androidInfo.isPhysicalDevice ? 'Yes' : 'No',
          };
        });
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        setState(() {
          _deviceData = {
            'Device Model': iosInfo.model ?? 'Unknown',
            'OS Version': iosInfo.systemVersion ?? 'Unknown',
            'System Name': iosInfo.systemName ?? 'Unknown',
            'Name': iosInfo.name ?? 'Unknown',
            'Physical Device': iosInfo.isPhysicalDevice == null
                ? 'Unknown'
                : iosInfo.isPhysicalDevice ? 'Yes' : 'No',
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
      setState(() {
        _deviceData = {
          'Error': 'Failed to get device information',
          'Details': e.toString(),
        };
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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