//
//  UTCSDataSourceSearchController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/24/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports
@import Foundation;


#pragma mark - Forward Declarations
@class UTCSDataSource;


#pragma mark - Typedefs

/**
 Search completion handler block.
 @param searchResults   Results of search.
 */
typedef void (^UTCSDataSourceSearchCompletion) (NSArray *searchResults);


#pragma mark - UTCSDataSourceSearchController Interface

/**
 UTCSDataSourceSearchController is an abstract class used to search the data of a UTCSDataSource. 
 
 For each searchable data source, you should create a subclass of UTCSDataSourceSearchController. UTCSDataSourceSearchController adopts the
 UISearchDisplayDeleagte protocol and implements the following methods in order to show/hide the content view controller's table view:
    * searchDisplayController:willShowSearchResultsTableView:
    * searchDisplayController:willHideSearchResultsTableView: . 
 To preserve this functionality, subclasses should call the super classes' implementation of these methods if they are overridden.
 */
@interface UTCSDataSourceSearchController : NSObject <UISearchDisplayDelegate, UITableViewDelegate>

// -----
// @name Using a UTCSDataSourceSearchController
// -----

#pragma mark Using a UTCSDataSourceSearchController

/**
 Searches the data source's data with the given query and scope.
 
 Must be overridden by subclasses. The default implementation is abstract and will
 throw an NSInternalInconsistencyException.
 
 @param query       Search query
 @param scope       Scope of the query
 @param completion  Completion handler block
 */
- (void)searchWithQuery:(NSString *)query scope:(NSString *)scope completion:(UTCSDataSourceSearchCompletion)completion;

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Results of the most recent search.
 */
@property (nonatomic, readonly) NSArray         *searchResults;

/**
 Data source whose data should be searched.
 */
@property (weak ,nonatomic) UTCSDataSource      *dataSource;

/**
 Search display controller to display the search results.
 
 The search display controller should be initialized by a content view controller that has
 a search UI (i.e. has a search bar/search field).
 */
@property (nonatomic) UISearchDisplayController *searchDisplayController;

@end
