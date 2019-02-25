import Foundation

// MARK: - Struct Account
struct Account: Codable {
    let status: Int?
    let response: ResponseAccount?
    let error_message: String?
}

struct ResponseAccount: Codable {
    let token: String
}
