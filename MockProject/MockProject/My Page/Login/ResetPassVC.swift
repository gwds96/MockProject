import UIKit

class ResetPassVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    
    let urlReset = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/resetPassword")!
    
    func ResetPassword() {
        let params = ["email": "\(emailTextField.text ?? "")"]
        var request = URLRequest(url: urlReset)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
        requestData(urlRequest: request) { (obj: Account) in
            DispatchQueue.main.async {
                if obj.status == 0 {
                    self.spinActivity.stopAnimating()
                    self.noticeLabel.text = "Reset password is failed, please try again!!"
                    self.noticeLabel.textColor = UIColor.red
                } else {
                    self.spinActivity.stopAnimating()
                    self.noticeLabel.text = "New password has sent to your Email, please check it"
                    self.noticeLabel.textColor = UIColor.blue
                }
            }
        }
    }
    
    // MARK: - Click enter to reset password
    @IBAction func enterButton(_ sender: Any) {
        spinActivity.startAnimating()
        ResetPassword()
    }
    
    // MARK: - Click to back to Log in screen
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
