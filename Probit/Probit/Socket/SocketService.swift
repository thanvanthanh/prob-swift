//
import Foundation
import Starscream

protocol SocketServiceDelegate: AnyObject {
    func onSocketConnected()
    func onSocketDisconnected(_ reason: String, code: UInt16)
    func onSocketError(error: Error?)
    func onSocketReciever(text: String)
    func onSocketReciever(data: Data)
    func onSocketCancelled()
    func onPing()
    func onPong()
    func reconnectSuggested( _ suggest: Bool)
    func viabilityChanged(_ viability: Bool)

}

extension SocketServiceDelegate {
    func onSocketConnected() {}
    func onSocketReciever(data: Data) {}
    func onSocketDisconnected(_ reason: String, code: UInt16) {}
    func onSocketError(error: Error?) {}
    func onSocketCancelled(){}
    func reconnectSuggested(_ suggest: Bool) {}
    func viabilityChanged(_ viability: Bool) {}
    func onPing() {}
    func onPong() {}
}

class SocketService {
    
    private var socket: WebSocket
    private var timeoutInterval: TimeInterval = 5
    private var socketQueue: DispatchQueue = DispatchQueue(label: "PROBIT_SOCKET_QUEUE", qos: .background)
    private var isConnected: Bool = false
    private var TAG: String = "SOCKET_SERVICE:"
    private var id = UUID()
    private weak var delegate: SocketServiceDelegate?
    
    init() {
        let request = URLRequest(url: URL(string: Configs.share.env.socketBaseURL)!)
        socket = WebSocket(request: request)
        socket.callbackQueue = socketQueue
        socket.delegate = self
    }
    
    func connect() {
        DispatchQueue.global(qos: .background).async {
            self.socket.connect()
        }
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func reconnect() {
        guard !isConnected else { return }
        self.connect()
    }
    
    func set(delegate: SocketServiceDelegate) {
        self.delegate = delegate
    }
    
    func remove() {
        self.delegate = nil
    }
    
    func authorization() {
        guard let token = AppConstant.accessToken else { return }
        let request = SocketRequestMessage.Builder()
            .setType(SocketType.authorization.rawValue)
            .setToken(token)
            .build()
        socket.write(string: JSONSerializer.toJson(request))
    }
    
    func subcribe(channel: SocketChannel, filter: [String]) {
        let request = SocketRequestMessage.Builder()
            .setType(SocketType.subscribe.rawValue)
            .setChannel(channel.rawValue)
            .setFilter(filter)
            .build()
        socket.write(string: JSONSerializer.toJson(request))
    }
    
    func subcribeMarketId(channel: SocketChannel, filter: [String], marketId: String) {
        let request = SocketRequestMessage.Builder()
            .setType(SocketType.subscribe.rawValue)
            .setChannel(channel.rawValue)
            .setFilter(filter)
            .setMarketID(marketId)
            .build()
        socket.write(string: JSONSerializer.toJson(request))
    }
    
    func unsubscribe(channel: SocketChannel) {
        let request = SocketRequestMessage.Builder()
            .setType(SocketType.unsubscribe.rawValue)
            .setChannel(channel.rawValue)
            .build()
        socket.write(string: JSONSerializer.toJson(request))
    }
    
}

extension SocketService: WebSocketDelegate {
    
    private func log(message: String) {
        print(TAG, message)
    }
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        switch event {
        case .connected(_):
            self.isConnected = true
            self.delegate?.onSocketConnected()
        case .disconnected(let reason, let code):
            self.isConnected = false
            self.delegate?.onSocketDisconnected(reason, code: code)
        case .text(let text):
            self.delegate?.onSocketReciever(text: text)
        case .binary(let data):
            self.delegate?.onSocketReciever(data: data)
        case .pong(_):
            self.delegate?.onPong()
        case .ping(_):
            self.delegate?.onPing()
        case .error(let error):
            self.isConnected = false
            log(message: error?.localizedDescription ?? "")
            self.delegate?.onSocketError(error: error)
        case .cancelled:
            log(message: "onCancelled")
            self.isConnected = false
            self.delegate?.onSocketCancelled()
        case .reconnectSuggested(let suggest):
            self.delegate?.reconnectSuggested(suggest)
            if suggest {
                self.connect()
            }
        case .viabilityChanged(let viability):
            self.delegate?.viabilityChanged(viability)
        }
    }
}
