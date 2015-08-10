
// Key associated with index paths added by a filter.
let UTCSEventsFilterAddIndex = 0

// Key associated with index paths added by a filter.
let UTCSEventsFilterRemoveIndex  = 1

// Key used to cache events.
let UTCSEventsDataSourceCacheKey = "UTCSEventsDataSourceCacheKey"

// Events table view cell identifier.
let UTCSEventsTableViewCellIdentifier  = "UTCSEventTableViewCell"

@objc class EventsDataSource: DataSource, UITableViewDataSource {
    // TODO: Move into Event model
    enum EventType: String {
        case All = "all"
        case Careers = "careers"
        case Talks = "talks"
        case Orgs = "orgs"
    }
    var eventData: [UTCSEvent] {
        get{
            return data as! [UTCSEvent]
        }
    }
    var currentFilterType = EventType.All
    var filteredEvents = [UTCSEvent]()
    var typeColorMapping = [EventType.Careers: UIColor.utcsEventCareersColor(),
                                .Talks: UIColor.utcsEventTalkColor(),
                                .Orgs: UIColor.utcsEventStudentOrgsColor()]
    init(){
        super.init(service: .Events, parser: UTCSEventsDataSourceParser())
        minimumTimeBetweenUpdates = 3 * 60 * 3600

    }
    func filterEventsWithType(type: EventType) -> [[NSIndexPath]]{
        return []
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eventData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

/*


#pragma mark - UTCSEventsDataSource Interface

/**
UTCSEventsDataSource is a concrete class that handles downloading, parsing, and caching
of UTCS events. UTCSEventsDataSource also acts at the table view data source for the
UTCSEventsViewController.

UTCSEventsDataSource should not be subclassed.
*/
@interface UTCSEventsDataSource : UTCSDataSource <UITableViewDataSource>

// -----
// @name Using an Events Data Source
// -----

#pragma mark Using an Events Data Source

/**

#pragma mark - Imports

#import "UTCSEvent.h"
#import "UIColor+UTCSColors.h"
#import "UTCSDataSourceCache.h"
#import "UTCSEventsDataSource.h"
#import "UTCSEventsDataSourceParser.h"


#pragma mark - Constants


// Minimum time between updates, in seconds
static CGFloat minimumTimeBetweenUpdates                    = 10800.0;  // 3 hours


#pragma mark - UTCSEventsDataSoure Class Extension

@interface UTCSEventsDataSource ()

// Current filter type
@property (nonatomic) NSString          *currentFilterType;

// Events matching the type of currentFilterType
@property (nonatomic) NSMutableArray    *filteredEvents;

// Mapping between event type to color
@property (nonatomic) NSDictionary      *typeColorMapping;

// Date formatter
@property (nonatomic) NSDateFormatter   *dateFormatter;

@end


#pragma mark - UTCSEventsDataSource Implementation

@implementation UTCSEventsDataSource

- (instancetype)initWithService:(NSString *)service
{
    if(self = [super initWithService:service]) {
        
        self.currentFilterType = @"all";
        
        _minimumTimeBetweenUpdates = minimumTimeBetweenUpdates;
        
        _parser = [UTCSEventsDataSourceParser new];
        
        self.typeColorMapping = @{@"careers": [UIColor utcsEventCareersColor],
                                  @"talks"  : [UIColor utcsEventTalkColor],
                                  @"orgs"   : [UIColor utcsEventStudentOrgsColor]};
        
        _cache  = [[UTCSDataSourceCache alloc]initWithService:service];
        _primaryCacheKey = UTCSEventsDataSourceCacheKey;
        
        NSDictionary *cache = [self.cache objectWithKey:UTCSEventsDataSourceCacheKey];
        UTCSDataSourceCacheMetaData *meta = cache[UTCSDataSourceCacheMetaDataName];
        _data       = cache[UTCSDataSourceCacheValuesName];
        _updated    = meta.timestamp;
        [self prepareFilter];
    }
    return self;
}

#pragma mark Filtering

- (void)prepareFilter
{
    self.filteredEvents = [self.data mutableCopy];
    [self filterEventsWithType:self.currentFilterType];
}

- (NSDictionary *)filterEventsWithType:(NSString *)type
{
    NSMutableArray *add     = [NSMutableArray new];
    NSMutableArray *remove  = [NSMutableArray new];
    
    type = [type lowercaseString];
    
    
    if (![type isEqualToString:@"all"]) {
        
        
        NSMutableArray *newFilteredEvents = [NSMutableArray new];
        
        // Remove events
        NSInteger count = [self.filteredEvents count];
        for (int i = 0; i < count; ++i) {
            UTCSEvent *event = self.filteredEvents[i];
            if (![event.type isEqualToString:type]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [remove addObject:indexPath];
            }
        }
        
        // Add events
        int index = 0;
        for (UTCSEvent *event in self.data) {
            if ([event.type isEqualToString:type]) {
                if (![self.currentFilterType isEqualToString:@"all"]) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    [add addObject:indexPath];
                    ++index;
                }
                [newFilteredEvents addObject:event];
            }
        }
        
        self.filteredEvents = newFilteredEvents;
    } else {
        
        // Add events
        NSInteger count = [self.data count];
        
        for (int i = 0; i < count; ++i) {
            UTCSEvent *event = self.data[i];
            BOOL containsEvent = NO;
            for (UTCSEvent *filteredEvent in self.filteredEvents) {         // Manually checking because containsObject: is did not work correctly
                if ([event.eventID isEqualToString:filteredEvent.eventID]) {// Look into implementing hash for UTCSEvent 
                    containsEvent = YES;
                    break;
                }
            }
            if (!containsEvent) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [add addObject:indexPath];
            }
        }
        
        self.filteredEvents = self.data;
    }
    
    self.currentFilterType = type;
    
    return @{UTCSEventsFilterAddName    : add,
             UTCSEventsFilterRemoveName : remove};
}

#pragma mark UITableViewDataSource Methods

- (EventTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UTCSEventsTableViewCellIdentifier];
    
    if(!cell) {
        cell = [[EventTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UTCSEventsTableViewCellIdentifier];
        cell.accessoryView = ({
            UIImage *image          = [[UIImage imageNamed:cellAccessoryImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView  = [[UIImageView alloc]initWithImage:image];
            imageView.tintColor     = [UIColor colorWithWhite:1.0 alpha:0.5];
            imageView;
        });
    }
    
    UTCSEvent *event        = self.filteredEvents[indexPath.row];
    
    UIColor *typeColor = self.typeColorMapping[event.type];
    cell.typeStripeLayer.fillColor = typeColor.CGColor;
    
    
    NSString *detailText = [NSString string];
    
    if (event.startDate) {
        NSString  *dateString   = [NSDateFormatter localizedStringFromDate:event.startDate
                                                                 dateStyle:NSDateFormatterLongStyle
                                                                 timeStyle:(event.allDay)?NSDateFormatterNoStyle:NSDateFormatterShortStyle];
        detailText = [detailText stringByAppendingString:dateString];
        if ([event.location length] > 0) {
            detailText = [detailText stringByAppendingString:@"\n"];
        }
    }
    
    if ([event.location length] > 0) {
        detailText = [detailText stringByAppendingString:event.location];
    }
    
    cell.textLabel.text         = event.name;
    cell.detailTextLabel.text   = detailText;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filteredEvents count];
}

@end
*/*/