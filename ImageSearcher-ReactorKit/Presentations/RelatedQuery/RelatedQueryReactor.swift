//
//  RelatedQueryReactor.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/15.
//

import ReactorKit
import RxCocoa
import RxFlow

enum SearchType {
    case modelSelected(Giphy)
    case searchButtonClicked(String?)
}

class RelatedQueryReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    
    var disposeBag = DisposeBag()
    
    var outputTrigger = PublishRelay<SearchType>()
    var searchQuery = ""
    
    enum Action {
        case searchQuery(String)
        case selectedType(SearchType)
    }
    
    enum Mutation {
        case gifs([Giphy])
    }
    
    struct State {
        var gifs: [Giphy] = []
        var title: String?
    }
    
    let initialState: State = State()
}

extension RelatedQueryReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchQuery(let searchQuery):
            self.searchQuery = searchQuery
            return fetchGiphy(of: searchQuery).flatMap { giphy -> Observable<Mutation> in
                return .just(.gifs(giphy))
            }

        case .selectedType(let type):
            switch type {
            case .modelSelected(let giphy):
                outputTrigger.accept(.modelSelected(giphy))
                steps.accept(AppStep.relatedQueryIsPicked(giphy))
                return .empty()
            case .searchButtonClicked:
                steps.accept(AppStep.searchButtonIsClicked(searchQuery))
                
                return .empty()
            }
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
