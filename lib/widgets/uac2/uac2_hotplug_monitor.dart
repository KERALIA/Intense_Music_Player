import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intense_audio_player/core/theme/adaptive_color_provider.dart';
import 'package:intense_audio_player/core/constants/app_constants.dart';
import 'package:intense_audio_player/providers/providers.dart';

class Uac2HotplugMonitor extends ConsumerStatefulWidget {
  const Uac2HotplugMonitor({super.key});

  @override
  ConsumerState<Uac2HotplugMonitor> createState() =>
      _Uac2HotplugMonitorState();
}

class _Uac2HotplugMonitorState extends ConsumerState<Uac2HotplugMonitor> {
  Timer? _pollTimer;
  int _lastDeviceCount = 0;
  String? _lastEventMessage;
  DateTime? _lastEventTime;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _checkDevices();
    });
  }

  Future<void> _checkDevices() async {
    final devicesAsync = ref.read(uac2DevicesProvider);
    devicesAsync.whenData((devices) {
      if (devices.length != _lastDeviceCount) {
        final isConnected = devices.length > _lastDeviceCount;
        setState(() {
          _lastEventMessage = isConnected
              ? 'Device connected'
              : 'Device disconnected';
          _lastEventTime = DateTime.now();
          _lastDeviceCount = devices.length;
        });

        if (isConnected) {
          ref.invalidate(uac2DevicesProvider);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_lastEventMessage == null || _lastEventTime == null) {
      return const SizedBox.shrink();
    }

    final timeSinceEvent = DateTime.now().difference(_lastEventTime!);
    if (timeSinceEvent.inSeconds > 5) {
      return const SizedBox.shrink();
    }

    final isConnected = _lastEventMessage!.contains('connected');

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: (isConnected ? Colors.green : Colors.orange)
            .withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isConnected ? Colors.green : Colors.orange,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isConnected ? LucideIcons.plugZap : LucideIcons.unplug,
            color: isConnected ? Colors.green : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Text(
              _lastEventMessage!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.adaptiveTextPrimary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Text(
            '${timeSinceEvent.inSeconds}s ago',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.adaptiveTextTertiary,
                ),
          ),
        ],
      ),
    );
  }
}
