import Foundation

// MARK: - Struct Account
struct Account: Codable {
    let status: Int?
    let response: ResponseAccount?
}

struct ResponseAccount: Codable {
    let token: String
}
