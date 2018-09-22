import Foundation

public protocol Presenter: class {
    func viewDidLoad()
    
    func viewWillAppear(animated: Bool)
    func viewDidAppear(animated: Bool)
    func viewWillDisappear(animated: Bool)
    func viewDidDisappear(animated: Bool)
    
    func didReceiveMemoryWarning()
    
    var shouldHideBackTitle: Bool { get }
}

public extension Presenter {
    public func viewDidLoad() {}
    
    public func viewWillAppear(animated: Bool) {}
    public func viewDidAppear(animated: Bool) {}
    public func viewWillDisappear(animated: Bool) {}
    public func viewDidDisappear(animated: Bool) {}
    
    public func didReceiveMemoryWarning() {}
    
    public var shouldHideBackTitle: Bool { return true }
}
