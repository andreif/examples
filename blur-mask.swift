import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.makeKeyAndVisible()
        
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.rootViewController = BlurController(nibName: nil, bundle: nil)
        
        return true
    }
}


class BlurController: UIViewController, UIScrollViewDelegate {
    var blurMask: UIView?
    var blurredBgImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func loadView() {
        // inside loadView there is no self.view; its job, in fact, is to create one
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(self.createContentView())
        self.view.addSubview(self.createHeaderView())
        self.view.addSubview(self.createScrollView())
        
        self.blurMask = UIView(frame: CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50))
        self.blurMask!.backgroundColor = UIColor.whiteColor()
        self.blurredBgImage!.layer.mask = self.blurMask!.layer
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.blurMask!.frame = CGRectMake(
            self.blurMask!.frame.origin.x,
            self.view.frame.size.height - 50 - scrollView.contentOffset.y,
            self.blurMask!.frame.size.width,
            self.blurMask!.frame.size.height + scrollView.contentOffset.y);
    }
    
    func createHeaderView() -> UIView {
        var headerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 60))
        
        headerView.backgroundColor = UIColor(red:229/255.0, green:39/255.0, blue:34/255.0, alpha:0.6)
        let title = UILabel(frame:CGRectMake(0, 20, self.view.frame.size.width, 40))
        title.text = "Dynamic Blur Demo"
        title.textColor = UIColor(white:1, alpha:1)
        title.font = UIFont(name:"HelveticaNeue", size:20)
        title.textAlignment = NSTextAlignment.Center
        headerView.addSubview(title)
        
        return headerView
    }
    
    func createContentView() -> UIView {
        let contentView = UIView(frame:self.view.frame)
        // Background image
        let contentImage = UIImageView(frame: contentView.frame)
        let img = UIImage(data: NSData(contentsOfURL: NSURL(string:"https://raw.githubusercontent.com/tutsplus/iOSBlurEffects/master/BlurDemo/Images.xcassets/demo-bg.imageset/demo-bg.png")!)!)
        contentImage.image = img
        contentView.addSubview(contentImage)
        
        let creditsViewContainer = UIView(frame:CGRectMake(self.view.frame.size.width/2 - 65, 335, 130, 130))
        creditsViewContainer.backgroundColor = UIColor.whiteColor()
        creditsViewContainer.layer.cornerRadius = 65
        contentView.addSubview(creditsViewContainer)
        
        let photoTitle = UILabel(frame:CGRectMake(0, 54, 130, 18))
        photoTitle.text = "Peach Garden"
        photoTitle.font = UIFont(name:"HelveticaNeue-Light", size:18)
        photoTitle.textAlignment = NSTextAlignment.Center
        photoTitle.textColor = UIColor(white:0.4, alpha:1)
        creditsViewContainer.addSubview(photoTitle)
        
        let photographer = UILabel(frame:CGRectMake(0, 72, 130, 9))
        photographer.text = "by Cas Cornelissen"
        photographer.font = UIFont(name:"HelveticaNeue-Thin", size:9)
        photographer.textAlignment = NSTextAlignment.Center
        photographer.textColor = UIColor(white:0.4, alpha:1)
        creditsViewContainer.addSubview(photographer)
        
        return contentView
    }
    
    func createScrollView() -> UIView {
        let containerView = UIView(frame:self.view.frame)
        
        self.blurredBgImage = UIImageView(frame:CGRectMake(0, 0, self.view.frame.size.width, 568))
        self.blurredBgImage!.contentMode = UIViewContentMode.ScaleToFill
        self.blurredBgImage!.image = UIImage(named: "demo-bg-blur")
        containerView.addSubview(self.blurredBgImage!)
        
        let scrollView = UIScrollView(frame:self.view.frame)
        containerView.addSubview(scrollView)
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2 - 110)
        scrollView.pagingEnabled = true
        scrollView.delegate = self;
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        let slideContentView = UIView(frame:CGRectMake(0, 518, self.view.frame.size.width, 508))
        slideContentView.backgroundColor = UIColor.clearColor()
        scrollView.addSubview(slideContentView)
        
        let slideUpLabel = UILabel(frame:CGRectMake(0, 6, self.view.frame.size.width, 50))
        slideUpLabel.text = "Photo information"
        slideUpLabel.font = UIFont(name:"HelveticaNeue-Light", size:18)
        slideUpLabel.textAlignment = NSTextAlignment.Center
        slideUpLabel.textColor = UIColor(white:0, alpha:0.5)
        slideContentView.addSubview(slideUpLabel)
        
        let slideUpImage = UIImageView(frame:CGRectMake(self.view.frame.size.width/2 - 12, 4, 24, 22.5))
        let img = UIImage(data: NSData(contentsOfURL: NSURL(string:"https://raw.githubusercontent.com/tutsplus/iOSBlurEffects/master/BlurDemo/Images.xcassets/up-arrow.imageset/up-arrow.png")!)!)
        slideUpImage.image = img
        slideContentView.addSubview(slideUpImage)
        
        let detailsText = UITextView(frame:CGRectMake(25, 100, 270, 350))
        detailsText.backgroundColor = UIColor.clearColor()
        detailsText.text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        detailsText.font = UIFont(name: "HelveticaNeue-Light", size:16)
        detailsText.textAlignment = NSTextAlignment.Center
        detailsText.textColor = UIColor(white:0, alpha:0.6)
        slideContentView.addSubview(detailsText)
        
        return containerView
    }
}
