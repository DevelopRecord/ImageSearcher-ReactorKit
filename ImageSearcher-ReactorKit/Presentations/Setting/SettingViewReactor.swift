//
//  SettingViewReactor.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/29.
//

import ReactorKit
import RxFlow
import RxCocoa

class SettingViewReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    
    enum Action {
        // setting view action
        case modalButtonClicked
        case alertButtonClicked
        
        // settingDepth view action
        case dismissButtonClicked
    }
    
    enum Mutation { }
    
    struct State { }
    
    let initialState: State = State()
}

extension SettingViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .modalButtonClicked:
            steps.accept(AppStep.settingDepthIsRequired)
            return .empty()
        case .alertButtonClicked:
            steps.accept(AppStep.settingAlertIsRequired(message: "설정 뷰의 ALERT 👀"))
            return .empty()
        case .dismissButtonClicked:
            steps.accept(AppStep.dismiss)
            return .empty()
        }
    }
}
