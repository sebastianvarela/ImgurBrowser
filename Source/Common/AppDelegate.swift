import Power
import UIKit

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?

    public static var shared: AppDelegate {
        guard let instance = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("The Application delegate is not AppDelegate")
        }
        return instance
    }
    
    public lazy var dependencies: DependenciesiOS = {
        let rootWindow = UIWindow()
        rootWindow.makeKeyAndVisible()
        self.window = rootWindow
        
        return DependenciesiOS(window: rootWindow)
    }()
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        logInfo("Hi! I'am ImgurBrowser \(dependencies.versionsController.readableAppVersion)")
        
        dependencies.rootWireframe.presentMainView()

        return true
    }

    public func applicationWillResignActive(_ application: UIApplication) {
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
    }

    public func applicationWillTerminate(_ application: UIApplication) {
    }
}
