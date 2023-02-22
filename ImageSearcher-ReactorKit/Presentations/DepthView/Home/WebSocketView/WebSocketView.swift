//
//  WebSocketView.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2023/02/02.
//

import UIKit
import RxSwift

class WebSocketView: UIView {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    let whatsYourNameLabel = UILabel().then {
        $0.text = "이름을 입력하세요."
        $0.font = .boldSystemFont(ofSize: 26)
        $0.textAlignment = .center
    }
    
    lazy var nameTextField = UITextField().then {
        $0.placeholder = "이름을 입력해 보세요."
        $0.layer.cornerRadius = 14
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    lazy var joinButton = UIButton().then {
        $0.setTitle("접속하기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.layer.cornerRadius = 14
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.systemBlue.cgColor
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
        addSubviews([whatsYourNameLabel, nameTextField, joinButton])
        whatsYourNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        nameTextField.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.top.equalTo(whatsYourNameLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        joinButton.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameTextField.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    func bind(reactor: HomeViewReactor) {
        bindAction(reactor: reactor)
    }
    
    private func bindAction(reactor: HomeViewReactor) {
        joinButton.rx.tap
            .withUnretained(self)
            .map { HomeViewReactor.Action.joinClicked($0.0.nameTextField.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
