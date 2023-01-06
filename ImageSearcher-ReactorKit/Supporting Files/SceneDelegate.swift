//
//  SceneDelegate.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/14.
//

import UIKit
import RxSwift
import RxFlow

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var disposeBag = DisposeBag()
    var window: UIWindow?
    private let coordinator: FlowCoordinator = .init()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        coordinatorLogStart() // 로그 확인 메서드
        
        coordinateToAppFlow(with: scene)
    }
    
    private func coordinateToAppFlow(with scene: UIWindowScene) {
        let window = UIWindow(windowScene: scene)
        self.window = window
        
//        let appFlow = AppFlow(with: window)
        let appFlow = MainFlow()
        let appStepper = AppStepper()
        
        coordinator.coordinate(flow: appFlow, with: appStepper)
        Flows.use(appFlow, when: .created) { [weak self] flowRoot in
            guard let self = self else { return }
            self.window?.rootViewController = flowRoot
        }
        
        window.makeKeyAndVisible()
    }
    
    private func coordinatorLogStart() {
        coordinator.rx.willNavigate
            .subscribe(onNext: { flow, step in
                let currentFlow = "\(flow)".split(separator: ".").last ?? "no flow"
                print("➡️ will navigate to flow = \(currentFlow) and step = \(step)")
            })
            .disposed(by: disposeBag)
        
        // didNavigate
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }


}

