import UIKit
import Flutter
import AIHelpSupportSDK

// 定义全局变量
private var aiHelpAppId: String?
private var userUcode: String?
private var userNickname: String?

// 定义 C 回调类型和回调函数
typealias AISupportInitCallback = @convention(c) (Bool, UnsafePointer<CChar>?) -> Void

private let callbackPointer: AISupportInitCallback = { isSuccess, message in
    showQASection()
}

// 显示 QA 界面
private func showQASection() {
    let faqConfig = AIHelpApiConfigBuilder()
    faqConfig.entranceId = "E001"
    AIHelpSupportSDK.show(with: faqConfig.build())

    guard let ucode = userUcode, let nickname = userNickname else { return }

    let userConfig = AIHelpUserConfigBuilder()
    userConfig.userId = ucode
    userConfig.userName = nickname
    AIHelpSupportSDK.updateUserInfo(userConfig.build())
}

public class FlutterAihelpPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_aihelp", binaryMessenger: registrar.messenger())
        let instance = FlutterAihelpPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard call.method == "showQA",
              let arguments = call.arguments as? [String: Any],
              let domain = arguments["aiHelpDomain"] as? String,
              let appKey = arguments["aiHelpAppKey"] as? String,
              let appId = arguments["aiHelpAppId"] as? String,
              let ucode = arguments["ucode"] as? String,
              let nickname = arguments["nickName"] as? String else {
            result(FlutterMethodNotImplemented)
            return
        }

        // 如果appId匹配，已经初始化过了，直接显示 QA 界面
        if appId == aiHelpAppId {
            showQASection()
            result("showQA")
            return
        }
        // 更新全局变量并初始化 AIHelp SDK
        aiHelpAppId = appId
        userUcode = ucode
        userNickname = nickname

        AIHelpSupportSDK.enableLogging(true)
        AIHelpSupportSDK.initWithApiKey(appKey, domainName: domain, appId: appId)
        AIHelpSupportSDK.setOnInitializedCallback(callbackPointer)
        result("showQA")
    }
}
