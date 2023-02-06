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
    /// 홈화면 진입
    case homeIsRequired
    
    /// 홈화면 한 단계 진입
    case homeDepthIsRequired
    
    /// 홈화면 웹소켓(StarScream) 진입
    case starScreamWebSocketIsRequired
    
    /// 홈화면 웹소켓(RxStarScream) 진입
    case rxStarScreamWebSocketIsRequired
    
    /// 웹소켓 채팅 진입
    case webSocketChatIsRequired
    
    /// 세팅화면 이동
    case toSettingIsRequiredAgain
    
    // Search
    /// 검색유도 화면 진입
    case induceboardIsRequired
    
    /// 네비게이션 바 검색 버튼 탭
    case relatedQueryViewIsRequired
    
    /// 연관검색어 선택
    case relatedQueryIsPicked(String?)
    
    /// 키보드 검색 버튼 클릭
    case searchButtonIsClicked(String?)
    
    /// Gif 아이템 선택
    case GifItemIsPicked(Giphy)
    
    /// 사파리 이동 버튼 클릭
    case safariUrlButtonIsClicked(String?)
    
    // Setting
    /// 설정화면 진입
    case settingIsRequired
    
    /// 설정화면 한 단계 진입
    case settingDepthIsRequired
    
    /// 설정화면 알림 버튼
    case settingAlertIsRequired(message: String)
    
    // ETC
    case dismiss
    case back
}
