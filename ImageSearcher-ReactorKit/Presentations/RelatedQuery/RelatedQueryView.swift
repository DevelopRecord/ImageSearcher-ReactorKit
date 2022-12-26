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
        $0.delegate = self
        $0.dataSource = self
        $0.register(RelatedQueryCell.self, forCellReuseIdentifier: RelatedQueryCell.identifier)
    }
    
    lazy var searchBar = UISearchBar().then {
        $0.placeholder = "검색어 입력"
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
            .map { RelatedQueryReactor.Action.selectedType(.searchButtonClicked(nil)) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        relatedQueryTableView.rx.modelSelected(Giphy.self)
            .map { RelatedQueryReactor.Action.selectedType(.modelSelected($0)) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: RelatedQueryReactor) {
        relatedQueryTableView.delegate = nil
        relatedQueryTableView.dataSource = nil
        relatedQueryTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.gifs }
            .bind(to: relatedQueryTableView.rx.items(cellIdentifier: RelatedQueryCell.identifier, cellType: RelatedQueryCell.self)) { index, gifs, cell in
                cell.setupRequest(with: gifs)
            }.disposed(by: disposeBag)
    }
}

extension RelatedQueryView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RelatedQueryCell.identifier, for: indexPath) as? RelatedQueryCell else { return UITableViewCell() }
        return cell
    }
}
