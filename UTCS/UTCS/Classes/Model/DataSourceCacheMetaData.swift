class DataSourceCacheMetaData: NSObject, NSCoding {
    let service: Service
    let timestamp: NSDate
    required init?(coder aDecoder: NSCoder) {
        if let service = aDecoder.decodeObjectForKey("service") as? String,
            let timestamp = aDecoder.decodeObjectForKey("timestamp") as? NSDate {
                self.service = Service(rawValue: service)!
                self.timestamp = timestamp
                super.init()

        } else {
            service = .News
            timestamp = NSDate()
            super.init()
            return nil
        }
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(service.rawValue, forKey: "service")
        aCoder.encodeObject(timestamp, forKey: "timestamp")
    }
}
