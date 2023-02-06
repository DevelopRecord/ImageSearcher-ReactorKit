//
//  TransmitViewController.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2023/02/02.
//

import UIKit

class TransmitViewController: UIViewController {
    
    // MARK: - Properties
    
    let subView = TransmitView()
    
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
