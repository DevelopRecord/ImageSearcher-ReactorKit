//
//  ItemFlow.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/22.
//

import RxFlow

class ItemFlow: Flow {
    var root: RxFlow.Presentable {
        return self.rootViewController
    }
    
    let rootViewController = UIViewController()
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .relatedQueryIsPicked(let giphy):
            print("asdfasdf")
        case .itemViewInitialized:
            print("itemViewInitialized")
            return test()
        default: return .none
        }
        return .none
    }
    
    private func test() -> FlowContributors {
        let reactor = ItemViewReactor(wroteQuery: nil)
        let flow = ItemFlow()
        let controller = ItemViewController(reactor: reactor)
        
//        self.rootViewController.pushViewController(controller, animated: true)
        
        return .none
        
    }
}
