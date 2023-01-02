//
//  InduceView.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/15.
//

import UIKit
import Then

class InduceView: UIView {
    
    private lazy var induceLabel = UILabel().then {
        $0.text = "아무 키워드나 검색해 보아요."
        $0.font = UIFont.boldSystemFont(ofSize: 30)
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "👀"
        $0.font = UIFont.systemFont(ofSize: 32)
    }
    
    private lazy var induceView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - Initializing
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(induceView)
        [induceLabel, descriptionLabel].forEach { induceView.addSubview($0) }
        
        induceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(induceLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        induceView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(100)
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
