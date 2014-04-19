//
//  UTCSLabsManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/7/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

@import Foundation;

@interface UTCSLabsDataSource : NSObject <UITableViewDataSource>

- (void)syncLabsWithCompletion:(void (^)(BOOL success))completion;
- (NSArray *)searchLabsWithSearchString:(NSString *)searchString scope:(NSString *)scope;

@property (nonatomic) UISearchDisplayController *searchDisplayController;
@property (nonatomic, readonly) NSArray *labMachines;

@end

