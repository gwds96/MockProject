import UIKit

class MyPageFatherVC: UIViewController {
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var wentButton: UIButton!
    @IBOutlet weak var willGoButton: UIButton!
    @IBOutlet weak var followedButton: UIButton!

    var conformClass: MyPagePageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountButton.tintColor = UIColor.blue
        accountButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
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
        let color0: UIColor = (index == 0) ? .blue : .black
        let backgroundColor0: UIColor = (index == 0) ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : .white
        accountButton.setTitleColor(color0, for: .normal)
        accountButton.backgroundColor = backgroundColor0
        let color1: UIColor = (index == 1) ? .blue : .black
        let backgroundColor1: UIColor = (index == 1) ? #colorLiteral(red: 0.7151083021, green: 0.9036072062, blue: 1, alpha: 0.5) : .white
        wentButton.setTitleColor(color1, for: .normal)
        wentButton.backgroundColor = backgroundColor1
        let color2: UIColor = (index == 2) ? .blue : .black
        let backgroundColor2: UIColor = (index == 2) ? #colorLiteral(red: 0.7151083021, green: 0.9036072062, blue: 1, alpha: 0.5) : .white
        willGoButton.setTitleColor(color2, for: .normal)
        willGoButton.backgroundColor = backgroundColor2
        let color3: UIColor = (index == 3) ? .blue : .black
        let backgroundColor3: UIColor = (index == 3) ? #colorLiteral(red: 0.7151083021, green: 0.9036072062, blue: 1, alpha: 0.5) : .white
        followedButton.setTitleColor(color3, for: .normal)
        followedButton.backgroundColor = backgroundColor3
    }
    
}
