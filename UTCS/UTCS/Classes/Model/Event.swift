import Foundation
import SwiftyJSON

class Event: NSObject, NSCoding {
    enum Category: String {
        case All = "all"
        case Careers = "careers"
        case Talks = "talks"
        case Orgs = "orgs"
    }

    var name: String!
    var contactName: String?
    var contactEmail: String?
    var location: String!
    var descriptionText: String? {
        didSet(oldValue) {
            updateAttributedDescription()
        }
    }
    var attributedDescription: NSAttributedString?
    var type: Category!
    var startDate: NSDate!
    var endDate: NSDate!
    var food: Bool!
    var id: String!
    var allDay: Bool!
    var link: NSURL?
    init?(json: JSON) {
        name = json["name"].string
        contactName = json["contactname"].string
        contactEmail = json["contactemail"].string
        allDay = json["allday"].bool!
        location = json["location"].string
        descriptionText = json["description"].string
        startDate = serviceDateFormatter.dateFromString(json["startdate"].string!)
        if let enddate = json["enddate"].string {
            endDate = serviceDateFormatter.dateFromString(enddate)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        guard let name = aDecoder.decodeObjectForKey("name") as? String,
               let location = aDecoder.decodeObjectForKey("location") as? String,
               let startDate = aDecoder.decodeObjectForKey("startDate") as? NSDate,
               let endDate = aDecoder.decodeObjectForKey("endDate") as? NSDate,
               let id = aDecoder.decodeObjectForKey("id") as? String
               else {
                return nil
        }
        self.name = name
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.id = id
        self.allDay = aDecoder.decodeBoolForKey("food")

        contactEmail = aDecoder.decodeObjectForKey("contactEmail") as? String
        contactName = aDecoder.decodeObjectForKey("contactName") as? String
        food = aDecoder.decodeBoolForKey("food")

    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(allDay, forKey: "allDay")
        aCoder.encodeBool(food, forKey: "food")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(contactName, forKey: "contactName")
        aCoder.encodeObject(location, forKey: "location")
        aCoder.encodeObject(descriptionText, forKey: "descriptionText")
        aCoder.encodeObject(attributedDescription, forKey: "attributedDescription")

    }

    private func updateAttributedDescription() {
        guard let text = descriptionText else {
            return
        }
        attributedDescription = NSAttributedString(string: text)
    }
}
/*


// Space between lines in the article text
static const CGFloat lineSpacing                    = 6.0;

// Space between paragraphs in the article text
static const CGFloat paragraphSpacing               = 16.0;

// Amount to increase the parsed font size of articles
static const CGFloat fontSizeModifier               = 1.5;



#pragma mark Setters

- (void)setDescription:(NSString *)description
{
    _eventDescription = description;
    [self setAttributedDescriptionWithHTML:_eventDescription];
}

- (void)setAttributedDescriptionWithHTML:(NSString *)html
{
    if (!html || [html isEqual:[NSNull null]]) {
        _attributedDescription = nil;
        return;
    }

    // Parse the HTML to construct an attributed string
    // Parsing HTMl must occur on main queue
    __block NSMutableAttributedString *attributedHTML = nil;
    dispatch_sync(dispatch_get_main_queue(), ^{
        attributedHTML = [[[NSAttributedString alloc]initWithData:[html dataUsingEncoding:NSUTF32StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil]mutableCopy];
    });

    if (!attributedHTML) {
        _attributedDescription = nil;
        return;
    }

    NSMutableAttributedString *attributedContent = [NSMutableAttributedString new];

    // Iterate over the attributed string
    [attributedHTML enumerateAttributesInRange:NSMakeRange(0, [attributedHTML length])
                                       options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                                    usingBlock:
     ^ (NSDictionary *attrs, NSRange range, BOOL *stop) {

         // Get the current font in the attributed string
         UIFont *htmlFont = attrs[NSFontAttributeName];
         NSMutableDictionary *fontDescriptorAttributes = [[[htmlFont fontDescriptor]fontAttributes]mutableCopy];

         // Change the font in the article
         fontDescriptorAttributes[UIFontDescriptorNameAttribute] = eventDescriptionFontName;

         // Create a new font from the attributes
         UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:fontDescriptorAttributes];
         UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:fontSizeModifier * htmlFont.pointSize];

         // Configure line/paragraph spacing
         NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
         paragraphStyle.lineSpacing         = lineSpacing;
         paragraphStyle.paragraphSpacing    = paragraphSpacing;

         // Add the attributes to attributedHTML to simplify skipping content
         [attributedHTML addAttribute:NSFontAttributeName value:font range:range];
         [attributedHTML addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];

         // Append the configured attributed string
         [attributedContent appendAttributedString:[attributedHTML attributedSubstringFromRange:range]];
     }];

    _attributedDescription = attributedContent;
}

@end*/
