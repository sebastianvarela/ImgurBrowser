import Foundation
import Power
import UIKit

public extension UIColor {
    // TEXTS:
    public static var imgurBrowserGreenText: UIColor {
        return fromHex("34B233")
    }
    
    public static var imgurBrowserGreenHighlightedText: UIColor {
        return fromHex("149203")
    }
    
    public static var imgurBrowserGreenDisabledText: UIColor {
        return imgurBrowserGreenText.withAlphaComponent(0.7)
    }
    
    public static var imgurBrowserFucsiaText: UIColor {
        return fromHex("e32592")
    }

    public static var imgurBrowserBlackText: UIColor {
        return fromHex("000000")
    }
    
    public static var imgurBrowserWhiteText: UIColor {
        return fromHex("FFFFFF")
    }
    
    public static var imgurBrowserWhiteHighlightedText: UIColor {
        return fromHex("DDDDDD")
    }
    
    public static var imgurBrowserWhiteDisabledText: UIColor {
        return imgurBrowserWhiteText.withAlphaComponent(0.7)
    }
    
    public static var imgurBrowserGrayText: UIColor {
        return fromHex("58585A")
    }
    
    public static var imgurBrowserMediumGrayText: UIColor {
        return fromHex("939597")
    }
    
    public static var imgurBrowserLightGrayText: UIColor {
        return fromHex("E0E1DD")
    }

    // LINE:

    public static var imgurBrowserLightGreenLine: UIColor {
        return fromHex("BAE3B9")
    }
    
    public static var imgurBrowserGreenLine: UIColor {
        return fromHex("34B233")
    }
    
    public static var imgurBrowserGreenHighlightedLine: UIColor {
        return fromHex("CBE9CB")
    }
    
    public static var imgurBrowserFucsiaLine: UIColor {
        return fromHex("E32592")
    }
    
    public static var imgurBrowserPurpleLine: UIColor {
        return fromHex("FF2096")
    }
    
    public static var imgurBrowserGrayLine: UIColor {
        return fromHex("DCDBDB")
    }
    
    // BACKGROUNDS:
    
    public static var imgurBrowserRedBackground: UIColor {
        return fromHex("db2a21")
    }

    public static var imgurBrowserGreenBackground: UIColor {
        return fromHex("34B233")
    }
    
    public static var imgurBrowserLightGreenBackground: UIColor {
        return fromHex("BAE3B9")
    }
    
    public static var imgurBrowserYellowBackground: UIColor {
        return fromHex("FAE700")
    }
    
    public static var imgurBrowserWhiteBackground: UIColor {
        return fromHex("FFFFFF")
    }
    
    public static var imgurBrowserWhiteHighlightedBackground: UIColor {
        return fromHex("F5F5F5")
    }
    
    public static var imgurBrowserGrayBackground: UIColor {
        return fromHex("58585A")
    }
    
    public static var imgurBrowserLightGrayBackground: UIColor {
        return fromHex("F1F1F1")
    }
    
    public static var imgurBrowserVeryLightGrayBackground: UIColor {
        return fromHex("F3F3F3")
    }
    
    public static var imgurBrowserDarkGrayBackground: UIColor {
        return fromHex("353535")
    }
    
    // BORDERS:
    
    public static var imgurBrowserLightGrayBorder: UIColor {
        return fromHex("E0E1DD")
    }
}
