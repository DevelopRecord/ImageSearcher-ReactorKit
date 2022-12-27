//
//  DetailFlow.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/26.
//

import RxFlow

class DetailFlow: Flow {
    var root: RxFlow.Presentable {
        return rootViewController
    }
    
    private let rootViewController = UINavigationController()
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .safariUrlButtonIsClicked(let urlString):
            print("URL STRING: \(urlString)")
            return .none
        default:
            print("asdfasdf")
            return .none
        }
    }
    
    
}
