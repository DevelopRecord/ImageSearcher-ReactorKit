//
//  InduceFlow.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/21.
//

import RxFlow

class InduceFlow: Flow {
    var root: RxFlow.Presentable {
        return rootViewController
    }
    
    private let rootViewController = UINavigationController()
    
    deinit {
        print("InduceFlow Deinit: \(type(of: self)): \(#function)")
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
        
        rootViewController.tabBarItem.title = "검색"
        rootViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        rootViewController.setViewControllers([controller], animated: true)
        rootViewController.tabBarController?.tabBar.isHidden = false
        
        return .one(flowContributor: .contribute(withNextPresentable: self.root,
                                                 withNextStepper: reactor))
    }
    
    private func coordinateToRelatedQueryView() -> FlowContributors {
        let reactor = RelatedQueryReactor()
        let flow = RelatedQueryFlow(rootViewController: rootViewController)
        let controller = RelatedQueryViewController(reactor: reactor)
        
        rootViewController.pushViewController(controller, animated: true)
        rootViewController.tabBarController?.tabBar.isHidden = true
        // Flows.use
        return .one(flowContributor: .contribute(withNextPresentable: flow,
                                                 withNextStepper: reactor))
    }
    
    private func coordinateToBack() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        rootViewController.tabBarController?.tabBar.isHidden = false
        
        return .none
    }
}
