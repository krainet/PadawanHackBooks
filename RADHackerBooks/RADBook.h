//
//  RADBook.h
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 28/3/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

@import Foundation;

@interface RADBook : NSObject

#pragma mark - Propertyes
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *author;
@property (strong,nonatomic) NSArray *tags;
@property (strong,nonatomic) NSURL *bookUrl;
@property (strong,nonatomic) NSURL *pdfUrl;

-(id) initWithTitle:(NSString*) title
             Author:(NSString*) author
               Tags:(NSArray*) tags
            BookUrl:(NSURL*) bookUrl
             PdfUrl:(NSURL*) pdfUrl;

-(id) initFromJson:(NSData*) data;

@end
