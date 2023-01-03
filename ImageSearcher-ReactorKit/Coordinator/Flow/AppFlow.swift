//
//  AppFlow.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/20.
//

import RxFlow

// Flow 프로토콜 구현부를 보면 AnyObject를 준수함. 따라서 AppFlow는 class로 선언해야함.
final class AppFlow: RxFlow.Flow {
    private let rootWindow: UIWindow
    
    init(with rootWindow: UIWindow) {
        self.rootWindow = rootWindow
    }
    
    var root: RxFlow.Presentable {
        return self.rootWindow
    }
    
    /// 검색유도 화면으로 이동
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? AppStep else { return FlowContributors.none }
        
        switch step {
        case .mainTabbarIsRequired:
            return coordinateToMainTabbar()
        default: return .none
        }
    }
}

extension AppFlow {
    private func coordinateToMainTabbar() -> FlowContributors {
        let mainFlow = MainFlow()

        Flows.use(mainFlow, when: .created) { [weak self] flowRoot in
            guard let self = self else { return }
            self.rootWindow.rootViewController = flowRoot
        }
        let nextStep = OneStepper(withSingleStep: AppStep.mainTabbarIsRequired)

        return .one(flowContributor: .contribute(withNextPresentable: mainFlow,
                                                 withNextStepper: nextStep))
    }
}
