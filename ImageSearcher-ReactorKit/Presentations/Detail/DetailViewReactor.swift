//
//  DetailViewReactor.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/19.
//

import ReactorKit

class DetailViewReactor: Reactor {
    enum Action {
        
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
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .gifs(let giphy):
            newState.gifs = giphy
        }
        
        return newState
    }
}
