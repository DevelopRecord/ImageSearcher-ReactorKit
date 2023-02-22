//
//  Extension+.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/15.
//

import UIKit

import RxSwift
import RxCocoa

extension UIViewController {

    /// 네비게이션바 설정 함수
    func setupNavigationBar(title: String? = nil, isLargeTitle: Bool? = nil, searchController: UISearchController? = nil, searchBar: UISearchBar? = nil) {
        navigationItem.title = title
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.prefersLargeTitles = isLargeTitle ?? false
        navigationItem.searchController = searchController
        navigationItem.titleView = searchBar
    }
}

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}

extension UISearchBar {

    /// 키보드 툴바
    func setupKeyboardToolbar() {
        let screenWidth = UIScreen.main.bounds.width
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: screenWidth, height: 50))
        toolbar.barStyle = .default
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        lazy var doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.sizeToFit()
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        inputAccessoryView = toolbar
    }
    
    @objc private func dismissKeyboard() {
        resignFirstResponder()
    }
}

extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        print("화면 배율: \(UIScreen.main.scale)")// 배수
        print("origin: \(self), resize: \(renderImage)")
        
        return renderImage
    }
}

public extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}

extension TimeInterval {
    func timeStampConverter() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "KST")
        let date = Date(timeIntervalSince1970: self)
        
        return formatter.string(from: date)
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
