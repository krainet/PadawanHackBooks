//
//  RADLibrary.m
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 28/3/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

#import "RADLibrary.h"
#import "RADBook.h"
#import "Settings.h"

@interface RADLibrary ()


@property (strong,nonatomic) NSMutableArray *allTags;
@property (strong,nonatomic) NSMutableArray *allBooks;

@end

@implementation RADLibrary

#pragma mark - Init
-(id) initFromRemoteJson{
    if(self=[super init]){
        [self loadBooksFromJson];
    }
    return self;
}

#pragma mark - Instance functions
//Number of books for a tag
-(NSUInteger) bookCountForTag:(NSString*) search_tag{
    int bookCount = 0;
        for (RADBook* book in self.allBooks) {
            if ([book.tags containsObject:search_tag]) {
                bookCount+=1;
            }
        }
        return bookCount;
}

//All books in tag.
-(NSArray*) booksForTag:(NSString*) tag{
    NSMutableArray *booksForTag = [[NSMutableArray alloc]init];
    
    
    for (RADBook* book in self.allBooks) {
        if ([book.tags containsObject:tag]) {
            [booksForTag addObject:book];
        }
    }
    return [booksForTag sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSString *first = [(RADBook*)obj1 title];
        NSString *second = [(RADBook*)obj2 title];
        return [first localizedCaseInsensitiveCompare:second];
    }];
}


//Selected book in tag (atIndex);
-(RADBook*) bookForTag:(NSString*) tag atIndex:(NSUInteger) index{
    return [[self booksForTag:tag]objectAtIndex:index];
}


#pragma mark - Utils

-(void)loadBooksFromJson{
    
    //Getting data from URL
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:DATA_SOURCE_JSON]];
    
    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jsonError];
    
    //Initializing mutable dict & array
    self.allTags=[[NSMutableArray alloc] init];
    self.allBooks = [[NSMutableArray alloc]init];

    
    for(int i=0;i<[jsonObject count];i++){
        NSDictionary *dict = [jsonObject objectAtIndex:i];
        NSMutableArray *_clearedSplitedItems = [[NSMutableArray alloc]init];
        for (NSString *key in dict) {
            if([key  isEqual: @"tags"]){
                NSArray *_splitItems = [[dict objectForKey:key] componentsSeparatedByString:@","];
                for(NSString *each in _splitItems){
                    [self.allTags addObject:[each stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    [_clearedSplitedItems addObject:[self.allTags lastObject]];
                }
            }
        }
        
        RADBook *newBook = [[RADBook alloc]initWithTitle:[dict objectForKey:@"title"]
                                                  Author:[dict objectForKey:@"authors"]
                                                    Tags:_clearedSplitedItems
                                                 BookUrl:[NSURL URLWithString:[dict objectForKey:@"image_url"]]
                                                  PdfUrl:[NSURL URLWithString:[dict objectForKey:@"pdf_url"]]];
        
        [self.allBooks addObject:newBook];
    }
    
    self.tags=self.allTags;
    self.booksCount=[self.allBooks count];
    self.tagsCount=[self.allTags count];
    self.libraryBooks=self.allBooks;
    
}

@end
