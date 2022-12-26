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
        default:
            print("asdfasdfasdf")
            return
                .none
        }
    }
    
    private func coordinateToInduceboard() -> RxFlow.FlowContributors {
        let reactor = InduceViewReactor()
        let flow = InduceFlow()
        let controller = InduceViewController(reactor: reactor)
        InduceFlow.rootViewController.pushViewController(controller, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: flow,
                                                 withNextStepper: reactor))
    }
    
    private func coordinateToRelatedQueryView() -> RxFlow.FlowContributors {
        let reactor = RelatedQueryReactor()
        let flow = RelatedQueryFlow()
        let controller = RelatedQueryViewController(reactor: reactor)
        InduceFlow.rootViewController.pushViewController(controller, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: flow,
                                                 withNextStepper: reactor))
    }
}
