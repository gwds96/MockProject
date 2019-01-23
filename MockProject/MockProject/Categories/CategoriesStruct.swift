import Foundation

// MARK: - Struct Categories
struct MainCategory: Decodable {
    let status: Int?
    let response: ResponseCategory
}

struct ResponseCategory: Decodable {
    let categories: [Categories]
}

struct Categories: Decodable {
    let id: Int?
    let name: String?
    let slug: String?
}
