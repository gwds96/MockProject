import UIKit

class MyPageFatherVC: UIViewController {
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var wentButton: UIButton!
    @IBOutlet weak var willGoButton: UIButton!
    @IBOutlet weak var followedButton: UIButton!

    var colorLabel = UILabel()
    var conformClass: MyPagePageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorLabel.frame = CGRect(x: 0, y: accountButton.bounds.height + 20, width: view.bounds.width/4, height: 5)
        colorLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        view.addSubview(colorLabel)
        accountButton.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cellIdentifier = "MyPagePageView"
        if let vc = segue.destination as? MyPagePageView,
            segue.identifier == cellIdentifier {
            self.conformClass = vc
            vc.colorDelegate = self
        }
    }
    
    @IBAction func accountButton(_ sender: Any) {
        conformClass?.moveToPage(0)
    }
    
    @IBAction func wentButton(_ sender: Any) {
        conformClass?.moveToPage(1)
    }
    
    @IBAction func willGoButton(_ sender: Any) {
        conformClass?.moveToPage(2)
    }
    
    @IBAction func followedButton(_ sender: Any) {
        conformClass?.moveToPage(3)
    }
    
}

// MARK: - Color for Button
extension MyPageFatherVC: ColorForButtonDelegate {
    func chooseColor(_ index: Int) {
        let color0: UIColor = (index == 0) ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : .gray
        
        let color1: UIColor = (index == 1) ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : .gray
        
        let color2: UIColor = (index == 2) ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : .gray
        
        let color3: UIColor = (index == 3) ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : .gray
        
        UIView.animate(withDuration: 0.3) {
            self.accountButton.setTitleColor(color0, for: .normal)
            self.wentButton.setTitleColor(color1, for: .normal)
            self.willGoButton.setTitleColor(color2, for: .normal)
            self.followedButton.setTitleColor(color3, for: .normal)
            switch index {
            case 0:
                self.colorLabel.center.x = self.accountButton.bounds.width/2
            case 1:
                self.colorLabel.center.x = self.accountButton.bounds.width * 1.5
            case 2:
                self.colorLabel.center.x = self.accountButton.bounds.width * 2.5
            default:
                self.colorLabel.center.x = self.accountButton.bounds.width * 3.5
            }
        }
    }
    
}
