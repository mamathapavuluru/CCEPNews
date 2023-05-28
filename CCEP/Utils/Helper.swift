//
//  Helper.swift
//  CCEP


import Foundation

final class Helper: NSObject {
    static let sharedInstance = Helper()
    
    private override init() { }
    
    func stringtoDateConvertion(with strDate: String, givenType: String, expectedType: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = givenType
        guard let oldDate = dateFormatter.date(from:strDate) else {
            return ""
        }
        dateFormatter.dateFormat = expectedType
        return dateFormatter.string(from: oldDate)
    }

    //Converting date from Response to Standard Date format
    func getDateFromString(date: String?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy,EEEE"
        dateFormatter.timeZone = TimeZone.current
        let convertedDate = dateFormatter.date(from: date ?? "")
        return convertedDate
    }
    
    //Converting Time from Response to Standard Date format
    func getTimeFromString(time: String?) -> Date? {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        timeFormatter.timeZone = TimeZone.current
        let convertedTime = timeFormatter.date(from: time ?? "")
        return convertedTime
    }

}
