import UIKit

class AccountVC: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.layer.borderWidth = 2
        logoutButton.layer.borderColor = UIColor.blue.cgColor
        logoutButton.layer.cornerRadius = 5
        logoutButton.clipsToBounds = true
    }
}
