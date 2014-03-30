//
//  UTCSSearchBar.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/30/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSearchBar.h"

static NSString * const UTCSSearchFieldMagnifyingGlassIconName = @"searchIcon";

@interface UTCSSearchBar ()
@property (nonatomic) UITextField   *searchField;
@property (nonatomic) NSDictionary  *placeholderAttributes;
@end

@implementation UTCSSearchBar

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        self.placeholderAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.5]};
        
        self.searchField = [[UITextField alloc]initWithFrame:CGRectMake(8.0, 8.0, CGRectGetWidth(self.bounds),
                                                                        CGRectGetHeight(self.bounds) - 16.0)];
        self.searchField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"" attributes:self.placeholderAttributes];
        self.searchField.tintColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        self.searchField.textColor = [UIColor whiteColor];
        self.searchField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        self.searchField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        [self addSubview:self.searchField];
        
        UIImageView *searchIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 32.0, 16.0)];
        searchIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        searchIconImageView.image = [[UIImage imageNamed:UTCSSearchFieldMagnifyingGlassIconName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        searchIconImageView.tintColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        self.searchField.leftView = searchIconImageView;
        self.searchField.leftViewMode = UITextFieldViewModeAlways;
        self.searchField.rightViewMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

@end
