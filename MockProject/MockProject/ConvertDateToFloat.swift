import Foundation

// MARK: - Convert date to double type
func convertDateToDouble(_ dateString: String) -> Double {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale.current
    let date = dateFormatter.date(from:dateString)!
    let timeInterval = date.timeIntervalSince1970
    return Double(timeInterval)
}
