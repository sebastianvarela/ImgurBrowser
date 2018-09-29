import Foundation
import Power
import ReactiveSwift
import Result

public protocol NetworkController {
    var connecting: MutableProperty<Bool> { get }
    var accessToken: MutableProperty<String?> { get }
    
    func execute<O, T: NetworkTask>(task: T) -> SignalProducer<O, NetworkError> where T.OutputType == O
}

public class DefaultNetworkController: NetworkController {
    private let session: URLSession
    private let environmentController: EnvironmentController
    private let queue = QueueScheduler(targeting: DispatchQueue(label: "net.s3ba.ImgurBrowser.NetworkController", qos: .background))
    
    public init(environmentController: EnvironmentController, session: URLSession = URLSession.shared) {
        self.session = session
        self.environmentController = environmentController
    }
    
    public let connecting = MutableProperty(false)
    public var accessToken = MutableProperty<String?>(nil)
    
    public func execute<O, T: NetworkTask>(task: T) -> SignalProducer<O, NetworkError> where T.OutputType == O {
        return SignalProducer { observer, lifetime in
            let url = self.environmentController.endpoint.appendingPathComponent(task.path)
            var urlRequest = URLRequest(url: url)
            if let body = task.contentType.body {
                urlRequest.setValue(task.contentType.httpHeaderValue, forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = body
            }
            urlRequest.httpMethod = task.method.rawValue
            if task.needAuth {
                if let token = self.accessToken.value {
                    urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                } else {
                    observer.send(error: .tokenMissing)
                    return
                }
            }

            lifetime += self.session.reactive
                .data(with: urlRequest)
                .start(on: self.queue)
                .onStarting { self.onStarting(task: task.description) }
                .onFailed { logError("\(task) fail with error: \($0)") }
                .onTerminated { self.onTerminated(task: task.description) }
                .startWithResult { result in
                    switch result {
                    case .success(let value):
                        if let response = value.1 as? HTTPURLResponse {
                            switch response.statusCode {
                            case 200:
                                if let model = try? JSONDecoder().decode(O.self, from: value.0) {
                                    observer.send(value: model)
                                    observer.sendCompleted()
                                } else {
                                    observer.send(error: .parseError)
                                }
                            default:
                                if let model = try? JSONDecoder().decode(Response<ImgurError>.self, from: value.0) {
                                    logError("Task failed with code \(response.statusCode): \(model.data)")
                                } else {
                                    logError("Task failed with code \(response.statusCode)")
                                }
                                observer.send(error: .badResponse)
                            }
                        } else {
                            observer.send(error: .internalError)
                        }
                        
                    case .failure(let error):
                        logError("Network error: \(error)")
                        observer.send(error: .requestError)
                    }
                }
        }
    }
    
    // # MARK: - Activity Indicator helpers:
    private var operationsInQueue = 0
    
    private func onStarting(task: String) {
        queue.schedule {
            self.operationsInQueue += 1
            
            logTrace("☢️ \(task) is starting 🔼 (Queue size: \(self.operationsInQueue))")
            
            if self.operationsInQueue >= 1 {
                self.connecting.swap(true)
            }
        }
    }
    
    private func onTerminated(task: String) {
        queue.schedule {
            self.operationsInQueue -= 1
            logTrace("☢️ \(task) finish! 🔽 (Queue size: \(self.operationsInQueue))")
            
            if self.operationsInQueue == 0 {
                self.connecting.swap(false)
            }
        }
    }
}
