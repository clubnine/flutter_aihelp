import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_aihelp_platform_interface.dart';

/// An implementation of [FlutterAihelpPlatform] that uses method channels.
class MethodChannelFlutterAihelp extends FlutterAihelpPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_aihelp');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> showQA(
      String ucode, String nickName, String aiHelpDomain, String aiHelpAppId, String aiHelpAppKey) async {
    return await methodChannel.invokeMethod('showQA', {
      'ucode': ucode,
      'nickName': nickName,
      'aiHelpDomain': aiHelpDomain,
      'aiHelpAppId': aiHelpAppId,
      'aiHelpAppKey': aiHelpAppKey,
    });
  }
}
