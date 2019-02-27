import Foundation

    // MARK: - Refresh Token
    func refreshToken() {
        let keyChain = KeychainSwift()
        if keyChain.get("email") != nil && keyChain.get("password") != nil {
            let urlLogin = URL(string: urlMain + "login")!
            let params = ["email": "\(keyChain.get("email")! as String)", "password": "\(keyChain.get("password")! as String)"]
            var request = URLRequest(url: urlLogin)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
            request.httpBody = httpBody
            requestData(urlRequest: request) { (obj: Account) in
                if obj.status == 1 {
                    keyChain.delete("token")
                    keyChain.set((obj.response?.token)!, forKey: "token")
                }
            }
        }
    
}
