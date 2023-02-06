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
    
    private let userName: String
    private var socket: WebSocket?
    var naviTitle: String?
    
    var informationLabelText = BehaviorRelay<String>(value: "")
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(TransmitCell.self, forCellWithReuseIdentifier: TransmitCell.identifier)
    }
    
    lazy var transmitInfoView = TransmitInfoView()
    
    let emoji = ["😀", "😬", "😁", "😂", "😃", "😄", "😅", "😆", "😇", "😉", "😊", "🙂", "🙃", "☺️", "😋", "😌", "😍", "😘", "😗", "😙", "😚", "😜", "😝", "😛", "🤑", "🤓", "😎", "🤗", "😏", "😶", "😐", "😑", "😒", "🙄", "🤔", "😳", "😞", "😟", "😠", "😡", "😔", "😕", "🙁", "☹️", "😣", "😖", "😫", "😩", "😤", "😮", "😱", "😨", "😰", "😯", "😦", "😧", "😢", "😥", "😪", "😓", "😭", "😵", "😲", "🤐", "😷", "🤒", "🤕", "😴", "💩"]
    
    // MARK: - Lifecycle
    
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
        addSubviews([transmitInfoView, collectionView])
        transmitInfoView.snp.makeConstraints {
            $0.height.equalTo(200)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(transmitInfoView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    private func bindData() {
        collectionView.rx.itemSelected
            .do(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                if !self.transmitInfoView.transmitTextField.text!.isEmpty {
                    self.transmitInfoView.transmitTextField.text = ""
                }
            })
            .bind(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.informationLabelText.accept(self.emoji[indexPath.row])
//                $0.0.transmitInfoView.transmitInfoLabel.text = $0.0.emoji[$0.1.row]
            })
            .disposed(by: disposeBag)
        
        informationLabelText
            .subscribe(onNext: { [weak self] labelText in
                guard let self = self else { return }
                print("labelText: \(labelText)")
                self.transmitInfoView.transmitButton.isEnabled = labelText.isEmpty ? false : true
                self.transmitInfoView.transmitInfoLabel.text = labelText
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
//                $0.0.transmitInfoView.transmitInfoLabel.text = $0.1
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
    
    private func receivedMessage(_ message: String, senderName: String) {
        self.naviTitle = senderName
        transmitInfoView.transmitInfoLabel.text = message
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
        case .connected(let headers):
            client.write(string: userName)
            print("웹소켓 연결됨: \(headers)")
        case .disconnected(let reason, let code):
            print("웹소켓 연결 종료 - 이유: \(reason), 코드: \(code)")
        case .text(let text):
            print(".text: \(text)")
            guard let data = text.data(using: .utf16),
                  let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
                  let jsonDict = jsonData as? NSDictionary,
                  let messageType = jsonDict["type"] as? String else {
                return
            }
            
            if messageType == "message",
               let messageData = jsonDict["data"] as? NSDictionary,
               let messageAuthor = messageData["author"] as? String,
               let messageText = messageData["text"] as? String {
                self.receivedMessage(messageText, senderName: messageAuthor)
            }
        case .binary(let data):
            print("데이터 받음: \(data.count)")
        case .pong(let pong):
            print("pong 도착: \(pong)")
            break
        case .ping(let ping):
//            print("ping 보냄: \(ping)")
            break
        case .error(let error):
            print("웹소켓 에러 발생: \(error)")
        case .viabilityChanged(let bool):
            break
        case .reconnectSuggested(let bool):
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
