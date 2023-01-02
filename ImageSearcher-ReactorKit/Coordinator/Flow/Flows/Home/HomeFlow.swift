//
//  HomeFlow.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/29.
//

import RxFlow

class HomeFlow: Flow {
    var root: RxFlow.Presentable {
        return rootViewController
    }
    
    let rootViewController = UINavigationController(rootViewController: HomeViewController(reactor: HomeViewReactor()))
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .homeIsRequired:
            return coordinateToHome()
        case .homeDepthIsRequired:
            return coordinateToHomeDepth()
        case .back:
            return coordinateToBack()
        default: return .none
        }
    }
    
    private func coordinateToHome() -> FlowContributors {
        let reactor = HomeViewReactor()
        let controller = HomeViewController(reactor: reactor)
        
        rootViewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        rootViewController.tabBarItem.title = "홈"
        rootViewController.tabBarItem.image = UIImage(systemName: "house")
        
        rootViewController.setViewControllers([controller], animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: self.root,
                                                 withNextStepper: reactor))
    }
    
    private func coordinateToHomeDepth() -> FlowContributors {
        let reactor = HomeViewReactor()
        let controller = HomeDepthViewController(reactor: reactor)
        rootViewController.pushViewController(controller, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: controller,
                                                 withNextStepper: reactor))
    }
    
    private func coordinateToBack() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        
        return .none
    }
}
