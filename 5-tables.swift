import UIKit
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.makeKeyAndVisible()
        self.window!.rootViewController = AlphabetController(nibName: nil, bundle: nil)
        return true
    }
}
 
class AlphabetController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var tableView: UITableView?
    var data: Array<String>?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Alphabet"
        self.tableView = UITableView(frame: self.view.bounds)
        self.view.addSubview(self.tableView!)
        
        self.tableView!.dataSource = self
        self.tableView!.delegate = self
        
        self.data = map(UnicodeScalar("A").value...UnicodeScalar("Z").value, {(val: UInt32) -> String in return "\(UnicodeScalar(val))";})
 
        //self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")  FAILS FOR detailTextLabel
        self.tableView!.registerClass(MyCell.self, forCellReuseIdentifier: "CELL")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // FAILS FOR detailTextLabel:
        //var cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath:indexPath) as? UITableViewCell
        //if cell == nil { cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "CELL") }
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath:indexPath) as? MyCell
        if cell == nil { cell = MyCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "CELL") }
        
        //we know that cell is not empty now so we use ! to force unwrapping
        
        cell!.textLabel!.text = self.data![indexPath.row]
        cell!.detailTextLabel!.text = "1/2 cup"
        //cell.cellImage.image = UIImage(named: "0.jpg")
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let alert = UIAlertView()
        alert.message = "\(self.data![indexPath.row]) tapped!"
        alert.addButtonWithTitle("OK")
        alert.show()
    }
}
 
class MyCell: UITableViewCell {
    override init?(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
