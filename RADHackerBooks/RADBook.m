//
//  RADBook.m
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 28/3/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

#import "RADBook.h"

@implementation RADBook

#pragma mark - Init
-(id) initWithTitle:(NSString*) title
             Author:(NSString*) author
               Tags:(NSArray*) tags
            BookUrl:(UIImage*) bookUrl
             PdfUrl:(NSURL*) pdfUrl
         pdfUrlData:(NSData*) pdfUrlData{
    
    if(self=[super init]) {
        _title=title;
        _author=author;
        _tags=tags;
        _bookUrl=bookUrl;
        _pdfUrldata=pdfUrlData;
        _pdfUrl=pdfUrl;
    }

    return self;
}

-(id) initFromJson:(NSData*) data{
    
    return self;
}



@end
