//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by João Vitor Sousa on 26/01/24.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.backgroundColor = .secondarySystemFill
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(x: 10, 
                                      y: 0,
                                      width: contentView.frame.size.width - 170,
                                      height: contentView.frame.size.height / 2)
        
        subtitleLabel.frame = CGRect(x: 10,
                                      y: 70,
                                      width: contentView.frame.size.width - 170,
                                      height: contentView.frame.size.height / 2)
        
        newsImageView.frame = CGRect(x: contentView.frame.size.width - 150,
                                      y: 5,
                                      width: contentView.frame.size.width - 140,
                                      height: contentView.frame.size.height - 10)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle

        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            let cacheKey = url.absoluteString

            if let cachedImage = ImageCache.shared.getImage(forKey: cacheKey) {
                newsImageView.image = cachedImage
            } else {
                URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                    guard let data = data, error == nil, let image = UIImage(data: data) else {
                        return
                    }

                    ImageCache.shared.setImage(image, forKey: cacheKey)
                    viewModel.imageData = data
                    DispatchQueue.main.async {
                        self?.newsImageView.image = image
                    }
                }.resume()
            }
        }
    }
}
