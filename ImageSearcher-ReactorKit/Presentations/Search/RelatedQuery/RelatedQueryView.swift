//
//  RelatedQueryView.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/15.
//

import UIKit
import RxSwift

class RelatedQueryView: UIView {
    
    var disposeBag = DisposeBag()
    
    lazy var relatedQueryTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.rowHeight = 40
        $0.register(RelatedQueryCell.self, forCellReuseIdentifier: RelatedQueryCell.identifier)
    }
    
    lazy var searchBar = UISearchBar().then {
        $0.placeholder = "검색어 입력"
        $0.setupKeyboardToolbar()
    }
    
    lazy var emptyView = UIView().then {
        $0.backgroundColor = .clear
        
        let label = UILabel().then {
            $0.text = "결과 없음"
            $0.font = .boldSystemFont(ofSize: 24)
        }
        $0.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Outlets
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setupLayout() {
        backgroundColor = .systemBackground
        
        addSubview(relatedQueryTableView)
        relatedQueryTableView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension RelatedQueryView {
    func bind(reactor: RelatedQueryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: RelatedQueryReactor) {
        searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { RelatedQueryReactor.Action.searchQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .map { RelatedQueryReactor.Action.searchButtonClicked(nil) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        relatedQueryTableView.rx.modelSelected(Giphy.self)
            .map { RelatedQueryReactor.Action.modelSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: RelatedQueryReactor) {
        reactor.state
            .compactMap { $0.gifs }
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                self.relatedQueryTableView.backgroundView = $0.isEmpty ? self.emptyView : nil
            })
            .bind(to: relatedQueryTableView.rx.items(cellIdentifier: RelatedQueryCell.identifier, cellType: RelatedQueryCell.self)) { _, gifs, cell in
                cell.setupRequest(with: gifs)
            }.disposed(by: disposeBag)
    }
}
