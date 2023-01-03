//
//  SceneDelegate.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/14.
//

import UIKit
import RxSwift
import RxFlow
// 1번 파람 값 굳이 설명 필요없음
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
        
        let appFlow = AppFlow(with: window)
        let appStepper = AppStepper()
        
        coordinator.coordinate(flow: appFlow, with: appStepper)
        
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

