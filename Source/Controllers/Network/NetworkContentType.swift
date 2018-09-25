import Foundation

public enum NetworkContentType {
    case json(body: JSON)
    case formURLEncoded(body: [String: String])
    case form(body: [String: String], boundary: String)
    case none
    
    public var httpHeaderValue: String {
        switch self {
        case .json:
            return "application/json"
        case .formURLEncoded:
            return "application/x-www-form-urlencoded"
        case let .form(_, boundary):
            return "multipart/form-data; boundary=\(boundary)"
        case .none:
            return ""
        }
    }
    
    public var body: Data? {
        switch self {
        case let .json(parameters):
            if parameters.isEmpty {
                return nil
            }
            
            return try? JSONSerialization.data(withJSONObject: parameters, options: [])
            
        case let .formURLEncoded(form):
            if form.isEmpty {
                return nil
            }
            
            return form.map({ "\($0)=\($1)" }).joined(separator: "&").data(using: .utf8)
            
        case let .form(form, boundary):
            if form.isEmpty {
                return nil
            }
            
            return MultiPartForm(form: form, boundary: boundary).body
        case .none:
            return nil
        }
    }
}

public struct MultiPartForm {
    private let form: [String: String]
    private let boundary: String
    
    public init(form: [String: String], boundary: String) {
        self.form = form
        self.boundary = boundary
    }
    
    public var body: Data {
        var body = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in form {
            body.append(string: boundaryPrefix)
            body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append(string: "\(value)\r\n")
        }
        
        body.append(string: "--".appending(boundary.appending("--")))
        
        return body
    }
}

public extension Data {
    public mutating func append(string: String) {
        if let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            append(data)
        }
    }
}
