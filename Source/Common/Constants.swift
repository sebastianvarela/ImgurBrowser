import Foundation
import Power

public extension ConstantKey {
    // IMGUR API
    public static let ImgurApiScheme = ConstantKey("https")
    public static let ImgurApiHost = ConstantKey("api.imgur.com")
    public static let ImgurClientId = ConstantKey("8c40358e3837587")
    public static let ImgurClientSecret = ConstantKey("c5f0c21ef6222764d0b90a260a4cf6b799179501")
    public static let ImgurOauth2CallbackUrl = ConstantKey("https://s3ba.net/oauth/callback")
    
    // KEYCHAIN:
    public static let keychainService = ConstantKey("net.s3ba")
    public static let keychainUser = ConstantKey("user")
    
    // USER DEFAULTS:
    public static let userDefaultsNamespace = ConstantKey("net.s3ba")
}
