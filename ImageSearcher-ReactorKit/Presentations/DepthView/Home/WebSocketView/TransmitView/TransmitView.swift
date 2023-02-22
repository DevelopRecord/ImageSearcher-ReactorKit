//
//  TransmitView.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2023/02/02.
//

import UIKit
import RxSwift
import RxCocoa

class TransmitView: UIView {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    lazy var emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.delegate = self
        $0.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
    }
    
    lazy var transmitInfoView = TransmitInfoView()
    
    let emoji = BehaviorRelay<[String]>(value: ["😀", "😬", "😁", "😂", "😃", "😄", "😅", "😆", "😇", "😉", "😊", "🙂", "🙃", "☺️", "😋", "😌", "😍", "😘", "😗", "😙", "😚", "😜", "😝", "😛", "🤑", "🤓", "😎", "🤗", "😏", "😶", "😐", "😑", "😒", "🙄", "🤔", "😳", "😞", "😟", "😠", "😡", "😔", "😕", "🙁", "☹️", "😣", "😖", "😫", "😩", "😤", "😮", "😱", "😨", "😰", "😯", "😦", "😧", "😢", "😥", "😪", "😓", "😭", "😵", "😲", "🤐", "😷", "🤒", "🤕", "😴", "💩"])
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupLayout() {
        addSubviews([transmitInfoView, emojiCollectionView])
        transmitInfoView.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.size.height * 0.6)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        emojiCollectionView.snp.makeConstraints {
            $0.top.equalTo(transmitInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Bind
    
    private func bindData() {
        transmitInfoView.isShowButton.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 1, options: []) {
                    self.transmitInfoView.setupIsShowButton()
                    let isSelected = self.transmitInfoView.isShowButton.isSelected
                    self.emojiCollectionView.isHidden = isSelected
                    
                    if isSelected {
                        self.transmitInfoView.snp.updateConstraints {
                            $0.height.equalTo(UIScreen.main.bounds.size.height - 80 - self.safeAreaHeightOfBottom())
                            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
                            $0.leading.trailing.equalToSuperview()
                        }
                        
                        self.emojiCollectionView.snp.remakeConstraints {
                            $0.height.equalTo(0)
                        }
                        self.layoutIfNeeded()
                    } else {
                        self.transmitInfoView.snp.updateConstraints {
                            $0.height.equalTo(UIScreen.main.bounds.size.height * 0.6)
                            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
                            $0.leading.trailing.equalToSuperview()
                        }
                        
                        self.emojiCollectionView.snp.remakeConstraints {
                            $0.top.equalTo(self.transmitInfoView.snp.bottom)
                            $0.leading.trailing.equalToSuperview()
                            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func safeAreaHeightOfBottom() -> CGFloat {
        guard let window = UIApplication.shared.windows.first else { return 0 }
        return window.safeAreaInsets.bottom
    }
}

extension TransmitView {
    func bind(reactor: TransmitViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: TransmitViewReactor) {
        transmitInfoView.transmitTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { text in
                self.transmitInfoView.transmitButton.isEnabled = !text.isEmpty
                return TransmitViewReactor.Action.transmitTextFieldText(text)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        transmitInfoView.transmitButton.rx.tap
            .map { _ in
                defer { self.transmitInfoView.transmitTextField.text = "" }
                return TransmitViewReactor.Action.transmitButtonTapped
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emojiCollectionView.rx.modelSelected(String.self)
            .map { TransmitViewReactor.Action.emojiSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: TransmitViewReactor) {
        reactor.state
            .compactMap { $0.authorInfos }
            .bind(to: transmitInfoView.conversationCollectionView.rx.items) { [weak self] collectionView, row, info -> UICollectionViewCell in
                guard let self = self else { return UICollectionViewCell() }
                switch info.isEqual {
                case true:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConversationSentCell.identifier, for: IndexPath(row: row, section: 0)) as? ConversationSentCell else { return UICollectionViewCell() }
                    cell.setupRequest(info)
                    self.transmitInfoView.conversationCollectionView.scrollToItem(at: IndexPath(row: reactor.authorRelay.value.count - 1, section: 0), at: .bottom, animated: false)
                    return cell
                case false:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConversationReceivedCell.identifier, for: IndexPath(row: row, section: 0)) as? ConversationReceivedCell else { return UICollectionViewCell() }
                    cell.setupRequest(info)
                    self.transmitInfoView.conversationCollectionView.scrollToItem(at: IndexPath(row: reactor.authorRelay.value.count - 1, section: 0), at: .bottom, animated: false)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        emoji
            .bind(to: emojiCollectionView.rx.items(cellIdentifier: EmojiCell.identifier, cellType: EmojiCell.self)) { _, emoji, cell in
                cell.emojiLabel.text = emoji
            }
            .disposed(by: disposeBag)
    }
}

extension TransmitView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = bounds.width / 7 - 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
