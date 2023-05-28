//
//  AppCoordinator.swift
//  CombineWithCoordinator


import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    let window: UIWindow
    let storyBoard = UIStoryboard(name: Constants.StoryboardIdentifiers.main.rawValue, bundle: .main)

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }

    // Start the Root of the application
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        initiateNewsListViewController()
    }
    
    // Push to our Intial NewsListViewController
    fileprivate func initiateNewsListViewController() {
        if let newListViewController = storyBoard.instantiateViewController(withIdentifier: Constants.ViewControllersIdentifiers.newsListViewController.rawValue) as? NewsListViewController {
            newListViewController.coordinator = self
            navigationController.pushViewController(newListViewController, animated: true)
        }
    }
    
    // Push to News Detail View Controller
    func pushToNewsDetailsViewController(newsDetail: NewsData) {
        if let newsDetailViewController = storyBoard.instantiateViewController(withIdentifier: Constants.ViewControllersIdentifiers.newsDetailViewController.rawValue) as? NewsDetailViewController {
            newsDetailViewController.coordinator = self
            newsDetailViewController.newsDetail = newsDetail
            navigationController.pushViewController(newsDetailViewController, animated: true)
        }
    }
    
    // Push to Web View Controller
    func pushToReadMoreViewController(webUrl: URL) {
        if let readMoreNewsViewController = storyBoard.instantiateViewController(withIdentifier:
                                                                            Constants.ViewControllersIdentifiers.readMoreNewsViewController.rawValue) as? ReadMoreNewsViewController {
            readMoreNewsViewController.coordinator = self
            readMoreNewsViewController.weUrl = webUrl
            navigationController.pushViewController(readMoreNewsViewController, animated: true)
        }
    }
}
