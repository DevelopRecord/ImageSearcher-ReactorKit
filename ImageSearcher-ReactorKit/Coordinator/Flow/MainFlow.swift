//
//  MainFlow'.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/29.
//

import UIKit
import RxFlow

final class MainFlow: Flow {
    enum TabbarIndex: Int { // 설정탭으로 이동하기 위해 열거형 정의함
        case home = 0
        case search = 1
        case setting = 2
    }
    
    var root: RxFlow.Presentable {
        return rootViewController
    }
    
    let rootViewController = UITabBarController()
    
    private let homeFlow = HomeFlow()
    private let induceFlow = InduceFlow()
    private let settingFlow = SettingFlow()
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .mainTabbarIsRequired:
            return coordinateToMainTabbar()
        case .toSettingIsRequiredAgain:
            return coordinateToSettingAgain()
        default: return .none
        }
    }
}

extension MainFlow {
    private func coordinateToMainTabbar() -> FlowContributors {
        let flows: [Flow] = [homeFlow, induceFlow, settingFlow]
        
        Flows.use(flows, when: .created) { [weak self] flowRoot in
            guard let self = self else { return }
            self.rootViewController.viewControllers = flowRoot
        }
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: homeFlow,
                                                        withNextStepper: HomeStepper.shared),
                                            .contribute(withNextPresentable: induceFlow,
                                                        withNextStepper: OneStepper(withSingleStep: AppStep.induceboardIsRequired)),
                                            .contribute(withNextPresentable: settingFlow,
                                                        withNextStepper: OneStepper(withSingleStep: AppStep.settingIsRequired))])
    }
    
    private func coordinateToSettingAgain() -> FlowContributors {
        rootViewController.selectedIndex = TabbarIndex.setting.rawValue // 설정화면 탭바 인덱스 번호
        
        return .one(flowContributor: .contribute(withNextPresentable: settingFlow,
                                                 withNextStepper: SettingViewReactor()))
    }
}
