import UIKit

class AccountVC: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    
    var screen: AccountPageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutButton.layer.borderWidth = 2
        logOutButton.layer.borderColor = UIColor.blue.cgColor
        logOutButton.layer.cornerRadius = 5
        logOutButton.clipsToBounds = true
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        self.screen?.moveToPage(0)
    }
    
}
