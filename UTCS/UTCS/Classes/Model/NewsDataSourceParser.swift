import SwiftyJSON

class NewsDataSourceParser: NSObject, DataSourceParser {

    func parseValues(values: JSON) -> AnyObject? {
        return parseValues(values)
    }

    func parseValues(values: JSON) -> [NewsArticle]? {
        if let jsonValues = values.array {
            let articles = jsonValues.map{ NewsArticle(json: $0)
                }.flatMap{$0}
            return articles
        }
        return nil
    }


}
