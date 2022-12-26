//
//  ItemViewController.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/14.
//

import UIKit
import SnapKit
import ReactorKit

class ItemViewController: UIViewController {
    
    // MARK: - Properties
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let subView = ItemView()
    
    init(reactor: ItemViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension ItemViewController: ReactorKit.View {
    func bind(reactor: ItemViewReactor) {
        subView.bind(reactor: reactor)
        bindAction(reactor: reactor)
    }
    
    private func bindAction(reactor: ItemViewReactor) {
        self.rx.viewWillAppear
            .map { _ in ItemViewReactor.Action.viewLoaded }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
