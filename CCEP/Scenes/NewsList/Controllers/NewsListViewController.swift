//
//  NewsListViewController.swift
//  CCEP


import UIKit
import Combine

class NewsListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableViewNews: UITableView!
    
    // MARK: - Properties
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel: NewsListViewModel?
    private var loadDataSubject = PassthroughSubject<Void,Never>()
    
    // Flag to safeguard an one time refresh of screen in case of location update.
    var isRefreshInProgress = false
    var coordinator: AppCoordinator?
    
    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareViewModel()
        prepareTableView()
        setupBindings()
        refreshScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Constants.ScreenTitles.latestNews.rawValue
    }
    
    // Prepare the view model.
    func prepareViewModel() {
        viewModel = NewsListViewModel()
        if let coordinator {
            viewModel?.coordinator =  coordinator
        }
    }
    
    // Prepare the table view.
    private func prepareTableView() {
        tableViewNews.dataSource = self
        tableViewNews.delegate = self
        NewsTableViewCell.registerWithTable(tableViewNews)
        tableViewNews.rowHeight = UITableView.automaticDimension
        tableViewNews.estimatedRowHeight = 100
    }
    
    // Function to observe various event call backs from the viewmodel as well as Notifications.
    private func setupBindings() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.attachViewEventListener(loadData: loadDataSubject.eraseToAnyPublisher())
        viewModel.reloadNewsList
            .sink(receiveCompletion: { [weak self] error in
                self?.showAlert(withTitle: "Error", withMessage: "\(error)")
            }) { [weak self] response in
                ActivityIndicator.sharedIndicator.hideActivityIndicator()
                switch response {
                case .failure(let error):
                    self?.showAlert(withTitle: "Error", withMessage: "\(error)")
                case .success():
                    self?.tableViewNews.reloadData()
                }
            }
            .store(in: &subscriptions)
        
        viewModel.newsChoosed.sink { news in
            viewModel.navigateToNewsDetailViewController(with: news)
        }
        .store(in: &subscriptions)
    }
    
    // Refresh the screen when refresh button is pressed.
    private func refreshScreen() {
        isRefreshInProgress = true
        ActivityIndicator.sharedIndicator.displayActivityIndicator(onView: self.view)
        loadDataSubject.send()
    }
    
    // Provides a news cell.
    private func cellForNewsTableViewCell(indexPath: IndexPath, viewModel: NewsTableViewCellViewModel) -> NewsTableViewCell {
        if let cell = tableViewNews.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier, for: indexPath) as? NewsTableViewCell {
            cell.selectionStyle = .none
            cell.prepareCell(newsCellViewModel: viewModel)
            return cell
        }
        return NewsTableViewCell()
    }
    
    // Select a news cell.
    private func didSelectRow(indexPath: IndexPath, viewModel: NewsTableViewCellViewModel) {
        if let cell = tableViewNews.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier, for: indexPath) as? NewsTableViewCell {
            cell.didSelectCell(index: indexPath, newsCellViewModel: viewModel)
        }
    }
}

// MARK: - UITableViewDatasource
extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        let cellType = viewModel.cellType(forIndex: indexPath)
        switch cellType {
        case .newsListCell(model: let model):
            return cellForNewsTableViewCell(indexPath: indexPath, viewModel: model)
        }
    }
}

// MARK: - UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        let cellType = viewModel.cellType(forIndex: indexPath)
        switch cellType {
        case .newsListCell(model: let model):
            didSelectRow(indexPath: indexPath, viewModel: model)
        }
    }
}
