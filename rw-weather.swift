import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = MainController(nibName: nil, bundle: nil)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }
}

class MainController: UIViewController, UIScrollViewDelegate { // UITableViewDataSource, UITableViewDelegate
    var backgroundImageView: UIImageView?
    var blurredImageView: UIImageView?
    var tableView: UITableView?
    var screenHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenHeight = UIScreen.mainScreen().bounds.size.height

        let background = UIImage(named: "page1")
        self.backgroundImageView = BlurImageView(frame: self.view.frame)
        self.backgroundImageView!.image = background
        self.backgroundImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(self.backgroundImageView!)
        /*
        self.blurredImageView = UIImageView()
        self.blurredImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.blurredImageView!.alpha = 0
        background.applyBlur(radius:30 tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil]
        self.blurredImageView!.setImageToBlur(background, blurRadius:10, completionBlock:nil)
        self.view.addSubview(self.blurredImageView!)
        */
        
        //self.view.backgroundColor = UIColor.redColor()
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

class BlurImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var blur: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView: UIVisualEffectView = UIVisualEffectView(effect: blur)
        effectView.frame = frame
        addSubview(effectView)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
