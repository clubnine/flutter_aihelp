import UIKit
import Flutter
import AIHelpSupportSDK

// Define global variables
private var aiHelpAppId: String?
private var userUcode: String?
private var userNickname: String?

// Define C callback type and callback function
typealias AISupportInitCallback = @convention(c) (Bool, UnsafePointer<CChar>?) -> Void

// Callback function to handle AIHelp SDK initialization
private let callbackPointer: AISupportInitCallback = { isSuccess, message in
    DispatchQueue.main.async {
        showQASection()
    }
}

// Show the QA section
private func showQASection() {
    guard let ucode = userUcode, let nickname = userNickname else { return }

    let faqConversationConfigBuilder : AIHelpConversationConfigBuilder = AIHelpConversationConfigBuilder.init();
    faqConversationConfigBuilder.conversationIntent = .botSupport
    faqConversationConfigBuilder.alwaysShowHumanSupportButtonInBotPage = true
    let faqConversationConfig:AIHelpConversationConfig = faqConversationConfigBuilder.build()

    let faqConfig: AIHelpFAQConfigBuilder = AIHelpFAQConfigBuilder.init();
    faqConfig.showConversationMoment = .always;
    faqConfig.conversationConfig = faqConversationConfig
    faqConfig.build()
    AIHelpSupportSDK.showConversation(faqConversationConfig)


    let userBuilder: AIHelpUserConfigBuilder = AIHelpUserConfigBuilder.init()
    userBuilder.userId = ucode
    userBuilder.userName = nickname
    AIHelpSupportSDK.updateUserInfo(userBuilder.build())
}

public class FlutterAihelpPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_aihelp", binaryMessenger: registrar.messenger())
        let instance = FlutterAihelpPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "notifySetting":
            openNotificationSettings()
            result("notifySetting")
        case "showQA":
            handleShowQA(call: call, result: result)
        case "initQA":
            initShowQA(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
   // Handle showing the QA section
    private func initShowQA(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let domain = arguments["aiHelpDomain"] as? String,
              let appKey = arguments["aiHelpAppKey"] as? String,
              let appId = arguments["aiHelpAppId"] as? String,
              let ucode = arguments["ucode"] as? String,
              let nickname = arguments["nickName"] as? String else {
            result(FlutterMethodNotImplemented)
            return
        }

        // Update global variables and initialize the SDK
        updateUserInformation(appId: appId, ucode: ucode, nickname: nickname)
        initializeAIHelpSDK(appKey: appKey, domain: domain, appId: appId)
        result("initQA")
    }

    // Handle showing the QA section
    private func handleShowQA(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let domain = arguments["aiHelpDomain"] as? String,
              let appKey = arguments["aiHelpAppKey"] as? String,
              let appId = arguments["aiHelpAppId"] as? String,
              let ucode = arguments["ucode"] as? String,
              let nickname = arguments["nickName"] as? String else {
            result(FlutterMethodNotImplemented)
            return
        }

        // Check if appId is already initialized
        if appId == aiHelpAppId {
            showQASection()
            result("showQA")
            return
        }

        // Update global variables and initialize the SDK
        updateUserInformation(appId: appId, ucode: ucode, nickname: nickname)
        initializeAIHelpSDK(appKey: appKey, domain: domain, appId: appId)
        result("showQA")
    }

    // Update user information
    private func updateUserInformation(appId: String, ucode: String, nickname: String) {
        aiHelpAppId = appId
        userUcode = ucode
        userNickname = nickname
    }

    // Initialize AIHelp SDK
    private func initializeAIHelpSDK(appKey: String, domain: String, appId: String) {
        AIHelpSupportSDK.enableLogging(true)
        AIHelpSupportSDK.initWithApiKey(appKey, domainName: domain, appId: appId)
        AIHelpSupportSDK.setOnInitializedCallback(callbackPointer)
    }

    // Open notification settings
    private func openNotificationSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}
