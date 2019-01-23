import Foundation

// MARK: - Struct Account
struct Account: Decodable {
    let status: Int?
    let response: ResponseAccount?
}

struct ResponseAccount: Decodable {
    let token: String
}
