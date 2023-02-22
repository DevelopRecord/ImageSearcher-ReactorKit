//
//  TransmitViewReactor.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2023/02/15.
//

import RxCocoa
import ReactorKit
import Starscream

class TransmitViewReactor: Reactor {
    var disposeBag = DisposeBag()
    var socket: WebSocket?
    var authorRelay = BehaviorRelay<[AuthorInfo]>(value: [])
    
    enum Action {
        case viewDidLoad
        case viewWillDisappear
        case transmitTextFieldText(String)
        case transmitButtonTapped
        case emojiSelected(String)
    }
    
    enum Mutation {
        case authorInfos([AuthorInfo])
        case inputText(String)
    }
    
    struct State {
        var authorInfos = [AuthorInfo]()
        var inputText: String = ""
    }
    
    let initialState = State()
}

extension TransmitViewReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return Observable.merge(mutation, authorRelay.map { .authorInfos($0) })
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            setupWebSocket()
            return .empty()
        case .viewWillDisappear:
            socket?.disconnect()
            socket?.delegate = nil
            return .empty()
        case .transmitButtonTapped:
            socket?.write(string: currentState.inputText)
            return .empty()
        case .transmitTextFieldText(let text):
            return .just(.inputText(text))
        case .emojiSelected(let emoji):
            socket?.write(string: emoji)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .authorInfos(let info):
            newState.authorInfos = info
        case .inputText(let text):
            newState.inputText = text
        }
        return newState
    }
    
    private func setupWebSocket() {
        let url = URL(string: "ws://localhost:1337/")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
}

extension TransmitViewReactor: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        switch event {
        case .connected(_):
            client.write(string: UserDefaults.standard.string(forKey: "name") ?? "") // 닉네임 설정
        case .text(let text):
            convertText(text: text)
        case .error(let error):
            print("ERR: \(error?.localizedDescription ?? "")")
        default: break
        }
    }
    
    func convertText(text: String) {
        guard let data = text.data(using: .utf16),
              let jsonDict = try? JSONSerialization.jsonObject(with: data) as? NSDictionary,
              let messageType = jsonDict["type"] as? String else { return }
        
        if messageType == "message", // 수신, 발신
           let messageData = jsonDict["data"] as? Dictionary<String, Any>,
           let messageAuthor = messageData["author"] as? String,
           let messageText = messageData["text"] as? String,
           let messageTime = messageData["time"] as? TimeInterval {
            let isEqual = messageAuthor == UserDefaults.standard.string(forKey: "name")
            let info = AuthorInfo(author: messageAuthor, text: messageText, time: messageTime, isEqual: isEqual)
            var value = authorRelay.value
            value.append(info)
            authorRelay.accept(value)
        }
    }
}
// 클라이언트 - 클라이언트(서버)
