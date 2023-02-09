//
//  TransmitInfoView.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2023/02/02.
//

import UIKit
import RxSwift

class TransmitInfoView: UIView {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    lazy var conversationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 0
    }).then {
        $0.backgroundColor = .systemGray3
        $0.rx.setDelegate(self).disposed(by: disposeBag)
        $0.register(ConversationReceivedCell.self, forCellWithReuseIdentifier: ConversationReceivedCell.identifier)
        $0.register(ConversationSentCell.self, forCellWithReuseIdentifier: ConversationSentCell.identifier)
    }
    
    lazy var transmitTextField = UITextField().then {
        $0.placeholder = "대화 텍스트"
        $0.layer.cornerRadius = 14
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    lazy var isShowButton = UIButton(type: .system).then {
        $0.backgroundColor = .systemBlue
        $0.titleLabel?.font = .boldSystemFont(ofSize: 17)
        $0.setTitle("보기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        
        $0.setTitle("숨기기", for: .selected)
        $0.setTitleColor(.white, for: .selected)
    }
    
    lazy var transmitButton = UIButton(type: .system).then {
        $0.backgroundColor = .systemBlue
        $0.setTitle("전송하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
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
        addSubviews([ conversationCollectionView, transmitTextField, isShowButton, transmitButton])
        
        conversationCollectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(transmitTextField.snp.top).offset(-10)
        }
        
        transmitTextField.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(transmitButton.snp.top).offset(-20)
        }
        
        isShowButton.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(40)
            $0.leading.bottom.equalToSuperview().inset(20)
        }
        
        transmitButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.equalTo(isShowButton.snp.trailing).offset(20)
            $0.trailing.bottom.equalToSuperview().inset(20)
        }
    }
}

extension TransmitInfoView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.size.width, height: 70)
    }
}
