//
//  SettingView.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/29.
//

import UIKit
import RxSwift

class SettingView: UIView {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    lazy var modalButton = UIButton(type: .system).then {
        $0.setTitle("Modal Button", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
        $0.backgroundColor = .lightGray
    }
    
    lazy var alertButton = UIButton(type: .system).then {
        $0.setTitle("Alert Button", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
        $0.backgroundColor = .lightGray
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
        backgroundColor = .systemBackground
        
        addSubview(modalButton)
        [modalButton, alertButton].forEach { addSubview($0) }
        modalButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        alertButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(modalButton.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    func bind(reactor: SettingViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: SettingViewReactor) {
        modalButton.rx.tap
            .map { SettingViewReactor.Action.modalButtonClicked }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        alertButton.rx.tap
            .map { SettingViewReactor.Action.alertButtonClicked }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: SettingViewReactor) {
        
    }
}
