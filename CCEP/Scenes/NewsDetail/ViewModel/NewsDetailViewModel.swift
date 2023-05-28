//
//  NewsDetailViewModel.swift
//  CCEP


import Foundation

class NewsDetailViewModel {
    var coordinator: AppCoordinator?
    
    init() { }

    //Open WebView to read more
    func navigateToReadMoreNews(url: URL) {
        if let coordinator {
            coordinator.pushToReadMoreViewController(webUrl: url)
        }
    }
}
