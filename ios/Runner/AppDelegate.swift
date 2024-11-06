import Flutter
import UIKit
import NaverThirdPartyLogin
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
          GMSServices.provideAPIKey("AIzaSyBVI41IWtw_gCJunfv3IkyRJKgngGRVBfU")
          
          GeneratedPluginRegistrant.register(with: self)
        
          NaverThirdPartyLoginConnection.getSharedInstance()?.isNaverAppOauthEnable = true
          NaverThirdPartyLoginConnection.getSharedInstance()?.isInAppOauthEnable = true
          
          let thirdConn = NaverThirdPartyLoginConnection.getSharedInstance()
          thirdConn?.serviceUrlScheme = "minimalsurlscheme"
          thirdConn?.consumerKey = "a3vpiXtkLLRQV8N6XLQu"
          thirdConn?.consumerSecret = "Q6Tts16OZO"
          thirdConn?.appName = "minimals"
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var applicationResult = false
        if (!applicationResult) {
            applicationResult = NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
        }
        // if you use other application url process, please add code here.
        
        if (!applicationResult) {
            applicationResult = super.application(app, open: url, options: options)
        }
        return applicationResult
    }
}
