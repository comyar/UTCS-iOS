import Foundation
import CommonCrypto

func generateHMAC(key: String, data: String) -> String {

    var result: [CUnsignedChar]
    let cKey = key.cStringUsingEncoding(NSUTF8StringEncoding)!
    let cData = data.cStringUsingEncoding(NSUTF8StringEncoding)!

    let algo  = CCHmacAlgorithm(kCCHmacAlgSHA1)
    result = Array(count: Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)

    CCHmac(algo, cKey, cKey.count-1, cData, cData.count-1, &result)

    let hash = NSMutableString()
    for val in result {
        hash.appendFormat("%02hhx", val)
    }

    return hash as String
}