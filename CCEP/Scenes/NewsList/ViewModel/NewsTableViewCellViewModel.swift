//
//  NewsTableViewCellViewModel.swift
//  CCEP


import Foundation
import UIKit
import Combine

protocol TableCellRepresentable {
    // Output
    var cellSelected: AnyPublisher<IndexPath, Never> { get }
    //Input
    func cellSelected(indexPath: IndexPath)
 }

struct NewsTableViewCellModel {
    var title: String
    var image: UIImage?
    var content: String?
    var date: String?
}

class NewsTableViewCellViewModel: TableCellRepresentable {
    
    // Output
    @Published private(set) var title: String?
    @Published private(set) var image: String?
    @Published private(set) var content: String?
    @Published private(set) var author: String?
    @Published private(set) var date: String?
    @Published private(set) var webUrl: URL?

    // Events
    var cellSelected: AnyPublisher<IndexPath, Never> {
        newsSelectedSubject.eraseToAnyPublisher()
    }
    private var dataModel: NewsData
    private let newsSelectedSubject = PassthroughSubject<IndexPath, Never>()
    
    init(newsDataModel: NewsData) {
        self.dataModel = newsDataModel
        configureOutput()
    }
    
    private func configureOutput() {
        title = dataModel.title ?? ""
        content = dataModel.content ?? ""
        title = dataModel.title ?? ""
        image = dataModel.imageUrl ?? ""
        author = getAuthorName()
        if let url = URL(string: dataModel.readMoreUrl?.trimTrailingWhitespace() ?? "") {
            webUrl = url
        }
        let dateSring = (dataModel.date ?? "") + (dataModel.time ?? "")
        date = Helper.sharedInstance.stringtoDateConvertion(with: dateSring, givenType: "dd MMM yyyy,EEEEh:mm a", expectedType: "MMM dd yyyy, h:mm a")
    }

    private func getAuthorName() -> String {
        if let authorName = dataModel.author {
            return "By \(authorName)"
        }
        return ""
    }
    
    func cellSelected(indexPath: IndexPath) {
        newsSelectedSubject.send(indexPath)
    }
}
