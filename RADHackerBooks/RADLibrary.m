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
@property (strong,nonatomic) NSMutableArray *allTagsWithoutDuplicates;
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

-(BOOL) isFirstTimeLoad{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if([def objectForKey:@"settings"]){
        return NO;
    }else{
        [def setObject:@1 forKey:@"settings"];
        return YES;
    }
}


-(void)loadBooksFromJson{
    
    //Getting favorites
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDictionary *favDict = [def objectForKey:DEF_FAV_KEY];
    
    //Data vars
    NSData *jsonData = [NSData new];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *docsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
    NSURL *docsJsonURL = [docsURL URLByAppendingPathComponent:@"myLib.json"];
    
    BOOL firstTimeLoad = [self isFirstTimeLoad];
    
    if(firstTimeLoad==YES){
        NSLog(@"Downloading & Saving JSON");
        jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:DATA_SOURCE_JSON]];
        [jsonData writeToURL:docsJsonURL atomically:YES];
    } else {
        //Read local json
        NSLog(@"Reading local JSON");
        jsonData = [NSData dataWithContentsOfURL:docsJsonURL];
    }
    
    if(jsonData==nil){
        jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:DATA_SOURCE_JSON]];
    }
    
    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jsonError];
    
    //Initializing mutable dict & array
    self.allTags=[[NSMutableArray alloc] init];
    self.allTagsWithoutDuplicates=[[NSMutableArray alloc] init];
    self.allBooks = [[NSMutableArray alloc]init];

    for(int i=0;i<[jsonObject count];i++){
        NSDictionary *dict = [jsonObject objectAtIndex:i];
        
        NSMutableArray *_clearedSplitedItems = [[NSMutableArray alloc]init];
        for (NSString *key in dict) {
            if([key  isEqual: @"tags"]){
                NSArray *_splitItems = [[dict objectForKey:key] componentsSeparatedByString:@","];
                for(NSString *each in _splitItems){
                    if(![self.allTags containsObject:[each stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
                        //Quito duplicados
                        [self.allTagsWithoutDuplicates
                         addObject:[each stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }
                    [self.allTags addObject:[each stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    [_clearedSplitedItems addObject:[self.allTags lastObject]];
                }
            }
        }
        
        //images
        if(firstTimeLoad==YES){
            NSURL *imgUrl = [NSURL URLWithString:[dict objectForKey:@"image_url"]];
            NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
            NSURL *imgDocumentsURL = [docsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", [dict objectForKey:@"title"]]];
            [imgData writeToURL:imgDocumentsURL  atomically:YES];

            NSURL *pdfUrl = [NSURL URLWithString:[dict objectForKey:@"pdf_url"]];
            NSData *pdfData = [NSData dataWithContentsOfURL:pdfUrl];
            NSURL *pdfDocumentsURL = [docsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", [dict objectForKey:@"title"]]];
            [pdfData writeToURL:pdfDocumentsURL  atomically:YES];
            NSLog(@"Downloading pdf for book %@",[dict objectForKey:@"title"]);
            
            
        }
        
        
        //[NSURL URLWithString:[dict objectForKey:@"image_url"]]
        //[NSURL URLWithString:[dict objectForKey:@"pdf_url"]]
        
        UIImage *tmpImg = [UIImage imageWithData: [NSData dataWithContentsOfURL:[docsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", [dict objectForKey:@"title"]]]]];
        
        NSData *tmpPdfData = [NSData dataWithContentsOfURL:[docsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", [dict objectForKey:@"title"]]]];
        
        NSURL *tmpPdfUrlLocal = [docsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", [dict objectForKey:@"title"]]];
        
        RADBook *newBook = [[RADBook alloc]initWithTitle:[dict objectForKey:@"title"]
                                                  Author:[dict objectForKey:@"authors"]
                                                    Tags:_clearedSplitedItems
                                                 BookUrl: tmpImg
                                                  PdfUrl: tmpPdfUrlLocal
                                              pdfUrlData:tmpPdfData];
        
        //Si es favorito , le chuto una tag más & listo (habra que arreglar el listado de tags en la vista)
        if([[favDict objectForKey:newBook.title] isEqual:@1]){
            newBook.isFavorite=[[favDict objectForKey:newBook.title] boolValue];
            NSMutableArray *tmpTag = [[NSMutableArray alloc]initWithArray:newBook.tags];
            [tmpTag addObject:@"Favoritos"];
            newBook.tags=tmpTag;
        }else{
            newBook.isFavorite=[[favDict objectForKey:newBook.title] boolValue];
        }
        
        [self.allBooks addObject:newBook];
        
    }
    

    NSMutableArray *_tmp=[[self.allTagsWithoutDuplicates sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]mutableCopy];
    [_tmp insertObject:@"Favoritos" atIndex:0];
    self.tags=_tmp;

    self.booksCount=[self.allBooks count];
    self.tagsCount=[self.allTagsWithoutDuplicates count];
    self.libraryBooks=self.allBooks;
    
    
}

@end
