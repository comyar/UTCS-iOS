//
//  UTCSDataSourceSearchController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/24/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;
@class UTCSDataSource;

typedef void (^UTCSDataSourceSearchCompletion) (NSArray *searchResults);

@interface UTCSDataSourceSearchController : NSObject <UISearchDisplayDelegate, UITableViewDelegate>

- (void)searchWithQuery:(NSString *)query scope:(NSString *)scope completion:(UTCSDataSourceSearchCompletion)completion;

@property (nonatomic) NSArray *searchResults;

@property (weak ,nonatomic) UTCSDataSource      *dataSource;
@property (nonatomic) UISearchDisplayController *searchDisplayController;


@end
