//
//  AppStepper.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/20.
//

import RxCocoa
import RxFlow

struct AppStepper: Stepper {
    let steps: PublishRelay<Step> = .init()
    
    // 최초 앱이 실행되고 나서 보여줘야 할 스텝 정의
    var initialStep: Step {
        return AppStep.induceboardIsRequired
    }
    
//    func readyToEmitSteps() {
//        steps.accept(AppStep.induceboardIsRequired)
//    }
}
