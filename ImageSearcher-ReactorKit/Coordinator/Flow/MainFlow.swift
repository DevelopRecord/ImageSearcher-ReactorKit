//
//  MainFlow'.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/29.
//

import UIKit
import RxFlow

final class MainFlow: Flow {
    var root: RxFlow.Presentable {
        return rootViewController
    }
    
    let rootViewController = UITabBarController()
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .mainTabbarIsRequired:
            return coordinateToMainTabbar()
        default: return .none
        }
    }
    
    private func coordinateToMainTabbar() -> FlowContributors {
        let homeFlow = HomeFlow()
        let InduceFlow = InduceFlow()
        let settingFlow = SettingFlow()
        let flows: [Flow] = [homeFlow, InduceFlow, settingFlow]
        
        Flows.use(flows, when: .created) { [weak self] flowRoot in
            guard let self = self else { return }
            self.rootViewController.viewControllers = flowRoot
        }
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: homeFlow,
                                                        withNextStepper: OneStepper(withSingleStep: AppStep.homeIsRequired)),
                                            .contribute(withNextPresentable: InduceFlow,
                                                        withNextStepper: OneStepper(withSingleStep: AppStep.induceboardIsRequired)),
                                            .contribute(withNextPresentable: settingFlow,
                                                        withNextStepper: OneStepper(withSingleStep: AppStep.settingIsRequired))])
    }
}
