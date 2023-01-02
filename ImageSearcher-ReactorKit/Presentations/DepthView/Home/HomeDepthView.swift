//
//  HomeDepthView.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/29.
//

import UIKit
import RxSwift

class HomeDepthView: UIView {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    lazy var popViewButton = UIButton().then {
        $0.backgroundColor = .systemPink
        $0.setTitle("뒤로가기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
    }
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(popViewButton)
        popViewButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }
}

extension HomeDepthView {
    func bind(reactor: HomeViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: HomeViewReactor) {
        popViewButton.rx.tap
            .map { HomeViewReactor.Action.popViewButtonClicked }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: HomeViewReactor) {
        
    }
}
