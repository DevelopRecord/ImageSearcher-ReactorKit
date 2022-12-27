//
//  DetailView.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/19.
//

import UIKit
import RxSwift

class DetailView: UIView {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    lazy var thumbnailImage = UIImageView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 4
    }
    // url username title image
    lazy var titleLabel = UILabel().then {
        $0.text = "title Label"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    lazy var usernameLabel = UILabel().then {
        $0.text = "username Label"
        $0.font = .systemFont(ofSize: 20)
    }
    
    lazy var urlButton = UIButton().then {
        $0.setTitle("URL Label", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20)
    }
    
    lazy var infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupLayout() {
        addSubviews([thumbnailImage, infoStackView])
        thumbnailImage.snp.makeConstraints {
            $0.height.equalTo(180)
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        [titleLabel, usernameLabel, urlButton].forEach { infoStackView.addArrangedSubview($0) }
        infoStackView.snp.makeConstraints {
            $0.height.equalTo(120)
            $0.top.equalTo(thumbnailImage.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func bind(reactor: DetailViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: DetailViewReactor) {
        // Other Actions ...
        urlButton.rx.tap
            .map { DetailViewReactor.Action.urlButtonClicked(reactor.currentState.gifs.url) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: DetailViewReactor) {
        reactor.state
            .compactMap { $0.gifs }
            .withUnretained(self)
            .bind {
                guard let urlString = $0.1.images?.fixedWidthSmall?.url, let url = URL(string: urlString) else { return }
                $0.0.thumbnailImage.kf.setImage(with: url)
                $0.0.titleLabel.text = "TITLE: \($0.1.title ?? "")"
                $0.0.usernameLabel.text = "USER NAME: \($0.1.username ?? "")"
                $0.0.urlButton.setTitle($0.1.url, for: .normal)
        }.disposed(by: disposeBag)
    }
    
    func setupRequest(of giphy: Giphy) {
        guard let urlString = giphy.images?.fixedWidthSmall?.url, let url = URL(string: urlString) else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.thumbnailImage.kf.setImage(with: url)
        }
    }
}
