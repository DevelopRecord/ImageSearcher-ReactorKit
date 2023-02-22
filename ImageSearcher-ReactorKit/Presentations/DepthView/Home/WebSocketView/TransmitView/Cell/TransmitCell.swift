//
//  EmojiCell.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2023/02/15.
//

import UIKit

class EmojiCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "EmojiCell"
    
    let emojiLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 22)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 2.5
                layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupLayout() {
        contentView.backgroundColor = .systemGreen
        
        contentView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
