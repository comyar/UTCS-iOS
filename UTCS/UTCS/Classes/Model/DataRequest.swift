import Alamofire
import CommonCrypto
// Request URL
let requestURL = "http://www.cs.utexas.edu/users/mad/utcs-app-backend/"
let requestPathCGI = "/cgi-bin/utcs.scgi"
let apiVersion = "1.0-alpha"

// Request API key
let requestKey = "gwPtXjpDGgsKWyb8gLrq9OKVVa1dU2uE"

// Name of the meta data in the serialized JSON dictionary
let dataRequestMetaName = "meta";

// Name of the values in the serialized JSON dictionary
let dataRequestValuesName = "values";

enum Service: String {
    case Labs = "labs"
    case DiskQuota = "quota"
    case Events = "events"
    case News = "news"
    case Directory = "directory"
}

typealias DataRequestCompletion = ([NSObject: AnyObject], AnyObject, NSError?)->()

@objc class DataRequest: NSObject {
    class func sendDataRequestForService(service: String, argument: String?, completion: DataRequestCompletion){
        let requestURL = DataRequest.urlForService(service, argument: argument)

        let parameters: [String: String]? = {
            if argument == nil {
                return nil
            }
            else {
                return ["arg": argument!]
            }
        }()

        Alamofire.request(Alamofire.Method.GET, requestURL, parameters: parameters, encoding: Alamofire.ParameterEncoding.JSON, headers: nil).responseJSON { (_, _, JSON) -> Void in
                print(JSON)
        }

    }
    class func urlForService(service: String, argument: String?) -> String {
        let base = "\(requestURL)\(apiVersion)\(requestPathCGI)?key=\(requestKey)&service=\(service)"
        return base
        
    }
    class func createDigest(service: String, var argument: String?) -> String {
        argument = argument ?? ""
        return generateHMAC("HZiB188uvsNHIWa", data: service + argument!)
        
    }

    private class func generateHMAC(key: String, data: String) -> String {

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