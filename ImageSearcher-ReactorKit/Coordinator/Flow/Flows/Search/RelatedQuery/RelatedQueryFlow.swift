//
//  RelatedQueryFlow.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/21.
//

import RxFlow
import RxCocoa

class RelatedQueryFlow: Flow {
    var root: RxFlow.Presentable {
        return self.rootViewController
    }
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    var rootViewController = UINavigationController()
    
    deinit {
        print("RelatedQueryFlow Deinit: \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? AppStep else { return .none }
        // 여기 플로우 해제된건지 확인
        switch step {
        case .relatedQueryIsPicked(let query):
            return coordinateToGifItemView(query: query)
        case .searchButtonIsClicked(let query):
            return coordinateToGifItemView(query: query)
        default: return .none
        }
    }
    
    private func coordinateToGifItemView(query: String?) -> RxFlow.FlowContributors {
        let reactor = ItemViewReactor(wroteQuery: query)
        let controller = ItemViewController(reactor: reactor)
        let flow = ItemFlow(rootViewController: rootViewController)
        
        rootViewController.pushViewController(controller, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: flow,
                                                 withNextStepper: reactor))
    }
}
