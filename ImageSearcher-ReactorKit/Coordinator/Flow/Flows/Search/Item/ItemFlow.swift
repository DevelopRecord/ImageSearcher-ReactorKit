//
//  ItemFlow.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/22.
//

import RxFlow

class ItemFlow: Flow {
    var root: RxFlow.Presentable {
        return self.rootViewController
    }
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    var rootViewController = UINavigationController()
    
    deinit {
        print("ItemFlow Deinit: \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .GifItemIsPicked(let giphy):
            return coordinateToDetailView(of: giphy)
        default: return .none
        }
    }
    
    private func coordinateToDetailView(of giphy: Giphy) -> RxFlow.FlowContributors {
        let reactor = DetailViewReactor(giphy: giphy)
        let flow = DetailFlow(rootViewController: rootViewController)
        let controller = DetailViewController(reactor: reactor)
        controller.modalPresentationStyle = .pageSheet
        
        if let sheet = controller.sheetPresentationController {
            //지원할 크기 지정
            sheet.detents = [.medium()]
            //시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
        }
        rootViewController.present(controller, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: flow,
                                                 withNextStepper: reactor))
    }
}
