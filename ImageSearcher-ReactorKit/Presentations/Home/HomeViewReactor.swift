//
//  HomeViewReactor.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/14.
//

import RxSwift
import RxCocoa
import ReactorKit

class HomeViewReactor: Reactor {
    enum Action {
        // 뷰 로드시 데이터 요청트리거나 사용자 액션들
        case refreshControl
        case viewLoaded
    }
    
    enum Mutation {
        // 말그대로 변형. API 호출, 비동기 처리 등은 여기서.
        // TODO: 여기는 Side-Effect를 발생시켜선 안됨. 그럼 데이터를 어떻게 처리할까?
        case gifs([Giphy])
    }
    
    struct State {
        // 상태를 View로 방출.
        var gifs: [Giphy] = []
    }
    
    let initialState: State = State()
    
    var wroteQuery: String!
    
    init(wroteQuery: String?) {
        self.wroteQuery = wroteQuery
    }
}

extension HomeViewReactor {
    // mutate(), reduce() 등 과 같은 메서드 생성하여 데이터 변형 및 가공
    // TODO: transform()도 여기 해당되나? transform의 역할이 설명을 봐도 어떤 역할인지 명확한 이해가 안됨.
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refreshControl:
            return fetchGiphy(of: wroteQuery).flatMap { giphy -> Observable<Mutation> in
                return .just(.gifs(giphy))
            }
        case .viewLoaded:
            return fetchGiphy(of: wroteQuery).flatMap { giphy -> Observable<Mutation> in
                return .just(.gifs(giphy))
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

extension HomeViewReactor {
    // 여기에선 API 호출하는 메서드 생성
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
