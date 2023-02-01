//
//  ItemView.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/14.
//

import UIKit
import RxSwift

class ItemView: UIView {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    let refreshControl = UIRefreshControl()
    
    lazy var itemCollectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout()).then {
        $0.backgroundColor = .clear
        $0.refreshControl = refreshControl
//        $0.rx.setDelegate(self).disposed(by: disposeBag)
        $0.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.identifier)
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
    
    func generateLayout() -> UICollectionViewLayout {
        /// 1. Item 정의
        // 젤 위 아이템(큰거 하나)
        let topItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalWidth(2/3))
        let topItem = NSCollectionLayoutItem(layoutSize: topItemSize) // -> 제일 위에 제일 큰 사진
        topItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // 두번째 아이템(왼쪽에 너비 절반사이즈 하나, 오른쪽에 작은거 두개 수직)
        let secondHalfItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3),
                                                        heightDimension: .fractionalHeight(1))
        let secondHalfItem = NSCollectionLayoutItem(layoutSize: secondHalfItemSize)
        secondHalfItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let pairItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.5))
        let pairItem = NSCollectionLayoutItem(layoutSize: pairItemSize)
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // 세번째 아이템(너비가 같은 아이템들 세개 수평으로)
        let tripleItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                    heightDimension: .fractionalHeight(1.0))
        let tripleItem = NSCollectionLayoutItem(layoutSize: tripleItemSize)
        tripleItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        /// 2. Group 정의
        // 두번째 아이템의 오른쪽 그룹
        let pairGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                   heightDimension: .fractionalHeight(1.0))
        let pairGroup = NSCollectionLayoutGroup.vertical(layoutSize: pairGroupSize,
                                                         subitem: pairItem,
                                                         count: 2)
        
        // 첫번째 큰 아이템 하나와 두번쨰 아이템의 왼쪽, 오른쪽 묶은 그룹
        let HalfWithPairGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .fractionalWidth(0.6))
        let HalfWithPairGroup = NSCollectionLayoutGroup.horizontal(layoutSize: HalfWithPairGroupSize,
                                                               subitems: [secondHalfItem, pairGroup])
        
        // 세번째 너비가 같은 아이템 세개 묶은 그룹
        let tripleGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalWidth(0.2))
        let tripleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: tripleGroupSize, subitem: tripleItem, count: 3)
        
        // 네번째는 두번째의 반대니까 순서만 바꿔서 위에거 재사용
        let secondHalfReversedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                 heightDimension: .fractionalWidth(0.6))
        let secondHalfReversedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: secondHalfReversedGroupSize, subitems: [pairGroup, secondHalfItem])
        
        /// 3. Section 정의
        // 위에서 작업한 거 수직으로 모두 묶기
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(1.0))
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize,
                                                           subitems: [topItem, HalfWithPairGroup, tripleGroup, secondHalfReversedGroup])
        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func bind(reactor: ItemViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ItemViewReactor) {
        refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .do(onNext: { $0.0.refreshCollectionView() })
            .map { _ in ItemViewReactor.Action.refreshControl }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        itemCollectionView.rx.modelSelected(Giphy.self)
            .throttle(.milliseconds(250), latest: false, scheduler: MainScheduler.instance)
            .map { ItemViewReactor.Action.modelSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ItemViewReactor) {
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

//extension ItemView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = bounds.width / 4 - 2
//        return CGSize(width: width, height: width)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 2
//    }
//}
