import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let b = UIScreen.mainScreen().bounds
        self.view.backgroundColor = UIColor.grayColor()
        
        let scrollView = UIScrollView(frame: b)
        scrollView.contentSize = CGSizeMake(b.size.width, b.size.height + 1)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        let contentFrame = CGRectMake(10, 20, b.size.width - 20, b.size.height - 30)
        let contentView = UIView(frame: contentFrame)
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.layer.cornerRadius = 10
        scrollView.addSubview(contentView)
        
        let t = UILabel(frame: CGRectMake(0, 200, contentFrame.size.width, 40))
        t.text = "My App"
        t.textAlignment = NSTextAlignment.Center
        t.font = UIFont(name: "MyFont", size: 40)
        t.textColor = UIColor.grayColor()
        contentView.addSubview(t)
        
        let iv = get_image_view("logo", width: 0.6 * contentFrame.size.width)
        align_center(iv, parent: contentView, y: 30)
        contentView.addSubview(iv)
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
}
