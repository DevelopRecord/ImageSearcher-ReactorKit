//
//  HomeStepper.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/29.
//

import RxFlow
import RxCocoa

struct HomeStepper: Stepper {
    static let shared = HomeStepper()
    
    let steps = PublishRelay<Step>()
    
    var initialStep: Step {
        return AppStep.homeIsRequired
    }
}
