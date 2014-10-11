// http://www.raywenderlich.com/55384/ios-7-best-practices-part-1

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.makeKeyAndVisible()
        
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.rootViewController = WeatherController(nibName: nil, bundle: nil)
        
        return true
    }
}

class WeatherController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    var backgroundImageView: UIImageView?
    var blurView: UIVisualEffectView?
    var tableView: UITableView?
    var screenHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenHeight = UIScreen.mainScreen().bounds.size.height
        
        let background = UIImage(named: "bg")
        self.backgroundImageView = UIImageView(image: background)
        self.backgroundImageView!.backgroundColor = UIColor.blackColor()
        //self.backgroundImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(self.backgroundImageView!)

        // Parallax
        let headerFrame: CGRect = UIScreen.mainScreen().bounds
        let parallax: CGFloat = 20
        let parallaxFrame = CGRectMake(parallax * -1, parallax * -1,
            headerFrame.size.width + 2 * parallax,
            headerFrame.size.height + 2 * parallax)
        
        self.backgroundImageView!.frame = parallaxFrame
        
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath:"center.y", type:UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = parallax
        verticalMotionEffect.maximumRelativeValue = parallax * -1
        
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath:"center.x", type:UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = parallax
        horizontalMotionEffect.maximumRelativeValue = parallax * -1
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        self.backgroundImageView!.addMotionEffect(group)
        
        // Blur
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.blurView = UIVisualEffectView(effect: blur)
        self.blurView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.blurView!.alpha = 0
        self.blurView!.frame = self.view.frame
        self.view.addSubview(self.blurView!)

        self.tableView = UITableView()
        self.tableView!.backgroundColor = UIColor.clearColor()
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.separatorColor = UIColor(white:1, alpha:0.2)
        self.tableView!.pagingEnabled = true
        self.tableView!.showsVerticalScrollIndicator = false
        //self.tableView!.bounces = false
        self.view.addSubview(self.tableView!)
        
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        
        let inset: CGFloat = 20
        let temperatureHeight: CGFloat = 110
        let hiloHeight: CGFloat = 40
        let iconHeight: CGFloat = 30

        let hiloFrame: CGRect = CGRectMake(inset,
            headerFrame.size.height - hiloHeight,
            headerFrame.size.width - (2 * inset),
            hiloHeight)
        
        let temperatureFrame: CGRect = CGRectMake(inset,
            headerFrame.size.height - (temperatureHeight + hiloHeight),
            headerFrame.size.width - (2 * inset),
            temperatureHeight)
        
        let iconFrame: CGRect = CGRectMake(
            inset,
            temperatureFrame.origin.y - iconHeight,
            iconHeight * 1.0,
            iconHeight * 1.0)

        let conditionsFrame: CGRect = CGRectMake(
            iconFrame.origin.x + (iconHeight + 10),
            temperatureFrame.origin.y - iconHeight,
            self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10),
            iconHeight * 1.0)
        
        let header: UIView = UIView(frame:headerFrame)
        header.backgroundColor = UIColor.clearColor()
        self.tableView!.tableHeaderView = header
        
        // bottom left
        let temperatureLabel: UILabel = UILabel(frame:temperatureFrame)
        temperatureLabel.backgroundColor = UIColor.clearColor()
        temperatureLabel.textColor = UIColor.whiteColor()
        temperatureLabel.text = "0°"
        temperatureLabel.font = UIFont(name:"HelveticaNeue-UltraLight", size:120)
        header.addSubview(temperatureLabel)
        
        // bottom left
        let hiloLabel: UILabel = UILabel(frame:hiloFrame)
        hiloLabel.backgroundColor = UIColor.clearColor()
        hiloLabel.textColor = UIColor.whiteColor()
        hiloLabel.text = "0° / 0°"
        hiloLabel.font = UIFont(name:"HelveticaNeue-Light", size:28)
        header.addSubview(hiloLabel)
        
        // top
        let cityLabel: UILabel = UILabel(frame:CGRectMake(0, 20, self.view.bounds.size.width, 30))
        cityLabel.backgroundColor = UIColor.clearColor()
        cityLabel.textColor = UIColor.whiteColor()
        cityLabel.text = "Loading..."
        cityLabel.font = UIFont(name:"HelveticaNeue-Light", size:18)
        cityLabel.textAlignment = NSTextAlignment.Center
        header.addSubview(cityLabel)
        let conditionsLabel: UILabel = UILabel(frame:conditionsFrame)
        conditionsLabel.backgroundColor = UIColor.clearColor()
        conditionsLabel.font = UIFont(name:"HelveticaNeue-Light", size:18)
        conditionsLabel.textColor = UIColor.whiteColor()
        header.addSubview(conditionsLabel)
        
        // bottom left
        let iconView: UIImageView = UIImageView(frame:iconFrame)
        iconView.contentMode = UIViewContentMode.ScaleAspectFit
        iconView.backgroundColor = UIColor.clearColor()
        header.addSubview(iconView)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Return count of forecast
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath:indexPath) as? UITableViewCell
        if cell == nil { cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL") }
        
        cell!.selectionStyle = UITableViewCellSelectionStyle.None;
        cell!.backgroundColor = UIColor(white:0, alpha:0.2)
        cell!.textLabel!.textColor = UIColor.whiteColor()
        //cell!.detailTextLabel!.textColor = UIColor.whiteColor()
        
        // TODO: Setup the cell
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // TODO: Determine cell height based on screen
        // indexPath.section
        if (indexPath.row == 0) {
            return 264
        } else {
            return 44
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let bounds = self.view.bounds
        //self.backgroundImageView!.frame = bounds
        self.blurView!.frame = bounds
        self.tableView!.frame = bounds
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let height: CGFloat = scrollView.bounds.size.height
        let position: CGFloat = max(scrollView.contentOffset.y, 0.0)
        let percent: CGFloat = pow(min(position / height, 1.0), 3)
        self.blurView!.alpha = percent
    }
}
