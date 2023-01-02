//
//  HomeView.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/29.
//

import UIKit
import RxSwift

class HomeView: UIView {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    lazy var pushButton = UIButton(type: .system).then {
        $0.setTitle("Push Button", for: .normal)
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
        addSubview(pushButton)
        pushButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    func bind(reactor: HomeViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: HomeViewReactor) {
        pushButton.rx.tap
            .map { HomeViewReactor.Action.homePushClicked }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: HomeViewReactor) {
        
    }
}
