//
//  ConversationSentCell.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2023/02/07.
//

import UIKit

class ConversationSentCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ConversationSentCell"
    
    lazy var timeLabel = UILabel().then {
        $0.text = "17:00"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var contentLabel = UILabel().then {
        $0.text = "컨텐트 레이블"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var contentContainerView = UIView().then {
        $0.backgroundColor = .systemIndigo
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
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
        contentContainerView.addSubview(contentLabel)
        contentView.addSubviews([timeLabel, contentContainerView])
        
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        contentContainerView.snp.makeConstraints {
            $0.width.equalTo(0)
            $0.height.equalTo(40)
            $0.top.equalTo(timeLabel.snp.bottom).offset(5)
//            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
    }
    
    func setupRequest(_ authorInfo: AuthorInfo) {
        // 받아오는 유닉스 값이 이상한 관계로 뒤에 3자리 짜름
        let unixTime = TimeInterval("\(Int(authorInfo.time!))".dropLast(3)) ?? 0
        
        contentLabel.text = authorInfo.text
        timeLabel.text = unixTime.timeStampConverter()
        
        guard let text = authorInfo.text else { return }
        contentContainerView.snp.updateConstraints {
            $0.width.equalTo(text.widthOfString(usingFont: .systemFont(ofSize: 13, weight: .medium)) + 20)
        }
    }
}
