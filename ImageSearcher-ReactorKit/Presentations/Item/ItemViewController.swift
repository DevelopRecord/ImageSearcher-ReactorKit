//
//  ItemViewController.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/14.
//

import UIKit
import SnapKit
import ReactorKit

class ItemViewController: UIViewController {
    
    // MARK: - Properties
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let subView = ItemView()
    
    init(reactor: ItemViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension ItemViewController: ReactorKit.View {
    func bind(reactor: ItemViewReactor) {
        subView.bind(reactor: reactor)
        bindAction(reactor: reactor)
    }
    
    private func bindAction(reactor: ItemViewReactor) {
        self.rx.viewWillAppear
            .map { _ in ItemViewReactor.Action.viewLoaded }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.outputTrigger.withUnretained(self).bind(onNext: {
            switch $0.1 {
            case .modelSelected(let giphy):
                let controller = DetailViewController(giphy: giphy)
                controller.modalPresentationStyle = .pageSheet

                if let sheet = controller.sheetPresentationController {
                    //지원할 크기 지정
                    sheet.detents = [.medium()]
                    //크기 변하는거 감지
                    sheet.delegate = self
                    //시트 상단에 그래버 표시 (기본 값은 false)
                    sheet.prefersGrabberVisible = true
                }
                $0.0.present(controller, animated: true)
            }
        }).disposed(by: disposeBag)
    }
}

extension ItemViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        //크기 변경 됐을 경우
        print(sheetPresentationController.selectedDetentIdentifier == .large ? "large" : "medium")
    }
}
