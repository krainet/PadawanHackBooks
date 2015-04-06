//
//  RADLibTableViewControllerCell.h
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 6/4/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RADLibTableViewControllerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UIImageView *bookFavIcon;

@property (copy,nonatomic) NSString *idCell;

+(NSString *) getCellId;
@end
