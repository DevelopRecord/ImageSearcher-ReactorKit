//
//  RelatedQueryViewController.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/15.
//

import UIKit
import ReactorKit

class RelatedQueryViewController: UIViewController {
    
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    
    let subView = RelatedQueryView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        setupNavigationBar(searchBar: subView.searchBar)
        
        view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
}

extension RelatedQueryViewController: ReactorKit.View {
    func bind(reactor: RelatedQueryReactor) {
        subView.bind(reactor: reactor)
        bindAction(reactor: reactor)
    }
    
    private func bindAction(reactor: RelatedQueryReactor) {
        subView.relatedQueryTableView.rx.modelSelected(Giphy.self)
            .withUnretained(self)
            .subscribe(onNext: { owner, giphy in
                print("22: \(giphy.title)")
                let controller = HomeViewController()
                controller.reactor = HomeViewReactor(wroteQuery: giphy.title)
                owner.navigationController?.pushViewController(controller, animated: true)
            }).disposed(by: disposeBag)
            
        
    }
}
