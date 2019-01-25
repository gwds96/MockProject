import Foundation

// MARK: - Struct Categories
struct MainCategory: Decodable, Encodable {
    let status: Int?
    let response: ResponseCategory
}

struct ResponseCategory: Decodable, Encodable {
    let categories: [Categories]
}

struct Categories: Decodable, Encodable {
    let id: Int?
    let name: String?
    let slug: String?
}
