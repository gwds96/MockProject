import Foundation

// MARK: - Struct Account
struct Account: Decodable, Encodable {
    let status: Int?
    let response: ResponseAccount?
}

struct ResponseAccount: Decodable, Encodable {
    let token: String
}
