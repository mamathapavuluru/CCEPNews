//
//  NewsListViewModel.swift
//  CCEP


import Foundation
import Combine

/// Enum for different  cell type
enum HomeTableCellType {
    case newsListCell(model: NewsTableViewCellViewModel)
}

protocol TableRepresentableProtocal {
    //Input
    func cellSelected(indexPath: IndexPath)
 }

class NewsListViewModel {
    private var subscriptions = Set<AnyCancellable>()
    
    /// Data source for the home page table view.
    private var tableDataSource: [HomeTableCellType] = [HomeTableCellType]()
    private var newsList = [NewsData]()
    
    // MARK: Input
    private var loadData: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher()
    
    var coordinator: AppCoordinator?
    
    // MARK: Output
    var numberOfRows: Int {
        tableDataSource.count
    }
    var newsChoosed: AnyPublisher<NewsData, Never> {
        newsChoosedSubject.eraseToAnyPublisher()
    }
    var reloadNewsList: AnyPublisher<Result<Void, NetworkError>, Never> {
        reloadNewsListSubject.eraseToAnyPublisher()
    }
    private let newsChoosedSubject = PassthroughSubject<NewsData, Never>()
    private let reloadNewsListSubject = PassthroughSubject<Result<Void, NetworkError>, Never>()
    
    init() { }
    
    func attachViewEventListener(loadData: AnyPublisher<Void, Never>) {
        self.loadData = loadData
        self.loadData
            .setFailureType(to: NetworkError.self)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.newsList.removeAll()
            })
            .flatMap { _ -> AnyPublisher<[NewsData], NetworkError> in
                let newsWebService = NewsService()
                return newsWebService
                    .fetchNewsListFromApi(newsType: NewsCategoryType.all.rawValue)
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.tableDataSource.removeAll()
            })
            .sink(receiveCompletion: { [weak self] value in
                if case let .failure(error) = value {
                    self?.reloadNewsListSubject.send(.failure((error)))
                }
            },
              receiveValue: { [weak self] news in
                if news.isEmpty {
                    self?.reloadNewsListSubject.send(.failure((NetworkError.emptyResponse)))
                } else {
                    self?.newsList.append(contentsOf: self?.applySortingOnNewsData(with: news) ?? news)
                    self?.prepareTableDataSource()
                    self?.reloadNewsListSubject.send(.success(()))
                }
            })
            .store(in: &subscriptions)
    }
    
    /// Prepare the Table Data Source
    private func prepareTableDataSource() {
        tableDataSource.append(contentsOf: cellTypeForNews())
    }
    
    /// Provides a NewsCell type.
    private func cellTypeForNews() -> [HomeTableCellType] {
        var cellTypes = [HomeTableCellType]()
        for news in self.newsList {
            let newsTableViewCellViewModel = NewsTableViewCellViewModel(newsDataModel: news)
            newsTableViewCellViewModel.cellSelected.sink { [weak self] indexPath in
                self?.newsChoosedSubject.send(self?.newsList[indexPath.row] ?? NewsData())
            }
            .store(in: &subscriptions)
            cellTypes.append(HomeTableCellType.newsListCell(model: newsTableViewCellViewModel))
        }
        return cellTypes
    }
    
    /// Provides the view with appropriate cell type corresponding to an index.
    func cellType(forIndex indexPath: IndexPath) -> HomeTableCellType {
        tableDataSource[indexPath.row]
    }
}

// MARK: Sorting
extension NewsListViewModel {
    func applySortingOnNewsData(with unSortedList: [NewsData]) -> [NewsData]{
        let finalSortedList = unSortedList.sorted { (lhs, rhs) in
            if let lhsDate = Helper.sharedInstance.getDateFromString(date: lhs.date), let rhsDate = Helper.sharedInstance.getDateFromString(date: rhs.date) {
                if lhsDate == rhsDate {
                    if let lhsTime = Helper.sharedInstance.getTimeFromString(time: lhs.time), let rhsTime = Helper.sharedInstance.getTimeFromString(time: rhs.time) {
                        return lhsTime > rhsTime
                    }
                }
                return lhsDate > rhsDate
            }
            return lhs.date ?? "" > rhs.date ?? ""
        }
        return finalSortedList
    }
}

// MARK: Routing
extension NewsListViewModel {
    func navigateToNewsDetailViewController(with newsData: NewsData) {
        if let coordinator {
            coordinator.pushToNewsDetailsViewController(newsDetail: newsData)
        }
    }
}
