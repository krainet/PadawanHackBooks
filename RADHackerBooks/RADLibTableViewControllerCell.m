//
//  RADLibTableViewControllerCell.m
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 6/4/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

#import "RADLibTableViewControllerCell.h"

@implementation RADLibTableViewControllerCell

+(NSString*) getCellId{
    return @"myCustomCell";
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
