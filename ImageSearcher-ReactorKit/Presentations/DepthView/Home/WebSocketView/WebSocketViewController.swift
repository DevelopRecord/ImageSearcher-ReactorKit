//
//  WebSocketViewController.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2023/02/02.
//

import UIKit
import ReactorKit
import SnapKit

class WebSocketViewController: UIViewController {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    let subView = WebSocketView()
    
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
        view.backgroundColor = .systemBackground
        
        view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension WebSocketViewController: ReactorKit.View {
    func bind(reactor: HomeViewReactor) {
        subView.bind(reactor: reactor)
    }
}
