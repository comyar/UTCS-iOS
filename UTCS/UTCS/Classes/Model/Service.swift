import Foundation
public enum Service: String {
    case Labs = "labs"
    case DiskQuota = "quota"
    case Events = "events"
    case News = "news"
    case Directory = "directory"

    public static let allValues: [Service] = [.Labs, .DiskQuota, .Events, .News, .Directory]

    func cacheExpirationTime() -> NSTimeInterval{
        switch self {
        case .Labs:
            return 30
        case .DiskQuota:
            return 30
        case .Events:
            return 3600
        case .News:
            return 3600 * 24
        case .Directory:
            return 3600 * 24 * 7
        }
    }

    func cacheExpired(metadata: ServiceMetadata) -> Bool {
        let expiryTime = self.cacheExpirationTime()
        let expiryDate = metadata.updated.dateByAddingTimeInterval(expiryTime)
        return NSDate().compare(expiryDate) == .OrderedDescending
    }
}