
// Space between lines in the article text
let lineSpacing: CGFloat = 6.0

// Space between paragraphs in the article text
let paragraphSpacing: CGFloat  = 16.0;


final class NewsArticle: NSObject, NSCoding {
    var title: String!
    var url: NSURL!
    var date: NSDate!
    var html: String! {
        didSet(oldValue){
            configureNewsStoryWithHTML(html)
        }
    }
    var attributedContent: NSAttributedString!
    var headerImage: UIImage?
    var imageURLs: [NSURL]?

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        title = aDecoder.decodeObjectForKey("title") as! String
        url = aDecoder.decodeObjectForKey("url") as! NSURL
        date = aDecoder.decodeObjectForKey("date") as! NSDate
        html = aDecoder.decodeObjectForKey("html") as! String
        attributedContent = aDecoder.decodeObjectForKey("attributedContent") as! NSAttributedString
        headerImage = aDecoder.decodeObjectForKey("headerImage") as! UIImage
        imageURLs = aDecoder.decodeObjectForKey("imageURLs") as! [NSURL]?
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(url, forKey: "url")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(html, forKey: "html")
        aCoder.encodeObject(attributedContent, forKey: "attributedContent")
        aCoder.encodeObject(headerImage, forKey: "headerImage")
        aCoder.encodeObject(imageURLs, forKey: "imageURLs")
    }
    func configureNewsStoryWithHTML(html: String)   {
        guard html.characters.count > 0 else {
            return
        }
        var attributedHTML: NSMutableAttributedString?

        dispatch_sync(dispatch_get_main_queue()) { () -> Void in
            do {
            try attributedHTML = NSAttributedString(data: html.dataUsingEncoding(NSUTF32StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil).mutableCopy() as! NSMutableAttributedString
            } catch {
                print("failed to parse html")
            }
        }
        guard attributedHTML != nil else{
            return
        }

        let newAttributedContent = NSMutableAttributedString()
        attributedHTML!.enumerateAttributesInRange(NSMakeRange(0, attributedHTML!.length), options: .LongestEffectiveRangeNotRequired, usingBlock: { (attrs, range, stop) -> Void in
            if attrs[NSAttachmentAttributeName] == nil {
                let htmlFont = attrs[NSFontAttributeName] as! UIFont
                let fontDescriptorAttributes = htmlFont.fontDescriptor().fontAttributes()

                let fontDescriptor = UIFontDescriptor(fontAttributes: fontDescriptorAttributes)
                let font = UIFont(descriptor: fontDescriptor, size: 16.0)

                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = lineSpacing
                paragraphStyle.paragraphSpacing = paragraphSpacing

                attributedHTML?.addAttribute(NSFontAttributeName, value: font, range: range)
                attributedHTML?.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)

                newAttributedContent.appendAttributedString(attributedHTML!.attributedSubstringFromRange(range))
                newAttributedContent.mutableString.replaceOccurrencesOfString(" ", withString: " ", options: .LiteralSearch, range: NSMakeRange(0, newAttributedContent.mutableString.length))

            }
        })
        do {
         let regex = try NSRegularExpression(pattern: "((\n|\r){2,})", options: [])

        regex.replaceMatchesInString(newAttributedContent.mutableString, options: [], range: NSMakeRange(0, newAttributedContent.length), withTemplate: "")
        } catch {
            print("Regex failed")
        }
        attributedContent = newAttributedContent.attributedStringByTrimming(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}
