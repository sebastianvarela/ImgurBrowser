import Foundation
import ReactiveSwift
import Result

public protocol LoginView: View {
    func load(request: URLRequest)
}
