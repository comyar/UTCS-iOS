import Foundation
import UIKit
import SwiftyJSON

// Space between lines in the article text
let lineSpacing: CGFloat = 6.0

// Space between paragraphs in the article text
let paragraphSpacing: CGFloat  = 16.0

final class NewsArticle: NSObject, NSCoding {
    var title: String!
    var url: NSURL!
    var date: NSDate!
    var html: String!
    var cleanedText: String!
    lazy var attributedContent: NSAttributedString? = self.initializeAttributedContent()
    var imageURLs: [NSURL]!

    private static let paragraphStyle: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.paragraphSpacing = paragraphSpacing
        return style
    }()

    private static let bodyFont: UIFont = {
        return UIFont.systemFontOfSize(16.0)
    }()
    private static let boldBodyFont: UIFont = {
        return UIFont.boldSystemFontOfSize(16.0)
    }()
    private static let italicBodyFont: UIFont = {
        return UIFont.italicSystemFontOfSize(16.0)
    }()

    init?(json: JSON) {
        super.init()
        guard let title = json["title"].string,
            let url = json["url"].URL,
            let dateString = json["date"].string,
            let date = serviceDateFormatter.dateFromString(dateString),
            let html = json["html"].string,
            let cleanedText = json["cleanedText"].string,
            let imageURLs = json["imageUrls"].array else {
                return nil
        }
        self.title = title
        self.url = url
        self.date = date
        self.html = html
        self.cleanedText = cleanedText
        self.imageURLs = imageURLs.map{$0.URL}.flatMap{$0}
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        guard let title = aDecoder.decodeObjectForKey("title") as? String,
            let url = aDecoder.decodeObjectForKey("url") as? NSURL,
            let date = aDecoder.decodeObjectForKey("date") as? NSDate,
            let html = aDecoder.decodeObjectForKey("html") as? String,
            let cleanedText = aDecoder.decodeObjectForKey("cleanedText") as? String else {
                return nil
        }
        self.title = title
        self.url = url
        self.date = date
        self.html = html
        self.cleanedText = cleanedText
        imageURLs = aDecoder.decodeObjectForKey("imageUrls") as? [NSURL] ?? []
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(url, forKey: "url")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(html, forKey: "html")
        aCoder.encodeObject(cleanedText, forKey: "cleanedText")
        aCoder.encodeObject(imageURLs, forKey: "imageUrls")
    }

    func initializeAttributedContent() -> NSAttributedString? {
        guard html.characters.count > 0 else {
            return nil
        }
        var attributedHTML: NSMutableAttributedString?

        do {
            try attributedHTML = NSAttributedString(data: self.html.dataUsingEncoding(NSUTF32StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil).mutableCopy() as? NSMutableAttributedString
        } catch {
            print("failed to parse html")
        }
        guard attributedHTML != nil else {
            return nil
        }

        let newAttributedContent = NSMutableAttributedString()
        attributedHTML!.enumerateAttributesInRange(NSRange(location: 0, length: attributedHTML!.length), options: .LongestEffectiveRangeNotRequired, usingBlock: { (attrs, range, stop) -> Void in
            if attrs[NSAttachmentAttributeName] != nil {
                //This is an image. Ignore.
                return
            }
            let htmlFont = attrs[NSFontAttributeName] as! UIFont
            let fontDescriptorAttributes = htmlFont.fontDescriptor().fontAttributes()

            if let fontName = fontDescriptorAttributes["NSFontNameAttribute"] as? String {
                let desiredFont = self.fontForName(fontName)
                attributedHTML?.addAttribute(NSFontAttributeName, value: desiredFont, range: range)
                attributedHTML?.addAttribute(NSParagraphStyleAttributeName, value: NewsArticle.paragraphStyle, range: range)
            }
            newAttributedContent.appendAttributedString(attributedHTML!.attributedSubstringFromRange(range))
            newAttributedContent.mutableString.replaceOccurrencesOfString(" ", withString: " ", options: .LiteralSearch, range: NSRange(location: 0, length: newAttributedContent.mutableString.length))

        })
        do {
         let regex = try NSRegularExpression(pattern: "((\n|\r){2,})", options: [])

        regex.replaceMatchesInString(newAttributedContent.mutableString, options: [], range: NSRange(location: 0, length: newAttributedContent.length), withTemplate: "")
        } catch {
            print("Regex failed")
        }
        return newAttributedContent.attributedStringByTrimming(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }

    private func fontForName(fontName: String) -> UIFont {
        let desiredFont: UIFont
        if fontName.containsString("Bold") {
            desiredFont = NewsArticle.boldBodyFont
        } else if fontName.containsString("Italic") {
            desiredFont = NewsArticle.italicBodyFont
        } else {
            desiredFont = NewsArticle.bodyFont
        }
        return desiredFont
    }

    override func isEqual(object: AnyObject?) -> Bool {
        if let asSelf = object as? NewsArticle {
            return asSelf.title == title
        }
        return false
    }

}