//
//  HomeViewController.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/14.
//

import UIKit
import SnapKit
import ReactorKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let subView = HomeView()
    
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

extension HomeViewController: ReactorKit.View {
    func bind(reactor: HomeViewReactor) {
        subView.bind(reactor: reactor)
        bindAction(reactor: reactor)
    }
    
    private func bindAction(reactor: HomeViewReactor) {
        self.rx.viewWillAppear
            .map { _ in HomeViewReactor.Action.viewLoaded }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.outputTrigger.withUnretained(self).bind(onNext: {
            switch $0.1 {
            case .modelSelected(let giphy):
                print("detail: \(giphy)")
                let controller = DetailViewController()
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

extension HomeViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        //크기 변경 됐을 경우
        print(sheetPresentationController.selectedDetentIdentifier == .large ? "large" : "medium")
    }
}
