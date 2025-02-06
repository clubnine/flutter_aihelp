import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_aihelp/flutter_aihelp.dart';
import 'package:flutter_aihelp/flutter_aihelp_platform_interface.dart';
import 'package:flutter_aihelp/flutter_aihelp_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterAihelpPlatform with MockPlatformInterfaceMixin implements FlutterAihelpPlatform {
  @override
  Future<String?> showQA(String ucode, String nickName, String aiHelpDomain, String aiHelpAppId, String aiHelpAppKey) {
    return Future.value('');
  }

  @override
  Future<String?> openNotificationSettings() => Future.value('');

  @override
  Future<String?> initQA(String ucode, String nickName, String aiHelpDomain, String aiHelpAppId, String aiHelpAppKey) {
    return Future.value('');
  }
}

void main() {
  final FlutterAihelpPlatform initialPlatform = FlutterAihelpPlatform.instance;

  test('$MethodChannelFlutterAihelp is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterAihelp>());
  });

  test('getPlatformVersion', () async {
    FlutterAihelp flutterAihelpPlugin = FlutterAihelp();
    MockFlutterAihelpPlatform fakePlatform = MockFlutterAihelpPlatform();
    FlutterAihelpPlatform.instance = fakePlatform;
  });
}
