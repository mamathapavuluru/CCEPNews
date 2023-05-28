//
//  NewsDetailVC.swift
//  CCEP


import UIKit
import Combine

class NewsDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var newsDetail: NewsData?
    var coordinator: AppCoordinator?
    var newsDetailViewModel: NewsDetailViewModel?
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareTableView()
        prepareViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    // Prepare the view model.
    private func prepareViewModel() {
        newsDetailViewModel = NewsDetailViewModel()
        if let coordinator {
            newsDetailViewModel?.coordinator = coordinator
        }
    }
    
    // Prepare the table view.
    private func prepareTableView() {
        tableView.dataSource = self
        NewsDetailViewCell.registerWithTable(tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }
}

// MARK: - UITableViewDatasource
extension NewsDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: NewsDetailViewCell.reuseIdentifier, for: indexPath) as? NewsDetailViewCell {
            cell.selectionStyle = .none
            if let newsDetail {
                let newsTableViewModel = NewsTableViewCellViewModel(newsDataModel: newsDetail)
                newsTableViewModel.cellSelected.sink { [weak self] index in
                    if let strUrl = self?.newsDetail?.readMoreUrl?.trimTrailingWhitespace() {
                        if let url = URL(string: strUrl) {
                            self?.newsDetailViewModel?.navigateToReadMoreNews(url: url)
                        }
                    }
                }.store(in: &subscriptions)
                cell.prepareCell(newsCellViewModel: newsTableViewModel)
                cell.readMoreButton.tag = indexPath.row
            }
            return cell
        }
        return UITableViewCell()
    }
}
