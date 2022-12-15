//
//  HomeViewController.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/14.
//

import UIKit
import SnapKit
import ReactorKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let subView = HomeView()
    
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

extension HomeViewController: ReactorKit.View {
    func bind(reactor: HomeViewReactor) {
        subView.bind(reactor: reactor)
        bindAction(reactor: reactor)
    }
    
    private func bindAction(reactor: HomeViewReactor) {
        self.rx.viewWillAppear
            .map { _ in HomeViewReactor.Action.viewLoaded }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
//        itemCollectionView.rx.modelSelected(Giphy.self)
        
            
    }
}
