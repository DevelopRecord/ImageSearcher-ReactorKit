//
//  DetailViewController.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/19.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    lazy var subView = DetailView()
    
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
