import Foundation

let keyChain = KeychainSwift()

// MARK: - Refresh Token
func refreshToken() {
    let urlLogin = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/login")!
    let params = ["email": "\(String(describing: keyChain.get("email")))", "password": "\(String(describing: keyChain.get("password")))"]
    var request = URLRequest(url: urlLogin)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
    request.httpBody = httpBody
    requestData(urlRequest: request) { (obj: Account) in
        if obj.status == 1 {
            keyChain.set((obj.response?.token)!, forKey: "token")
        }
    }
}
