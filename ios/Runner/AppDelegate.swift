import UIKit  
import Flutter  
import GoogleMaps  
import Firebase  
import FirebaseCore  
import FirebaseMessaging
// import background_locator

@main
@objc class AppDelegate: FlutterAppDelegate {  
    override func application(  
        _ application: UIApplication,  
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?  
    ) -> Bool {  
        FirebaseApp.configure()  
        GMSServices.provideAPIKey("AIzaSyCP7kyl8T11x2B8OxRJbEqIYgL47cZv7EM")  
        GeneratedPluginRegistrant.register(with: self)  
        // BackgroundLocatorPlugin.setPluginRegistrantCallback(registerPlugins)

        if #available(iOS 10.0, *) {  
            UNUserNotificationCenter.current().delegate = self  
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]  
            UNUserNotificationCenter.current().requestAuthorization(  
                options: authOptions,  
                completionHandler: { _, _ in }  
            )  
        } else {  
            let settings: UIUserNotificationSettings =  
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)  
            application.registerUserNotificationSettings(settings)  
        }  
        application.registerForRemoteNotifications()  
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)  
    }  

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {  
        Messaging.messaging().apnsToken = deviceToken  
        print("device token is: \(deviceToken) ")  
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)  
    }  
}

// func registerPlugins(registry: FlutterPluginRegistry) -> () {
//     if (!registry.hasPlugin("BackgroundLocatorPlugin")) {
//         GeneratedPluginRegistrant.register(with: registry)
//     }
// }
