//
//  HomeView.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/14.
//

import UIKit
import RxSwift

class HomeView: UIView {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private let refreshControl = UIRefreshControl()
    
    lazy var itemCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.identifier)
        $0.refreshControl = refreshControl
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(itemCollectionView)
        itemCollectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func bind(reactor: HomeViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: HomeViewReactor) {
        refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .do(onNext: { $0.0.refreshCollectionView() })
            .map { _ in HomeViewReactor.Action.refreshControl }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        itemCollectionView.rx.modelSelected(Giphy.self)
            .throttle(.milliseconds(250), latest: false, scheduler: MainScheduler.instance)
            .map { HomeViewReactor.Action.selectedType(.modelSelected($0)) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: HomeViewReactor) {
        itemCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.gifs }
            .bind(to: itemCollectionView.rx.items(cellIdentifier: ItemCell.identifier, cellType: ItemCell.self)) { index, giphy, cell in
                cell.setupRequest(with: giphy)
            }.disposed(by: disposeBag)
    }
    
    private func refreshCollectionView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard let self = self else { return }
            self.itemCollectionView.refreshControl?.endRefreshing()
        })
    }
}

extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = bounds.width / 4 - 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
