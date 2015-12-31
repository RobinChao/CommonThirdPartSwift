 
//  ✨ Super sweet syntactic sugar for Swift initializers.
 
 
 /*    Example:
 
 final class MyViewController: UIViewController {
 
 let titleLabel = UILabel().then {
        $0.textColor = .blackColor()
        $0.textAlignment = .Center
 }
 
 let tableView = UITableView().then {
        $0.backgroundColor = .clearColor()
        $0.separatorStyle = .None
        $0.registerClass(MyCell.self, forCellReuseIdentifier: "myCell")
 }
 
 override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.tableView)
 }
 
 }
 
 */
 
 
 public protocol Then {}
 
 extension Then {
    
    public func then (@noescape block: Self -> Void) -> Self {
        block(self)
        return self
    }
    
 }
 
 extension NSObject: Then {}