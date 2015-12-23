import Alamofire
import CommonCrypto
import SwiftyJSON

// Request API key
let requestKey = "HZiB188uvsNHIWa"

// Name of the meta data in the serialized JSON dictionary
let dataRequestMetaName = "meta"

// Name of the values in the serialized JSON dictionary
let dataRequestValuesName = "values"

enum Service: String {
    case Labs = "labs"
    case DiskQuota = "quota"
    case Events = "events"
    case News = "news"
    case Directory = "directory"
}

typealias DataRequestCompletion = (JSON?, JSON?, NSError?)->()


let requestURL = "http://www.cs.utexas.edu/users/mad/utcs-app-backend/"
let requestPathCGI = "/cgi-bin/utcs.scgi"
let apiVersion = "1.0-alpha"
enum Router: URLRequestConvertible {
    static let baseURLString = Router.baseURL()
    case Labs()
    case Quota(username: String)
    case Directory()
    case Events()
    case News()


    var URLRequest: NSMutableURLRequest {
        let (service, argument): (String, String?) = {
            switch self {
            case Labs:
                return ("labs", nil)
            case Quota(let username):
                return ("quota", username)
            case Directory:
                return ("directory", nil)
            case Events:
                return ("events", nil)
            case News:
                return ("news", nil)
            }
        }()

        let URL = NSURL(string: Router.baseURLString)!
        // set header fields
        let digest = Router.createDigest(service, argument: argument)
        let request = NSMutableURLRequest(URL: URL)
        request.setValue("hmac ios:\(digest)", forHTTPHeaderField: "authentication")

        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(request, parameters: ["service": service, "arg": argument ?? ""]).0
    }

    static func baseURL() -> String {
        return "\(requestURL)\(apiVersion)\(requestPathCGI)"
    }

    static func createDigest(service: String, var argument: String?) -> String {
        argument = argument ?? ""
        return generateHMAC(requestKey, data: service + argument!)

    }

    private static func generateHMAC(key: String, data: String) -> String {

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
}
