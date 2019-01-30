import UIKit

protocol SendBackInfoDelegate: class {
    func emailAndPass(email: String, pass: String)
}

class RegisterVC: UIViewController {
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var noticeUserLbl: UILabel!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var noticeMailLbl: UILabel!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var noticePassLbl: UILabel!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var noticeRepassLbl: UILabel!
    @IBOutlet weak var repassTextField: UITextField!
    @IBOutlet weak var noticeLbl: UILabel!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    
    weak var sendBackInfoDelegate: SendBackInfoDelegate?
    
    let urlRegister = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/register")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterButton.layer.borderWidth = 2
        enterButton.layer.borderColor = UIColor.red.cgColor
        enterButton.layer.cornerRadius = 5
        enterButton.clipsToBounds = true
    }
    
    // MARK: animation for Text Field
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.userTextField.center.x += self.view.bounds.width
            self.mailTextField.center.x += self.view.bounds.width
            self.passTextField.center.x += self.view.bounds.width
            self.repassTextField.center.x += self.view.bounds.width
        }
    }
    
    // MARK: Check password validation
    func checkPasswordValidation(_ password: String) -> Bool {
        if password.count < 6 || password.count > 16 {
            return true
        }
        for i in password.utf8 {
            if (i >= 40 && i <= 57) || (i >= 65 && i <= 90) {
                return false
            }
        }
        return true
    }
    
    // MARK: Post Request Register
    func postRequestRegister() {
        let params = ["name": "\(String(userTextField.text!))", "email": "\(String(mailTextField.text!))", "password": "\(String(passTextField.text!))"]
        var request = URLRequest(url: urlRegister)
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
                        self.spinActivity.stopAnimating()
                        self.noticeLbl.text = "Register is failed, please try again!!"
                    } else {
                        self.spinActivity.stopAnimating()
                        self.noticeLbl.text = ""
                        self.sendBackInfoDelegate?.emailAndPass(email: self.mailTextField.text!, pass: self.passTextField.text!)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.noticeLbl.text = "Register is failed, please try again!!"
                }
            }
            }.resume()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func enterButton(_ sender: Any) {
        let checkNoticeEmpty = noticeUserLbl.text! + noticeMailLbl.text! + noticePassLbl.text!
            + noticeRepassLbl.text!
        let checkTextEmpty = userTextField.hasText && mailTextField.hasText && passTextField.hasText && repassTextField.hasText
        if checkNoticeEmpty == "" && checkTextEmpty && repassTextField.text == passTextField.text {
            spinActivity.startAnimating()
            postRequestRegister()
        }
    }
}

extension RegisterVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case userTextField:
            let userName: String = userTextField.text!
            if userName.isEmpty {
                noticeUserLbl.text = "please type user name!"
            }else {
                noticeUserLbl.text = ""
            }
        case mailTextField:
            let mail: String = mailTextField.text!
            if mail.contains("@") {
                noticeMailLbl.text = ""
            }else {
                noticeMailLbl.text = "email is incorrect!"
            }
        case passTextField:
            let password: String = passTextField.text!
            if checkPasswordValidation(password) {
                noticePassLbl.text = "please type valid password!"
            } else {
                noticePassLbl.text = ""
            }
        default:
            if repassTextField.text != passTextField.text {
                noticeRepassLbl.text = "please retype correct password!"
            }else {
                noticeRepassLbl.text = ""
            }
        }
    }
}
