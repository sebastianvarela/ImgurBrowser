@testable import ImgurBrowser
import XCTest

public class NetworkTokenTests: XCTestCase {
    public func testParseFromJson() {
        let responseJson = "{\"access_token\":\"06dc289fbf6495b551456e6de2b0f593d11918a9\",\"expires_in\":315360000,\"token_type\":\"bearer\",\"scope\":\"\",\"refresh_token\":\"583d4580cb6e1c5fcca92a5c48f88713abeb262e\",\"account_id\":1535093,\"account_username\":\"SebastinVarelaBasconi\"}" //swiftlint:disable:this line_length
        
        if let responseData = responseJson.dataUTF8, let networkToken = try? JSONDecoder().decode(NetworkToken.self, from: responseData) {
            XCTAssertEqual(networkToken.accessToken, "06dc289fbf6495b551456e6de2b0f593d11918a9")
            XCTAssertEqual(networkToken.expiresIn, 315_360_000)
            XCTAssertEqual(networkToken.tokenType, "bearer")
            XCTAssertEqual(networkToken.refreshToken, "583d4580cb6e1c5fcca92a5c48f88713abeb262e")
            XCTAssertEqual(networkToken.accountId, 1_535_093)
            XCTAssertEqual(networkToken.accountUsername, "SebastinVarelaBasconi")
        } else {
            XCTFail("The model must be parsed")
        }
    }
    
    public func testEncodeDecode() {
        let networkToken = NetworkToken(accessToken: "wawawa", expiresIn: 123, tokenType: "bearer", refreshToken: "wewewe", accountId: 1, accountUsername: "Good")
        
        if let data = try? JSONEncoder().encode(networkToken) {
            let decodedNetworkToken = try? JSONDecoder().decode(NetworkToken.self, from: data)
            XCTAssertEqual(decodedNetworkToken, networkToken)
        } else {
            XCTFail("Could not encode model")
        }
    }
}
