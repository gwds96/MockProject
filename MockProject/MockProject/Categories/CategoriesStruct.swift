import Foundation

// MARK: - Struct Categories
struct MainCategory: Codable {
    let status: Int?
    let response: ResponseCategory
}

struct ResponseCategory: Codable {
    let categories: [Categories]
}

struct Categories: Codable {
    let id: Int?
    let name: String?
    let slug: String?
}
