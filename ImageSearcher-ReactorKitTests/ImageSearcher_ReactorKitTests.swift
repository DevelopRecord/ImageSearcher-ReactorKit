//
//  ImageSearcher_ReactorKitTests.swift
//  ImageSearcher-ReactorKitTests
//
//  Created by 이재혁 on 2022/12/26.
//

import XCTest
@testable import ImageSearcher_ReactorKit

final class ImageSearcher_ReactorKitTests: XCTestCase {

    func testAction_refresh() {
        // 1. stub reactor 준비
        let reactor = ItemViewReactor(wroteQuery: nil)
        reactor.isStubEnabled = true
        
        // 2. view의 stub reactor 준비
        let controller = ItemViewController(reactor: reactor)
        
        // 3. user interaction 전송
        controller.subView.refreshControl.sendActions(for: .valueChanged)
        
        // 4. assert actions
//        XCTAssertEqual(reactor.stub.actions.last, .refreshControl)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // 테스트 코드 시작 전 실행 (값을 세팅하는 부분)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // setUp과 반대로 모든 테스트코드가 실행된 후에 호출 (setUp에서 설정한 값들을 해제할 때 사용)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        // 테스트 코드를 작성하는 메인 코드 (이 부분은 삭제하고 새롭게 생성하여 사용)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        // 성능을 측정해보기 위해 사용하는 것
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
