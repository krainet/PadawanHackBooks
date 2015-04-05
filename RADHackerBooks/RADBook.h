//
//  RADBook.h
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 28/3/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface RADBook : NSObject

#pragma mark - Propertyes
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *author;
@property (strong,nonatomic) NSArray *tags;
@property (strong,nonatomic) UIImage *bookUrl;
@property (strong,nonatomic) NSURL *pdfUrl;
@property (strong,nonatomic) NSData *pdfUrldata;
@property (nonatomic) BOOL isFavorite;

-(id) initWithTitle:(NSString*) title
             Author:(NSString*) author
               Tags:(NSArray*) tags
            BookUrl:(UIImage*) bookUrl
             PdfUrl:(NSURL*) pdfUrl
         pdfUrlData:(NSData*) pdfUrlData;

-(id) initFromJson:(NSData*) data;

@end
