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
        
    }
    
    struct State {
        var gifs = Giphy()
    }
    
    let initialState: State = State()
}

extension DetailViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        return newState
    }
}
