//
//  HomeViewController.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/29.
//

import UIKit
import ReactorKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    
    let subView = HomeView()
    
    // MARK: - Initializing
    init(reactor: HomeViewReactor) {
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
        self.title = "홈"
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
    }
}
