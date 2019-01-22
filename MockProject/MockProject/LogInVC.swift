import UIKit

class LogInVC: UIViewController {
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var noticeLbl: UILabel!
    
    let urlLogin = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/login")!
    var accessToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterButton.layer.borderWidth = 2
        enterButton.layer.borderColor = UIColor.red.cgColor
        enterButton.layer.cornerRadius = 5
        enterButton.clipsToBounds = true
        userTF.center.x -= view.bounds.width
        passTF.center.x -= view.bounds.width
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.userTF.center.x += self.view.bounds.width
            self.passTF.center.x += self.view.bounds.width
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        userTF.center.x -= view.bounds.width
        passTF.center.x -= view.bounds.width
    }
    
    // MARK: Post request Login
    func postRequestLogin() {
        let params = ["email": "\(String(userTF.text!))", "password": "\(String(passTF.text!))"]
        var request = URLRequest(url: urlLogin)
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: urlLogin) { (data, response, error) in
            if error == nil {
                let data = data
                do {
                    guard let obj = try JSONDecoder().decode(Account?.self, from: data!) else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.accessToken = obj.response!.token ?? ""
                        let certifier = "AccountVC"
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! AccountVC
                        self.present(vc, animated: true, completion: nil)
                        }
                }
                catch {
                    DispatchQueue.main.async {
                        self.noticeLbl.text = "Login is failed, please try again!!"
                    }
                }
            }
            }.resume()
    }
    
    @IBAction func enterButton(_ sender: Any) {
        postRequestLogin()
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let cellIdentifier = "RegisterVC"
        let vc = UIStoryboard(name: "Main", bundle: nil)
        let screen = vc.instantiateViewController(
            withIdentifier: cellIdentifier) as! RegisterVC
        self.present(screen, animated: true, completion: nil)
    }
    
}
