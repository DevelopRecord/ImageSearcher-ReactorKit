//
//  DetailViewReactor.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/19.
//

import ReactorKit
import RxCocoa
import RxFlow

class DetailViewReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    
    enum Action {
        case urlButtonClicked(String?)
    }
    
    enum Mutation {
        case gifs(Giphy)
    }
    
    struct State {
        var gifs: Giphy
    }
    
    let initialState: State
    
    init(giphy: Giphy) {
        initialState = State(gifs: giphy)
    }
}

extension DetailViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .urlButtonClicked(let urlString):
            steps.accept(AppStep.safariUrlButtonIsClicked(urlString))
//            print("url Button Clicked: \(urlString)")
            return .empty()
        }
    }
}
