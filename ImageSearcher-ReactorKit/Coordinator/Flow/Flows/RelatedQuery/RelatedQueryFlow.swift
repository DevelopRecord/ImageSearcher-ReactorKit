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
            return coordinateToGIfItemView(giphy: giphy)
        case .searchButtonIsClicked(let query):
            return coordinateToGifItemView(query: query)
        default: return .none
        }
    }
    
    private func coordinateToGIfItemView(giphy: Giphy) -> RxFlow.FlowContributors {
        let reactor = ItemViewReactor(wroteQuery: giphy.title)
        let controller = ItemViewController(reactor: reactor)
        let flow = ItemFlow()
        
        InduceFlow.rootViewController.pushViewController(controller, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: flow,
                                                 withNextStepper: reactor))
    }
    
    private func coordinateToGifItemView(query: String?) -> RxFlow.FlowContributors {
        let reactor = ItemViewReactor(wroteQuery: query)
        let flow = ItemFlow()
        let controller = ItemViewController(reactor: reactor)
        
        InduceFlow.rootViewController.pushViewController(controller, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: flow,
                                                 withNextStepper: reactor))
    }
}
