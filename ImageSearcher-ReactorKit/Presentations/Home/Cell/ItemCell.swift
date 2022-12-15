//
//  ItemCell.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/15.
//

import UIKit
import Kingfisher

class ItemCell: UICollectionViewCell {
    
    static let identifier = "ItemCell"
    
    // MARK: Properties
    lazy var thumbnailImage = UIImageView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 8
    }
    
    // MARK: Initializing
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(thumbnailImage)
        thumbnailImage.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func setupRequest(with giphy: Giphy) {
        guard let urlString = giphy.images?.fixedWidthSmall?.url, let url = URL(string: urlString) else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.thumbnailImage.kf.setImage(with: url)
        }
    }
}
