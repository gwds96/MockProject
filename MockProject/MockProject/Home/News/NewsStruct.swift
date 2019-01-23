import Foundation

// MARK: - Struct News
struct MainNews: Codable, Equatable {
    let status: Int?
    let response: ResponseNews
}

struct ResponseNews: Codable, Equatable {
    let news: [News]
}

struct News: Codable, Equatable {
    let id: Int?
    let feed: String?
    let title: String?
    let thumb_img: String?
    let detail_url: String?
    let description: String?
    let author: String?
    let publish_date: String?
    let created_at: String?
    let updated_at: String?
}
