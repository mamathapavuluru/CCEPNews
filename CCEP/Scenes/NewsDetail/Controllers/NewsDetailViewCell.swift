//
//  NewsDetailViewCell.swift
//  CCEP


import UIKit

class NewsDetailViewCell: ReusableTableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var imageViewLoader: ImageViewLoader!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
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
        labelDate.text = viewModel.date
        labelAuthor.text = viewModel.author
        if viewModel.webUrl != nil {
            readMoreButton.isHidden = false
        } else {
            readMoreButton.isHidden = true
        }
        if let strUrl = viewModel.image ??
            "".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
             let imgUrl = URL(string: strUrl) {
            imageViewLoader.loadImageWithUrl(imgUrl)
       }
    }
    
    // Prepare the cell
    func prepareCell(newsCellViewModel: NewsTableViewCellViewModel) {
        viewModel = newsCellViewModel
        setUpUI()
    }
    
    // Prepare the cell selection
    @IBAction func readMoreButtonAction(_ sender: UIButton) {
        viewModel?.cellSelected(indexPath: IndexPath(row: sender.tag, section: 0))
    }
}
