//
//  TransmitView.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2023/02/02.
//

import UIKit
import RxSwift
import RxCocoa
import Starscream

class TransmitView: UIView {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    var authorRelay = BehaviorRelay<[AuthorInfo]>(value: [])
    private let userName: String
    private var socket: WebSocket?
    var naviTitle: String?
    
    var informationLabelText = BehaviorRelay<String>(value: "")
    
    lazy var emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(TransmitCell.self, forCellWithReuseIdentifier: TransmitCell.identifier)
    }
    
    lazy var transmitInfoView = TransmitInfoView()
    
    let emoji = ["😀", "😬", "😁", "😂", "😃", "😄", "😅", "😆", "😇", "😉", "😊", "🙂", "🙃", "☺️", "😋", "😌", "😍", "😘", "😗", "😙", "😚", "😜", "😝", "😛", "🤑", "🤓", "😎", "🤗", "😏", "😶", "😐", "😑", "😒", "🙄", "🤔", "😳", "😞", "😟", "😠", "😡", "😔", "😕", "🙁", "☹️", "😣", "😖", "😫", "😩", "😤", "😮", "😱", "😨", "😰", "😯", "😦", "😧", "😢", "😥", "😪", "😓", "😭", "😵", "😲", "🤐", "😷", "🤒", "🤕", "😴", "💩"]
    
    // MARK: - Deinit
    
    deinit {
        print("TransmitView Deinit")
    }
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        self.userName = UserDefaults.standard.string(forKey: "name") ?? ""
        super.init(frame: frame)
        setupWebSocket()
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
        emojiCollectionView.rx.itemSelected
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                if !self.transmitInfoView.transmitTextField.text!.isEmpty {
                    self.transmitInfoView.transmitTextField.text = ""
                }
            }).bind(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.informationLabelText.accept(self.emoji[indexPath.row])
            })
            .disposed(by: disposeBag)
                
        informationLabelText
            .subscribe(onNext: { [weak self] labelText in
                guard let self = self else { return }
                self.transmitInfoView.transmitButton.isEnabled = labelText.isEmpty ? false : true
            })
            .disposed(by: disposeBag)
        
        transmitInfoView.transmitButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.socket?.write(string: self.informationLabelText.value)
                self.informationLabelText.accept("")
                self.transmitInfoView.transmitTextField.text = ""
            })
            .disposed(by: disposeBag)
        
        transmitInfoView.transmitTextField.rx.text
            .orEmpty
            .bind(onNext: { [weak self] text in
                guard let self = self else { return }
                self.informationLabelText.accept(text)
            })
            .disposed(by: disposeBag)
        
        authorRelay
            .asObservable()
            .bind(to: transmitInfoView.conversationCollectionView.rx.items) { collectionView, row, info -> UICollectionViewCell in
                switch info.isEqual {
                case true:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConversationSentCell.identifier, for: IndexPath(row: row, section: 0)) as? ConversationSentCell else { return UICollectionViewCell() }
                    cell.setupRequest(info)
                    return cell
                case false:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConversationReceivedCell.identifier, for: IndexPath(item: row, section: 0)) as? ConversationReceivedCell else { return UICollectionViewCell() }
                    cell.setupRequest(info)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        transmitInfoView.isShowButton.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                UIView.transition(with: self.transmitInfoView.isShowButton, duration: 0.4,
                                  options: .curveEaseInOut,
                                  animations: {
                    print("bool: \(self.transmitInfoView.isShowButton.isSelected)")
                    self.emojiCollectionView.isHidden = self.transmitInfoView.isShowButton.isSelected
                })
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setup WebSocket
    
    private func setupWebSocket() {
        let url = URL(string: "ws://localhost:1337/")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    private func receivedMessage(senderName: String) {
        self.naviTitle = senderName
    }
}

extension TransmitView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emoji.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransmitCell.identifier, for: indexPath) as? TransmitCell else { return UICollectionViewCell() }
        cell.emojiLabel.text = emoji[indexPath.row]
        return cell
    }
    
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

extension TransmitView: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        switch event {
        case .connected(_):
            client.write(string: userName)
        case .disconnected(let reason, let code):
            print("웹소켓 연결 종료 - 이유: \(reason), 코드: \(code)")
        case .text(let text):
            guard let data = text.data(using: .utf16),
                  let jsonData = try? JSONSerialization.jsonObject(with: data),
                  let jsonDict = jsonData as? NSDictionary,
                  let messageType = jsonDict["type"] as? String else {
                return
            }
            
            if messageType == "message", // 메시지 전송하면 발생
               let messageData = jsonDict["data"] as? Dictionary<String, Any>,
               let messageAuthor = messageData["author"] as? String,
               let messageText = messageData["text"] as? String {
                let messageTime = messageData["time"] as? String
                let isEqual = messageAuthor == userName
                UserDefaults.standard.set(isEqual, forKey: "isEqual")
                self.receivedMessage(senderName: messageAuthor)
                
                let info: AuthorInfo = .init(author: messageAuthor, text: messageText, time: messageTime, isEqual: isEqual)
                var value = authorRelay.value
                value.append(info)
                
                authorRelay.accept(value)
            }
        case .binary(let data):
            print("데이터 받음: \(data.count)")
        case .pong(_):
            break
        case .ping(_):
            break
        case .error(let error):
            print("웹소켓 에러 발생: \(String(describing: error))")
            break
        case .viabilityChanged(let bool):
            print("viabilityChanged: \(bool)")
            break
        case .reconnectSuggested(let bool):
            print("reconnectSuggested: \(bool)")
            break
        case .cancelled:
            print("웹소켓 취소됨")
        }
    }
}

class TransmitCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TransmitCell"
    
    let emojiLabel = UILabel().then {
        $0.text = "😀"
        $0.font = .boldSystemFont(ofSize: 22)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 2.5
                layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupLayout() {
        contentView.backgroundColor = .systemGreen
        
        contentView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

struct AuthorInfo {
    var author: String?
    var text: String?
    var time: String?
    
    var isEqual: Bool
}
