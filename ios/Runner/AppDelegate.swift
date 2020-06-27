import UIKit
import Flutter
import Firebase
import UserNotifications
import Braintree

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate{
 
  let  gcmMessageIDKey = "gcm_message.id"
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions 
    launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
     if #available(iOS 10.0, *) {
  // For iOS 10 display notification (sent via APNS)
  UNUserNotificationCenter.current().delegate = self

  let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
  UNUserNotificationCenter.current().requestAuthorization(
    options: authOptions,
    completionHandler: {_, _ in })
} else {
  let settings: UIUserNotificationSettings =
  UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
  application.registerUserNotificationSettings(settings)
    };
    //  ADD YOUR BUNDLE ID  EX. com.your-company.your-app.braintree
    BTAppSwitch.setReturnURLScheme("com.your-company.your-app.braintree")
GeneratedPluginRegistrant.register(with: self)
application.registerForRemoteNotifications()
  
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
  }
  func applicationWillTerminate(_application: UIApplication) {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
  // If you are receiving a notification message while your app is in the background,
  // this callback will not be fired till the user taps on the notification launching the application.
  // TODO: Handle data of notification

  // With swizzling disabled you must let Messaging know about the message, for Analytics
  // Messaging.messaging().appDidReceiveMessage(userInfo)

  // Print message ID.
  if let messageID = userInfo[gcmMessageIDKey] {
    print("Message ID: \(messageID)")
  }

  // Print full message.
  print(userInfo)
}

func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
  // If you are receiving a notification message while your app is in the background,
  // this callback will not be fired till the user taps on the notification launching the application.
  // TODO: Handle data of notification

  // With swizzling disabled you must let Messaging know about the message, for Analytics
  // Messaging.messaging().appDidReceiveMessage(userInfo)

  // Print message ID.
  if let messageID = userInfo[gcmMessageIDKey] {
    print("Message ID: \(messageID)")
  }

  // Print full message.
  print(userInfo)

  completionHandler(UIBackgroundFetchResult.newData)
}
  }
}

extension AppDelegate: MessagingDelegate {
func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
  print("Firebase registration token: \(fcmToken)")

  let dataDict:[String: String] = ["token": fcmToken]
  NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
  // TODO: If necessary send token to application server.
  // Note: This callback is fired at each app startup and whenever a new token is generated.
}
  
}
