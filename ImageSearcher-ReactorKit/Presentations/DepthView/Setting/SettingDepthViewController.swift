//
//  SettingDepthViewController.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2023/01/02.
//

import UIKit
import ReactorKit

class SettingDepthViewController: UIViewController {
    
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    
    let subView = SettingDepthView()
    
    init(reactor: SettingViewReactor) {
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
        self.title = "SettingDepth"
        
        view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension SettingDepthViewController: ReactorKit.View {
    func bind(reactor: SettingViewReactor) {
        subView.bind(reactor: reactor)
    }
}

