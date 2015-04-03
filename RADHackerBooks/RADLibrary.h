//
//  RADLibrary.h
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 28/3/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

@import Foundation;
@class RADBook;

@interface RADLibrary : NSObject



#pragma mark - Propertyes
//Books total count
@property NSUInteger booksCount;

//All tags - Alpha Order
@property NSArray *tags;

@property NSUInteger tagsCount;

@property NSArray* libraryBooks;

#pragma mark - Init
-(id) initFromRemoteJson;


#pragma mark - Instance functions

//Number of books for a tag
-(NSUInteger) bookCountForTag:(NSString*) tag;

//All books in tag.
-(NSArray*) booksForTag:(NSString*) tag;

//Selected book in tag (atIndex);
-(RADBook*) bookForTag:(NSString*) tag atIndex:(NSUInteger) index;


@end
