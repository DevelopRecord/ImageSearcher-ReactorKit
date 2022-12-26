//
//  InduceViewReactor.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/21.
//

import ReactorKit
import RxFlow
import RxCocoa

class InduceViewReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    
    enum Action {
        case searchBarButtonTapped
    }
    
    enum Mutate {
        
    }
    
    struct State {
        
    }
    
    let initialState: State = .init()
}

extension InduceViewReactor {
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .searchBarButtonTapped:
            steps.accept(AppStep.relatedQueryViewIsRequired)
            
            return .empty()
        }
    }
}