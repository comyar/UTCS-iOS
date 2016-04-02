#import "UTCSLabMachineViewController.h"



#pragma mark - UTCSLabMachineViewController Class Extension

@interface UTCSLabMachineViewController ()

@property (nonatomic) UIView                *backgroundContainer;

@property (nonatomic) UTCSLabView           *labView;

@property (nonatomic) ServiceErrorView  *serviceErrorView;

@end


#pragma mark - UTCSLabMachineViewController Implementation

@implementation UTCSLabMachineViewController

- (instancetype)initWithLayout:(UTCSLabViewLayout *)layout
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _layout = layout;
        
        
        self.backgroundContainer = [[UIView alloc]initWithFrame:self.view.bounds];
        self.backgroundContainer.clipsToBounds = YES;
        
        _backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundImageView.clipsToBounds = NO;
        
        [self.backgroundContainer addSubview:self.backgroundImageView];
        [self.view addSubview:self.backgroundContainer];

        
        self.labView = [[UTCSLabView alloc]initWithFrame:CGRectZero layout:self.layout];
        self.labView.frame = CGRectMake(0.0, 44.0, self.view.bounds.size.width, self.view.bounds.size.height - 44.0);
        self.labView.backgroundColor = [UIColor clearColor];
        self.labView.alpha = 0.0;
        self.labView.dataSource = self;
        [self.view addSubview:self.labView];
        
        self.shimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectZero];
        self.shimmeringView.contentView = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.numberOfLines = 0;
            label;
        });
        [self.view addSubview:self.shimmeringView];
        
        
        self.serviceErrorView = ({
            ServiceErrorView *view = [[ServiceErrorView alloc]initWithFrame:CGRectZero];
            view.errorLabel.text = @"Ouch! Something went wrong.\n\nPlease check your network connection.";
            view.alpha = 0.0;
            view;
        });
        
        self.serviceErrorView.frame     = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 0.5 * self.view.bounds.size.height);
        self.serviceErrorView.center    = CGPointMake(self.view.center.x, 0.9 * self.view.center.y);
        
        [self.view addSubview:self.serviceErrorView];
        
        [self.labView prepareLayout];
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.backgroundImageView.frame = self.view.bounds;
    
    [self.labView invalidateLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    _imageOffset = imageOffset;
    
    CGRect frame = self.backgroundContainer.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.backgroundImageView.frame = offsetFrame;
}

- (void)setMachines:(NSDictionary *)machines
{
    _machines = machines;
    [self.labView invalidateLayout];
    [self.labView reloadData];
    if (_machines) {
        [UIView animateWithDuration:0.3 animations:^{
            self.labView.alpha = 1.0;
        }];
    }
}

#pragma mark UTCSLabViewDataSource Methods

- (UTCSLabMachineView *)labView:(UTCSLabView *)labView machineViewForIndexPath:(NSIndexPath *)indexPath name:(NSString *)name
{
    UTCSLabMachineView *machineView = [labView dequeueMachineViewForIndexPath:indexPath];
    LabMachine *machine = self.machines[name];
    if (!machine) {
        machineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    } else {
        if (!machine.status) {
            machineView.backgroundColor= [UIColor colorWithWhite:0.5 alpha:0.25];
        } else if (machine.occupied) {
            machineView.backgroundColor = [UIColor colorWithRed:0.863 green:0.000 blue:0.052 alpha:1.000];
        } else {
            machineView.backgroundColor = [UIColor colorWithRed:0.180 green:0.901 blue:0.150 alpha:1.000];
        }
    }
    return machineView;
}

@end
