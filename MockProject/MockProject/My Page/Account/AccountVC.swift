import UIKit

class AccountVC: UIViewController {
    
    let keyChain = KeychainSwift()

    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutButton.layer.borderWidth = 5
        logOutButton.layer.borderColor = UIColor.blue.cgColor
        logOutButton.layer.cornerRadius = 5
        logOutButton.clipsToBounds = true
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        keyChain.delete("token")
        MainTabBar.instance.updateStateTabbar()
    }
    
}
