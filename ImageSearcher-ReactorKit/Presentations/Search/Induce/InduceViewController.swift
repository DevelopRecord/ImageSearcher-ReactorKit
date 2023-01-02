//
//  InduceViewController.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/15.
//

import UIKit
import RxCocoa
import ReactorKit

class InduceViewController: UIViewController {
    
    // MARK: - Properties
    var disposeBag: DisposeBag = .init()
    
    lazy var barButton = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    init(reactor: InduceViewReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let subView = InduceView()
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        self.title = "검색"
        
        navigationItem.setRightBarButton(barButton, animated: true)
        
        view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension InduceViewController: ReactorKit.View {
    func bind(reactor: InduceViewReactor) {
        bindAction(reactor: reactor)
    }
    
    private func bindAction(reactor: InduceViewReactor) {
        barButton.rx.tap
            .map { InduceViewReactor.Action.searchBarButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in InduceViewReactor.Action.viewAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
