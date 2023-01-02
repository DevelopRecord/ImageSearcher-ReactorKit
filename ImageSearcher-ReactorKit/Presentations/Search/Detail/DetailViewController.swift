//
//  DetailViewController.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/19.
//

import UIKit
import ReactorKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    lazy var subView = DetailView()
    
//    init(giphy: Giphy) {
//        defer { self.reactor = DetailViewReactor(giphy: giphy) }
//        super.init(nibName: nil, bundle: nil)
//    }
    
    init(reactor: DetailViewReactor) {
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

    // MARK: - Methods
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension DetailViewController: ReactorKit.View {
    func bind(reactor: DetailViewReactor) {
        subView.bind(reactor: reactor)
    }
}
