//
//  RelatedQueryReactor.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/15.
//

import ReactorKit
import RxCocoa
import RxFlow

class RelatedQueryReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    
    var disposeBag = DisposeBag()
    
    enum Action {
        case searchQuery(String)
        case modelSelected(Giphy)
        case searchButtonClicked(String?)
    }
    
    enum Mutation {
        case gifs([Giphy])
        case searchQuery(String)
    }
    
    struct State {
        var gifs: [Giphy] = []
        var searchQuery: String?
    }
    
    let initialState: State = State()
}

extension RelatedQueryReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchQuery(let searchQuery):
            return fetchGiphy(of: searchQuery).flatMap { giphy -> Observable<Mutation> in
                return .of(.gifs(giphy), .searchQuery(searchQuery))
            }
        case .modelSelected(let giphy):
            steps.accept(AppStep.relatedQueryIsPicked(giphy.title))
            return .empty()
        case .searchButtonClicked:
            steps.accept(AppStep.searchButtonIsClicked(currentState.searchQuery))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .gifs(let giphy):
            newState.gifs = giphy
        case .searchQuery(let query):
            newState.searchQuery = query
        }
        
        return newState
    }
}

extension RelatedQueryReactor {
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
