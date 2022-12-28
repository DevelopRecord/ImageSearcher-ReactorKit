//
//  DetailFlow.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/26.
//

import RxFlow
import SafariServices

class DetailFlow: Flow {
    var root: RxFlow.Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .safariUrlButtonIsClicked(let urlString):
            return coordinateToSafariView(with: urlString)
        default: return .none
        }
    }
    
    private func coordinateToSafariView(with urlString: String?) -> RxFlow.FlowContributors {
        guard let urlString = urlString, let url = URL(string: urlString) else { return .none }
        let safariViewController = SFSafariViewController(url: url)
        InduceFlow.rootViewController.dismiss(animated: true) {
            InduceFlow.rootViewController.present(safariViewController, animated: true)
        }
        
        return .none
    }
}
