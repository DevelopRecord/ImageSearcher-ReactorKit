//
//  AppStep.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/20.
//

import RxFlow

enum AppStep: Step {
    // Main
    case mainTabbarIsRequired
    
    // Home
    case homeIsRequired
    case homeDepthIsRequired
    
    // Search
    /// 최초화면 요구
    case induceboardIsRequired
    
    /// 네비게이션 바 검색 버튼 탭
    case relatedQueryViewIsRequired
    
    /// 연관검색어 선택
    case relatedQueryIsPicked(Giphy)
    
    /// 키보드 검색 버튼 클릭
    case searchButtonIsClicked(String?)
    
    /// Gif 아이템 선택
    case GifItemIsPicked(Giphy)
    
    /// 사파리 이동 버튼 클릭
    case safariUrlButtonIsClicked(String?)
    
    case dismiss
    
    case back
    
    // Setting
    /// 설정화면 진입
    case settingIsRequired
    /// 설정화면 한 단계 진입
    case settingDepthIsRequired
    /// 설정화면 알림 버튼
    case settingAlertIsRequired(message: String)
}
