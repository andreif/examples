import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let b = UIScreen.mainScreen().bounds
        self.view.backgroundColor = UIColor.whiteColor()
        
        let i_p = get_image_view("photo-1", width: 2.4 * b.size.width, x: -70, y: 0)
        add_blur(i_p)
        self.view.addSubview(i_p)
        let scrollView = self.create_scroll_view()
        self.view.addSubview(scrollView)
        
        let contentView = UIView(frame: b)
        scrollView.addSubview(contentView)

        //let contentFrame = CGRectMake(10, 20, b.size.width - 20, b.size.height - 30)
        //contentView.backgroundColor = UIColor.whiteColor()
        //contentView.layer.cornerRadius = 10
        
        let t = UILabel(frame: CGRectMake(0, 50, b.size.width, 40))
        t.text = "My App"
        t.textAlignment = NSTextAlignment.Center
        t.font = UIFont(name: "MyFont", size: 40)
        t.textColor = UIColor.grayColor()
        t.textColor = UIColor(white: 1, alpha: 0.9)
        //add_shadow(t)
        contentView.addSubview(t)
        
        let f = CGRectMake(0, 250, b.size.width-0, 440)

        let w = UIView(frame: f)
        w.backgroundColor = UIColor.whiteColor()
        w.alpha = 0.8
        //contentView.addSubview(w)
        
        let s = UIView(frame: f)
        add_blur(s)
        s.alpha = 0.9
        s.layer.masksToBounds = false
        //contentView.addSubview(s)
        
        
        let x = UITextView(frame: f)
        //x.layer.cornerRadius = 10
        x.backgroundColor = UIColor(white: 1, alpha: 0)
        //add_shadow(x)
        contentView.addSubview(x)
        
        
        /*
        let iv = get_image_view("logo", width: 0.6 * b.size.width)
        align_center(iv, parent: contentView, y: 160)
        add_shadow(iv)
        contentView.addSubview(iv)

        let i_m = get_image_view("icon-1", width: 0.6 * b.size.width)
        align_center(i_m, parent: contentView)
        contentView.addSubview(i_m)
        */

        //add_blur(contentView)
    }
    
    func create_scroll_view() -> UIScrollView {
        let b = UIScreen.mainScreen().bounds
        let scrollView = UIScrollView(frame: b)
        scrollView.contentSize = CGSizeMake(b.size.width, b.size.height + 1)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }
    
    func add_shadow(view: UIView) {
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowOpacity = 0.5
        view.layer.masksToBounds = false
    }
    
    func add_blur(view: UIView) {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.contentMode = UIViewContentMode.ScaleAspectFill
        blurView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.addSubview(blurView)
    }
    
    func align_center(child: UIView, parent: UIView, x: CGFloat? = nil, y: CGFloat? = nil, dx: CGFloat? = nil, dy: CGFloat? = nil) {
        let p = parent.frame.size
        let c = child.frame.size
        var cx = x
        var cy = y
        if cx == nil {
            cx = (p.width - c.width) / 2
            if dx != nil {
                cx = cx! + dx!
            }
        }
        if cy == nil {
            cy = (p.height - c.height) / 2
            if dy != nil {
                cy = cy! + dy!
            }
        }
        child.frame.origin.x = cx!
        child.frame.origin.y = cy!
    }
    
    func get_image_view(named: String, x: CGFloat = 0, y: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) -> UIImageView {
        let i = UIImage(named: named)
        let s = i!.size
        var w = width
        var h = height
        if w != nil {
            h = s.height / s.width * w!
        } else if h != nil {
            w = s.width / s.height * h!
        } else {
            h = s.height
            w = s.width
        }
        let iv = UIImageView(image: i)
        iv.frame = CGRectMake(x, y, w!, h!)
        return iv
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
