import UIKit

class LogInVC: UIViewController {
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var noticeLbl: UILabel!
    
    let keyChain = KeychainSwift()
    
    let urlLogin = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/login")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // MARK: Post request Login
    func postRequestLogin() {
        keyChain.set(passTextField.text!, forKey: "password")
        let params = ["email": "\(emailTextField.text ?? "")", "password": "\(keyChain.get("password") ?? "")"]
        var request = URLRequest(url: urlLogin)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                error == nil else { return }
            do {
                let obj = try JSONDecoder().decode(Account.self, from: data)
                DispatchQueue.main.async {
                    if obj.status == 0 {
                        self.noticeLbl.text = "Login is failed, please try again!!"
                    } else {
                        self.noticeLbl.text = ""
                        self.keyChain.set((obj.response?.token)!, forKey: "token")
                        MainTabBar.instance.updateStateTabbar()
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.noticeLbl.text = "Opp! Somethings is wrong!!"
                    print(error.localizedDescription)
                }
            }
            }.resume()
    }
    
    @IBAction func enterButton(_ sender: Any) {
        postRequestLogin()
    }
    
    // MARK: Sign up Button
    @IBAction func signUpButton(_ sender: Any) {
        let cellIdentifier = "RegisterVC"
        let vc = UIStoryboard(name: "Main", bundle: nil)
        let screen = vc.instantiateViewController(
            withIdentifier: cellIdentifier) as! RegisterVC
        screen.sendBackInfoDelegate = self
        self.present(screen, animated: true, completion: nil)
    }
    
}

extension LogInVC: SendBackInfoDelegate {
    func emailAndPass(email: String, pass: String) {
        emailTextField.text = email
        passTextField.text = pass
    }
}
