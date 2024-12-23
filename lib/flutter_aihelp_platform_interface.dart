import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_aihelp_method_channel.dart';

abstract class FlutterAihelpPlatform extends PlatformInterface {
  /// Constructs a FlutterAihelpPlatform.
  FlutterAihelpPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAihelpPlatform _instance = MethodChannelFlutterAihelp();

  /// The default instance of [FlutterAihelpPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAihelp].
  static FlutterAihelpPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAihelpPlatform] when
  /// they register themselves.
  static set instance(FlutterAihelpPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> showQA(
      String ucode, String nickName, String aiHelpDomain, String aiHelpAppId, String aiHelpAppKey) async {
    throw UnimplementedError('showQA() has not been implemented.');
  }
}
