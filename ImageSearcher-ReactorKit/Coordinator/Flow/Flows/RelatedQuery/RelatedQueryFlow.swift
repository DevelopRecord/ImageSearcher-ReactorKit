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
    
    let rootViewController = UINavigationController()
    
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .relatedQueryIsPicked(let giphy):
            print("asdf1")
            return coordinateToGIfItemView(with: giphy)
        default: return .none
        }
    }
    
    private func coordinateToGIfItemView(with giphy: Giphy) -> RxFlow.FlowContributors {
        let reactor = ItemViewReactor(wroteQuery: giphy.title)
        let controller = ItemViewController(reactor: reactor)
        let flow = ItemFlow()
        
        InduceFlow.rootViewController.pushViewController(controller, animated: true)
        
        
        return .one(flowContributor: .contribute(withNextPresentable: flow,
                                                 withNextStepper: reactor))
    }
}
