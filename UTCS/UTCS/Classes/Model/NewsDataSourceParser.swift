import SwiftyJSON

class NewsDataSourceParser: DataSourceParser {

    func parseValues(values: JSON) -> AnyObject? {
        if let jsonValues = values.array {
            let articles = jsonValues.map{ NewsArticle(json: $0)
            }.flatMap{$0}
            return articles
        }
        return nil
    }


}
