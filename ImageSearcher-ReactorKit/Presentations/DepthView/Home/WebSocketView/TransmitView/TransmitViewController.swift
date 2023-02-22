//
//  TransmitViewController.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2023/02/02.
//

import UIKit
import ReactorKit

class TransmitViewController: UIViewController {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    let subView = TransmitView()
    
    // MARK: - Initializing
    
    init(reactor: TransmitViewReactor) {
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
        self.title = UserDefaults.standard.string(forKey: "name")
        
        view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension TransmitViewController: ReactorKit.View {
    func bind(reactor: TransmitViewReactor) {
        subView.bind(reactor: reactor)
        
        self.rx.viewDidLoad
            .map { _ in TransmitViewReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewWillDisappear
            .map { _ in TransmitViewReactor.Action.viewWillDisappear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
