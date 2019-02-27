import UIKit

class AccountVC: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    
    let keyChain = KeychainSwift()
    var colorBool = false
    var timer: Timer!

    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutButton.layer.borderWidth = 5
        logOutButton.layer.borderColor = UIColor.blue.cgColor
        logOutButton.layer.cornerRadius = 5
        logOutButton.clipsToBounds = true
        
        emailLabel.text = keyChain.get("email")
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(changeColor), userInfo: nil, repeats: true)
        self.changeColor()
    }
    
    @objc func changeColor() {
        let colors:[Bool: UIColor] = [true: UIColor.darkGray, false: UIColor.red]
        colorBool.toggle()
        emailLabel.textColor = colors[colorBool]
        
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        keyChain.delete("token")
        keyChain.delete("email")
        keyChain.delete("password")
        MainTabBar.instance.updateStateTabbar()
    }
    
}
