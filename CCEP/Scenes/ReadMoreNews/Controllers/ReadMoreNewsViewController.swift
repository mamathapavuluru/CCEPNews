//
//  WebViewController.swift
//  CCEP


import UIKit
import WebKit

class ReadMoreNewsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Properties
    var coordinator: AppCoordinator?
    var weUrl: URL?
    
    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showWebView()
    }
    
    // Show the web kit view
    private func showWebView() {
        if let url = self.weUrl {
            self.webView.load(URLRequest(url: url))
        }
    }
}
