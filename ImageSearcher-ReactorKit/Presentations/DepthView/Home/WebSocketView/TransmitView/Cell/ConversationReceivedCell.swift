//
//  ConversationReceivedCell.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2023/02/07.
//

import UIKit

class ConversationReceivedCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ConversationReceivedCell"
    
    lazy var profileImage = UIImageView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
    }
    
    lazy var nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    lazy var timeLabel = UILabel().then {
        $0.text = "17:00"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var contentLabel = UILabel().then {
        $0.text = "컨텐트 레이블"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var contentContainerView = UIView().then {
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupLayout() {
        contentView.backgroundColor = .systemBackground
        
        
        contentView.addSubviews([profileImage, nicknameLabel, timeLabel, contentContainerView])
        contentContainerView.addSubview(contentLabel)
        
        profileImage.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(15)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImage)
            $0.leading.equalTo(profileImage.snp.trailing).offset(5)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(nicknameLabel)
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(20)
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
        }
        
        contentContainerView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(profileImage.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().inset(3)
        }
    }
    
    func setupRequest(_ authorInfo: AuthorInfo) {
        let unixTime = TimeInterval("\(Int(authorInfo.time!))".dropLast(3)) ?? 0
        
        nicknameLabel.text = authorInfo.author
        contentLabel.text = authorInfo.text
        timeLabel.text = unixTime.timeStampConverter()
    }
}
