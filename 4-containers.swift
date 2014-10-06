import UIKit
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.makeKeyAndVisible()
        let controller = TapController(nibName: nil, bundle: nil)
        let nav_controller = UINavigationController(rootViewController: controller)
        let tab_controller = UITabBarController(nibName: nil, bundle: nil)
        let other_controller = UIViewController(nibName: nil, bundle: nil)
        other_controller.title = "Other"
        other_controller.view.backgroundColor = UIColor.purpleColor()
        tab_controller.viewControllers = [nav_controller!, other_controller]
        self.window!.rootViewController = tab_controller
        return true
    }
}

class TapController: UIViewController {
    var label: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.label = UILabel(frame: CGRectZero)
        self.label!.text = "Taps"
        self.label!.sizeToFit()
        self.label!.center = CGPoint(
            x: self.view.frame.size.width / 2,
            y: self.view.frame.size.height / 2)
        self.view.addSubview(self.label!)
        self.title = "Tap \(self.navigationController!.viewControllers.count)"
        let right_button = UIBarButtonItem(title: "Push", style: UIBarButtonItemStyle.Bordered, target: self, action: "push")
        self.navigationItem.rightBarButtonItem = right_button
    }
    func push() {
        let new_controller = TapController(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(new_controller, animated: true)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Favorites, tag: 1)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
