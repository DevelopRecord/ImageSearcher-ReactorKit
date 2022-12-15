//
//  RelatedQueryReactor.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/15.
//

import ReactorKit
import RxCocoa

class RelatedQueryReactor: Reactor {
    var disposeBag = DisposeBag()
    
    enum Action {
        case searchQuery(String)
        case searchButtonClicked
    }
    
    enum Mutation {
        case gifs([Giphy])
        case selectedTitle(String)
    }
    
    struct State {
        var gifs: [Giphy] = []
        
    }
    
    let initialState: State = State()
}

extension RelatedQueryReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        var searchQuery = BehaviorRelay<String>(value: "")
        
        switch action {
        case .searchQuery(let query):
            print("ddd: \(query)")
            searchQuery.accept(query)
            return fetchGiphy(of: query).flatMap { giphy -> Observable<Mutation> in
                return .just(.gifs(giphy))
            }
        case .searchButtonClicked:
            return fetchGiphy(of: searchQuery.value).flatMap { giphy -> Observable<Mutation> in
                return .just(.gifs(giphy))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .gifs(let giphy):
            newState.gifs = giphy
        case .selectedTitle(let title):
            print("title: \(title)")
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
