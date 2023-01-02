//
//  InduceFlow.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/21.
//

import RxFlow

class InduceFlow: Flow {
    var root: RxFlow.Presentable {
        return InduceFlow.rootViewController
    }
    
    static let rootViewController = UINavigationController()
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .induceboardIsRequired:
            return coordinateToInduceboard()
        case .relatedQueryViewIsRequired:
            return coordinateToRelatedQueryView()
        case .back:
            return coordinateToBack()
        default: return .none
        }
    }
    
    private func coordinateToInduceboard() -> FlowContributors {
        let reactor = InduceViewReactor()
        let flow = InduceFlow()
        let controller = InduceViewController(reactor: reactor)
        
        InduceFlow.rootViewController.tabBarItem.title = "검색"
        InduceFlow.rootViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        InduceFlow.rootViewController.setViewControllers([controller], animated: true)
        InduceFlow.rootViewController.tabBarController?.tabBar.isHidden = false
        
        return .one(flowContributor: .contribute(withNextPresentable: flow,
                                                 withNextStepper: reactor))
    }
    
    private func coordinateToRelatedQueryView() -> FlowContributors {
        let reactor = RelatedQueryReactor()
        let flow = RelatedQueryFlow()
        let controller = RelatedQueryViewController(reactor: reactor)
        InduceFlow.rootViewController.pushViewController(controller, animated: true)
        InduceFlow.rootViewController.tabBarController?.tabBar.isHidden = true
        
        return .one(flowContributor: .contribute(withNextPresentable: flow,
                                                 withNextStepper: reactor))
    }
    
    private func coordinateToBack() -> FlowContributors {
        InduceFlow.rootViewController.popViewController(animated: true)
        InduceFlow.rootViewController.tabBarController?.tabBar.isHidden = false
        
        return .none
    }
}
