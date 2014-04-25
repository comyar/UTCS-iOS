//
//  UTCSEventsFilterView.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsFilterView.h"


@interface UTCSEventsFilterView ()

@end

@implementation UTCSEventsFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        self.tableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.tableHeaderView = ({
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(frame), 32.0)];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                label.text = @"Filter Events";
                label;
            });
    
            tableView.backgroundColor   = [UIColor colorWithWhite:0.0 alpha:0.75];
            tableView.separatorColor    = [UIColor colorWithWhite:1.0 alpha:0.1];
            tableView.rowHeight = 50.0;
            tableView;
        });
        
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = CGRectMake(0.0, 44.0, CGRectGetWidth(self.bounds), 232);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    }];
}




@end
