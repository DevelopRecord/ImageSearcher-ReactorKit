//
//  AppStep.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/20.
//

import RxFlow

enum AppStep: Step {
    // 최초화면 요구
    case induceboardIsRequired
    
    // 검색버튼 탭
    case relatedQueryViewIsRequired
    
    // 연관검색어 선택
    case relatedQueryIsPicked(Giphy)
    
    // 검색버튼 클릭
    case searchButtonIsClicked(String?)
    
    case GifItemIsPicked(Giphy)
}