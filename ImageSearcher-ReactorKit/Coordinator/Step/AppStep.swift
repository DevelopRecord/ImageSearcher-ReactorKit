//
//  AppStep.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/20.
//

import RxFlow

enum AppStep: Step {
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
}
