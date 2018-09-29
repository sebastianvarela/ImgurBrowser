import Foundation
import ReactiveSwift
import Result

public protocol HomeView: View {
    func enableEditMode()
    func disableEditMode()
    func showImagePicker()
}
