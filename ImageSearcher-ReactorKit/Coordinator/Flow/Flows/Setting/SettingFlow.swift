//
//  SettingFlow.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/29.
//

import RxFlow

class SettingFlow: Flow {
    var root: Presentable {
        return rootViewController
    }
    
    private let rootViewController = UINavigationController()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .settingIsRequired:
            return coordinateToSetting()
        case .settingDepthIsRequired:
            return coordinateToSettingDepth()
        case .settingAlertIsRequired(let message):
            return coordinateToAlertView(message: message)
        case .dismiss:
            rootViewController.visibleViewController?.dismiss(animated: true)
            
            return .none
        default: return .none
        }
    }
    
    private func coordinateToSetting() -> FlowContributors {
        let reactor = SettingViewReactor()
        let controller = SettingViewController(reactor: reactor)
        
        rootViewController.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fill")
        rootViewController.tabBarItem.title = "검색"
        rootViewController.tabBarItem.image = UIImage(systemName: "gearshape")
        rootViewController.setViewControllers([controller], animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: self.root,
                                                 withNextStepper: reactor))
    }
    
    private func coordinateToSettingDepth() -> FlowContributors {
        let reactor = SettingViewReactor()
        let controller = SettingDepthViewController(reactor: reactor)
        rootViewController.visibleViewController?.present(controller, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: controller,
                                                 withNextStepper: reactor))
    }
    
    private func coordinateToAlertView(message: String) -> FlowContributors {
        let alert = UIAlertController(title: "제목", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "취소 !", style: .cancel))
        rootViewController.present(alert, animated: true)
        
        return .none
    }
}
