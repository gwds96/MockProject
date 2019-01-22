import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var noticeUserLbl: UILabel!
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var noticeMailLbl: UILabel!
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var noticePassLbl: UILabel!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var noticeRepassLbl: UILabel!
    @IBOutlet weak var repassTF: UITextField!
    @IBOutlet weak var noticeLbl: UILabel!
    
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
            self.userTF.center.x += self.view.bounds.width
            self.mailTF.center.x += self.view.bounds.width
            self.passTF.center.x += self.view.bounds.width
            self.repassTF.center.x += self.view.bounds.width
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
        let params = ["name": "\(String(userTF.text!))", "email": "\(String(mailTF.text!))", "password": "\(String(passTF.text!))"]
        var request = URLRequest(url: urlRegister)
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: urlRegister) { (data, response, error) in
            if error == nil {
                let data = data
                do {
                    guard (try JSONDecoder().decode(Account?.self, from: data!)) != nil else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        self.noticeLbl.text = "Register is failed, please try again!!"
                    }
                }
            }
            }.resume()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func enterButton(_ sender: Any) {
        let checkNotice = noticeUserLbl.text! + noticeMailLbl.text! + noticePassLbl.text!
            + noticeRepassLbl.text!
        let checkField = !(userTF.text?.isEmpty)! && !(mailTF.text?.isEmpty)!
            && !(passTF.text?.isEmpty)! && !(repassTF.text?.isEmpty)!
        if checkNotice == "" && checkField && repassTF.text == passTF.text {
            postRequestRegister()
        }
    }
    
}

extension RegisterVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == userTF {
            let userName: String = userTF.text!
            if userName.isEmpty {
                noticeUserLbl.text = "please type user name!"
            }else {
                noticeUserLbl.text = ""
            }
        }
        
        if textField == mailTF {
            let mail: String = mailTF.text!
            if mail.contains("@") {
                noticeMailLbl.text = ""
            }else {
                noticeMailLbl.text = "email is incorrect!"
            }
        }
        
        if textField == passTF {
            let password: String = passTF.text!
            if checkPasswordValidation(password) {
                noticePassLbl.text = "please type valid password!"
            } else {
                noticePassLbl.text = ""
            }
        }
        
        if textField == repassTF {
            if repassTF.text != passTF.text {
                noticeRepassLbl.text = "please retype correct password!"
            }else {
                noticeRepassLbl.text = ""
            }
        }
    }
}
