import Cartography
import Foundation
import Power
import UIKit

public struct ToastAlert {
    public static let toastDuration: Double = 5
    public static let topMargin: CGFloat = 16
    public static let lateralMargin: CGFloat = 20
    
    public let level: ToastAlertLevel
    public let title: String?
    public let message: String
    public let persistent: Bool
    public var toastHeight: CGFloat {
        return title != nil ? 150 : 60
    }
    
    public init(level: ToastAlertLevel, message: String, persistent: Bool = false) {
        self.level = level
        self.title = nil
        self.message = message
        self.persistent = persistent
    }
    
    public init(level: ToastAlertLevel, title: String, message: String, persistent: Bool = false) {
        self.level = level
        self.title = title
        self.message = message
        self.persistent = persistent
    }
    
    public var alertColor: UIColor {
        switch level {
        case .info: return UIColor.fromHex("#34B233")
        case .warning: return UIColor.fromHex("#FAE700")
        case .error: return UIColor.fromHex("#db2a21")
        }
    }
    
    public func buildToastAlertView() -> ToastAlertView {
        var titleLabel: UILabel?
        if let title = title {
            let label = UILabel(frame: CGRect.zero)
            label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize + 2)
            label.text = title
            label.numberOfLines = 1
            label.textColor = .white
            
            titleLabel = label
        }
        
        let textLabel = UILabel(frame: CGRect.zero)
        textLabel.text = message
        textLabel.numberOfLines = 2
        textLabel.textColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textLabel].compactMap { $0 })
        stackView.axis = .vertical
        
        let alertContainer = ToastAlertView(frame: CGRect.zero)
        
        alertContainer.backgroundColor = alertColor
        alertContainer.addSubview(stackView)
        let minStackViewHeight: CGFloat = 41
        constrain(stackView, alertContainer) { stack, container in
            stack.top == container.top + 8
            stack.bottom == container.bottom - 8
            stack.trailing == container.trailing - ToastAlert.lateralMargin
            stack.leading == container.leading + ToastAlert.lateralMargin
            stack.height >= minStackViewHeight
        }
        alertContainer.setNeedsDisplay()
        
        return alertContainer
    }
}

public enum ToastAlertLevel {
    case info, warning, error
}

public class ToastAlertView: UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.5
        layer.cornerRadius = 3.0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
