// http://code.tutsplus.com/tutorials/adding-blur-effects-on-ios--cms-21488
import UIKit

class BlurController: UIViewController, UIScrollViewDelegate { // UITableViewDataSource, UITableViewDelegate
    // http://www.raywenderlich.com/55384/ios-7-best-practices-part-1
    var backgroundImageView: UIImageView?
    var blurredImageView: UIImageView?
    var tableView: UITableView?
    var screenHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenHeight = UIScreen.mainScreen().bounds.size.height

        /*
        let background = UIImage(named: "page1")
        self.backgroundImageView = UIImageView(image: background)
        self.backgroundImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(self.backgroundImageView!)
        
        self.blurredImageView = BlurImageView(frame: self.view.frame)
        self.blurredImageView!.image = background
        self.blurredImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.blurredImageView!.alpha = 0
        // background.applyBlur(radius:30 tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil]
        // self.blurredImageView!.setImageToBlur(background, blurRadius:10, completionBlock:nil)
        self.view.addSubview(self.blurredImageView!)
        */
        
        //self.view.backgroundColor = UIColor.redColor()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func loadView() {
        self.view.addSubview(self.createContentView());
        self.view.addSubview(self.createHeaderView());
        self.view.addSubview(self.createScrollView());
    }
    
    func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 60))
        headerView.backgroundColor = UIColor(red:229/255.0, green:39/255.0, blue:34/255.0, alpha:0.6)
        let title = UILabel(frame:CGRectMake(0, 20, self.view.frame.size.width, 40))
        title.text = "Dynamic Blur Demo"
        headerView.addSubview(title)
        return headerView
    }
    
    var contentView: UIView?
    
    func createContentView() -> UIView {
        self.contentView = UIView(frame:self.view.frame)
        // Background image
        let contentImage = UIImageView(frame:self.contentView!.frame)
        contentImage.image = UIImage(named:"page1")
        self.contentView!.addSubview(contentImage)
    
        let creditsViewContainer = UIView(frame:CGRectMake(self.view.frame.size.width/2 - 65, 335, 130, 130))
        creditsViewContainer.backgroundColor = UIColor.whiteColor()
        creditsViewContainer.layer.cornerRadius = 65
        self.contentView!.addSubview(creditsViewContainer)
    
        let photoTitle = UILabel(frame:CGRectMake(0, 54, 130, 18))
        photoTitle.text = "Peach Garden"
        creditsViewContainer.addSubview(photoTitle)

        let photographer = UILabel(frame:CGRectMake(0, 72, 130, 9))
        photographer.text = "by Cas Cornelissen"
        creditsViewContainer.addSubview(photographer)

        return self.contentView!
    }
    
    func createScrollView() -> UIView {
        let containerView = UIView(frame:self.view.frame)
    
        let blurredBgImage = UIImageView(frame:CGRectMake(0, 0, self.view.frame.size.width, 568))
        blurredBgImage.contentMode = UIViewContentMode.ScaleToFill
        containerView.addSubview(blurredBgImage)
    
        let scrollView = UIScrollView(frame:self.view.frame)
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2 - 110)
        scrollView.pagingEnabled = true
        containerView.addSubview(scrollView)
        
        let slideContentView = UIView(frame:CGRectMake(0, 518, self.view.frame.size.width, 508))
        slideContentView.backgroundColor = UIColor.clearColor()
        scrollView.addSubview(slideContentView)
        
        let slideUpLabel = UILabel(frame:CGRectMake(0, 6, self.view.frame.size.width, 50))
        slideUpLabel.text = "Photo information"
        slideContentView.addSubview(slideUpLabel)
        
        let slideUpImage = UIImageView(frame:CGRectMake(self.view.frame.size.width/2 - 12, 4, 24, 22.5))
        slideUpImage.image = UIImage(named: "up-arrow.png")
        slideContentView.addSubview(slideUpImage)
        
        let detailsText = UITextView(frame:CGRectMake(25, 100, 270, 350))
        detailsText.text = "Lorem ipsum ... laborum"
        slideContentView.addSubview(detailsText)
        
        return containerView
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

