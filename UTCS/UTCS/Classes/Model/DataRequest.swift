import Alamofire

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
}