import Foundation

public struct NetworkToken: Codable, Equatable {
    public let accessToken: String
    public let expiresIn: Int
    public let tokenType: String
    public let refreshToken: String
    public let accountId: Int
    public let accountUsername: String
    
    public init(accessToken: String, expiresIn: Int, tokenType: String, refreshToken: String, accountId: Int, accountUsername: String) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.tokenType = tokenType
        self.refreshToken = refreshToken
        self.accountId = accountId
        self.accountUsername = accountUsername
    }
    
    public enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case accountId = "account_id"
        case accountUsername = "account_username"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        accountId = try container.decode(Int.self, forKey: .accountId)
        accountUsername = try container.decode(String.self, forKey: .accountUsername)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(expiresIn, forKey: .expiresIn)
        try container.encode(tokenType, forKey: .tokenType)
        try container.encode(refreshToken, forKey: .refreshToken)
        try container.encode(accountId, forKey: .accountId)
        try container.encode(accountUsername, forKey: .accountUsername)
    }
}

public func == (lhs: NetworkToken, rhs: NetworkToken) -> Bool {
    return lhs.accessToken == rhs.accessToken &&
        lhs.expiresIn == rhs.expiresIn &&
        lhs.tokenType == rhs.tokenType &&
        lhs.refreshToken == rhs.refreshToken &&
        lhs.accountId == rhs.accountId &&
        lhs.accountUsername == rhs.accountUsername
}
