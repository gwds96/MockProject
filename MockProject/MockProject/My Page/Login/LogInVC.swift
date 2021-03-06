import UIKit

class LogInVC: UIViewController {
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var noticeLbl: UILabel!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    
    let keyChain = KeychainSwift()
    
    let urlLogin = URL(string: urlMain + "login")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        // MARK: - Animation for buttons and textfields
        enterButton.layer.borderWidth = 2
        enterButton.layer.borderColor = UIColor.red.cgColor
        enterButton.layer.cornerRadius = 5
        enterButton.clipsToBounds = true
        emailTextField.center.x -= view.bounds.width
        passTextField.center.x -= view.bounds.width
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.emailTextField.center.x += self.view.bounds.width
            self.passTextField.center.x += self.view.bounds.width
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        emailTextField.center.x -= view.bounds.width
        passTextField.center.x -= view.bounds.width
    }
    
    // MARK: - Post request Login
    func postRequestLogin() {
        keyChain.set(emailTextField.text!, forKey: "email")
        keyChain.set(passTextField.text!, forKey: "password")
        let params = ["email": "\(emailTextField.text ?? "")", "password": "\(keyChain.get("password") ?? "")"]
        var request = URLRequest(url: urlLogin)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
        requestData(urlRequest: request) { (obj: Account) in
            if obj.status == 0 {
                DispatchQueue.main.async {
                    self.spinActivity.stopAnimating()
                    self.noticeLbl.text = "Login is failed, please try again!!"
                }
            } else {
                self.keyChain.set((obj.response?.token)!, forKey: "token")
                DispatchQueue.main.async {
                    self.spinActivity.stopAnimating()
                    MainTabBar.instance.updateStateTabbar()
                }
            }
        }
    }
    
    // MARK: - Click sign in
    @IBAction func enterButton(_ sender: Any) {
        view.endEditing(true)
        noticeLbl.text = ""
        spinActivity.startAnimating()
        postRequestLogin()
    }
    
    // MARK: - Click sign up
    @IBAction func signUpButton(_ sender: Any) {
        view.endEditing(true)
        let cellIdentifier = "RegisterVC"
        let vc = UIStoryboard(name: "Main", bundle: nil)
        let screen = vc.instantiateViewController(
            withIdentifier: cellIdentifier) as! RegisterVC
        screen.sendBackInfoDelegate = self
        self.present(screen, animated: true, completion: nil)
    }
    
    // MARK: - Click reset password
    @IBAction func resetPassButton(_ sender: Any) {
        view.endEditing(true)
        let cellIdentifier = "ResetPassVC"
        let vc = UIStoryboard(name: "Main", bundle: nil)
        let screen = vc.instantiateViewController(
            withIdentifier: cellIdentifier) as! ResetPassVC
        self.present(screen, animated: true, completion: nil)
    }
    
}

// MARK: - Auto fill email and password after register
extension LogInVC: SendBackInfoDelegate {
    func emailAndPass(email: String, pass: String) {
        emailTextField.text = email
        passTextField.text = pass
    }
}
