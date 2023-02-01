//
//  ItemViewReactor.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/14.
//

import RxSwift
import RxCocoa
import ReactorKit
import RxFlow

class ItemViewReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    
    enum Action {
        case refreshControl
        case viewLoaded
        case modelSelected(Giphy)
    }
    
    enum Mutation {
        case gifs([Giphy])
    }
    
    struct State {
        var gifs: [Giphy] = []
    }
    
    let initialState: State = State()
    
    var wroteQuery: String!
    
    init(wroteQuery: String?) {
        self.wroteQuery = wroteQuery
    }
}

extension ItemViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refreshControl, .viewLoaded:
            return fetchGiphy(of: wroteQuery).flatMap { giphy -> Observable<Mutation> in
                return .just(.gifs(giphy))
            }
        case .viewLoaded:
            return fetchGiphy(of: wroteQuery).flatMap { giphy -> Observable<Mutation> in
                return .just(.gifs(giphy))
            }
        case .modelSelected(let giphy):
            steps.accept(AppStep.GifItemIsPicked(giphy))
            return .empty()
        }
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

extension ItemViewReactor {
    private func fetchGiphy(of query: String) -> Observable<[Giphy]> {
        let response = APIService.shared.fetchGifs(query: query)
        
        return Observable<[Giphy]>.create { observer in
            response.subscribe({ state in
                switch state {
                case .success(let response):
                    if let giphy = response.data {
                        observer.onNext(giphy)
                        observer.onCompleted()
                    }
                case .failure(let error):
                    print("ERR: \(error.localizedDescription)")
                    observer.onError(error)
                }
            })
        }
    }
}
