//
//  HomeViewReactor.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/29.
//

import UIKit
import ReactorKit
import RxCocoa
import RxFlow

class HomeViewReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    
    enum Action {
        // homeView action
        case homePushClicked
        
        // homeDepthView action
        case popViewButtonClicked
        case toSettingButtonClicked
    }
    
    enum Mutation { }
    
    struct State { }
    
    let initialState: State = State()
}

extension HomeViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .homePushClicked:
            steps.accept(AppStep.homeDepthIsRequired)
            return .empty()
        case .popViewButtonClicked:
            steps.accept(AppStep.back)
            return .empty()
        case .toSettingButtonClicked:
            steps.accept(AppStep.toSettingIsRequiredAgain)
            return .empty()
        }
    }
    
}
