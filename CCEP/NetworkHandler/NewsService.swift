//
//  NewsService.swift
//  CCEP


import Foundation
import Combine

struct NewsService {
    func fetchNewsListFromApi(newsType: String) -> AnyPublisher<[NewsData], NetworkError> {
        let url = APPUrl.newsPath + newsType
        let newsResponsePublisher: AnyPublisher<NewsListModel, NetworkError> = NetworkHandler.sharedInstance.requestAPI(url: url)
        return newsResponsePublisher.map { $0.newsList ?? [] }
            .eraseToAnyPublisher()
    }
}
