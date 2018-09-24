import Foundation

public struct NetworkToken: Codable {
    public let access_token: String         //swiftlint:disable:this identifier_name
    public let expires_in: Int              //swiftlint:disable:this identifier_name
    public let token_type: String           //swiftlint:disable:this identifier_name
    public let scope: String?
    public let refresh_token: String        //swiftlint:disable:this identifier_name
    public let account_id: Int              //swiftlint:disable:this identifier_name
    public let account_username: String     //swiftlint:disable:this identifier_name
}
