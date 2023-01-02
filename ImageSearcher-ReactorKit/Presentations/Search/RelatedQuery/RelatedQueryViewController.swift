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
    
    init(reactor: RelatedQueryReactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
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
    }
    
//    private func bindAction(reactor: RelatedQueryReactor) {
//        reactor.outputTrigger.withUnretained(self).bind(onNext: {
//            switch $0.1 {
//            case .modelSelected(let giphy):
//                let controller = ItemViewController()
//                controller.reactor = ItemViewReactor(wroteQuery: giphy.title)
//                $0.0.navigationController?.pushViewController(controller, animated: true)
//            case .searchButtonClicked(let selectedTitle):
//                let controller = ItemViewController()
//                controller.reactor = ItemViewReactor(wroteQuery: selectedTitle)
//                $0.0.navigationController?.pushViewController(controller, animated: true)
//            }
//        }).disposed(by: disposeBag)
//
//    }
    
}
