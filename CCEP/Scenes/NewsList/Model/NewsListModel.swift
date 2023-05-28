//
//  NewsListModel.swift
//  CCEP


import Foundation
// MARK: - Api Response based on Category
struct NewsListModel : Codable {
    var categoryName : String?
    var newsList : [NewsData]?
    var success : Bool?

    enum CodingKeys: String, CodingKey {
        case categoryName = "category"
        case newsList = "data"
        case success = "success"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName)
        newsList = try values.decodeIfPresent([NewsData].self, forKey: .newsList)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
    }
}

// MARK: - Api Response for NEWS
struct NewsData : Codable {
    var author : String?
    var content : String?
    var date : String?
    var id : String?
    var imageUrl : String?
    var readMoreUrl : String?
    var time : String?
    var title : String?
    var url : String?

    enum CodingKeys: String, CodingKey {

        case author = "author"
        case content = "content"
        case date = "date"
        case id = "id"
        case imageUrl = "imageUrl"
        case readMoreUrl = "readMoreUrl"
        case time = "time"
        case title = "title"
        case url = "url"
    }
    
    init() {
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        author = try values.decodeIfPresent(String.self, forKey: .author)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        readMoreUrl = try values.decodeIfPresent(String.self, forKey: .readMoreUrl)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}

extension NewsData: Hashable {
    static func == (lhs: NewsData, rhs: NewsData) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
