//
//  TransmitInfoView.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2023/02/02.
//

import UIKit

class TransmitInfoView: UIView {
    
    // MARK: - Properties
    
    let transmitInfoLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 42)
        $0.backgroundColor = .systemGreen
        $0.text = "😀"
    }
    
    lazy var transmitTextField = UITextField().then {
        $0.placeholder = "대화 텍스트"
        $0.layer.cornerRadius = 14
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    let transmitButton = UIButton(type: .system).then {
        $0.backgroundColor = .systemBlue
        $0.setTitle("전송하기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 17)
        $0.isEnabled = false
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
        addSubviews([transmitInfoLabel, transmitTextField, transmitButton])
        transmitInfoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        transmitTextField.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.top.equalTo(transmitInfoLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        transmitButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.top.equalTo(transmitTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
    }
}
