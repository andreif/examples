import UIKit
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        pageControl.backgroundColor = UIColor.whiteColor()
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.makeKeyAndVisible()
        //let view = UIImageView(frame: self.window!.frame)
        //view.image = UIImage(named: "page1")
        //self.window!.addSubview(view)
        self.window!.rootViewController = ViewController(nibName: nil, bundle: nil)
        return true
    }
}
 
class ViewController: UIViewController, UIPageViewControllerDataSource {
    var pageViewController : UIPageViewController?
    var pageTitles : Array<String> = ["God vs Man", "Cool Breeze", "Fire Sky"]
    var pageImages : Array<String> = ["page1", "page2", "page3"]
    var currentIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.dataSource = self
        
        let startingViewController: PageContentViewController = self.viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        self.pageViewController!.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.didMoveToParentViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as PageContentViewController).pageIndex
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index--
        println("Decreasing Index: \(String(index))")
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as PageContentViewController).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        index++
        
        println("Increasing Index: \(String(index))")
        
        if (index == self.pageTitles.count) {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> PageContentViewController? {
        if self.pageTitles.count == 0 || index >= self.pageTitles.count {
            return nil
        }
        self.currentIndex = index
        // Create a new view controller and pass suitable data.
        let pageContentViewController = PageContentViewController(nibName: nil, bundle: nil)
        pageContentViewController.setup(index, image: self.pageImages[index], title: self.pageTitles[index])
        return pageContentViewController
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
 
class PageContentViewController: UIViewController {
    var backgroundImageView : UIImageView?
    var titleLabel : UILabel?
    var pageIndex : Int = 0
    var titleText : String = ""
    var imageFile : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    func not_set() -> Bool {
        return (self.backgroundImageView == nil)
    }
    
    func setup(index: Int, image: String, title: String) {
        if self.not_set() {
            self.backgroundImageView = UIImageView(frame: self.view.frame)
            self.titleLabel = UILabel(frame: self.view.frame)
            self.view.addSubview(self.backgroundImageView!)
            self.view.addSubview(self.titleLabel!)
        }
        self.pageIndex = index
        self.imageFile = image
        self.titleText = title
        //let img = UIImage(named: image)
        let img = UIImage(data: NSData(contentsOfURL: NSURL(string:"https://raw.githubusercontent.com/swiftcast/Swift-Example-UIPageViewController/master/Swift%20Pages/Images.xcassets/\(image).imageset/\(image).png")!)!)
        self.backgroundImageView!.image = img
        self.titleLabel!.text = title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // TODO: Dispose of any resources that can be recreated.
    }
}
