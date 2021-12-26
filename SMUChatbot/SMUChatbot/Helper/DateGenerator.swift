import Foundation

class DateGenerator {
    static func nowDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let dateString = dateFormatter.string(from: Date())
        
        return dateString
    }
}
