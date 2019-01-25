import Foundation

// MARK: - Struct Event
struct MainEvent: Decodable, Encodable {
    let status: Int
    let response: ResponseEvent
}

struct MainEventDetail: Decodable, Encodable {
    let status: Int
    let response: ResponseEventDetail
}

struct ResponseEvent: Decodable, Encodable  {
    let events: [Events]
}

struct ResponseEventDetail: Decodable, Encodable  {
    let events: Events
}

struct Events: Decodable, Encodable {
    let id: Int
    let status: Int
    let link: String?
    let photo: String?
    let name: String?
    let description_raw: String?
    let description_html: String?
    let schedule_permanent: String?
    let schedule_date_warning: String?
    let schedule_time_alert: String?
    let schedule_start_date: String?
    let schedule_start_time: String?
    let schedule_end_date: String?
    let schedule_end_time: String?
    let schedule_one_day_event: Bool?
    let schedule_extra: String?
    let going_count: Int?
    let went_count: Int?
    let venue: Venue
    let category: Categories?
}

struct Venue: Decodable, Encodable {
    let id: Int?
    let name: String?
    let type: Int?
    let description: String?
    let contact_phone: String?
    let contact_address: String?
    let geo_area: String?
    let geo_long: String?
    let geo_lat: String?
    let schedule_openinghour: String?
    let schedule_closinghour: String?
    let schedule_closed: String?
}
