//
//  NewsTableViewCell.swift
//  CCEP


import UIKit
import Combine

class NewsTableViewCell: ReusableTableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var loaderImageView: ImageViewLoader!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labeldate: UILabel!
    
    // MARK: - Properties
    var viewModel: NewsTableViewCellViewModel?

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    // Setup the data to ui
    private func setUpUI() {
        guard let viewModel = self.viewModel else { return }
        labelTitle.text = viewModel.title
        labelContent.text = viewModel.content
        labeldate.text = viewModel.date
        if let strUrl = viewModel.image ?? "".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
             let imgUrl = URL(string: strUrl) {
            loaderImageView.loadImageWithUrl(imgUrl)
       }
    }
    
    // Prepare the cell
    func prepareCell(newsCellViewModel: NewsTableViewCellViewModel) {
        viewModel = newsCellViewModel
        setUpUI()
    }
    
    // Prepare the cell selection
    func didSelectCell(index: IndexPath, newsCellViewModel: NewsTableViewCellViewModel) {
        viewModel = newsCellViewModel
        viewModel?.cellSelected(indexPath: index)
    }
}
