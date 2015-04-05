//
//  AppDelegate.h
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 28/3/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

@import UIKit;
@class RADBookViewController;
@class RADBook;
@class RADLibrary;

#import "Settings.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak,nonatomic) IBOutlet UIActivityIndicatorView *activityViewFirst;
@property (weak,nonatomic) IBOutlet UIImageView *startImage;

//Display type
//1 for Tabblet & 2 for Iphone
@property (nonatomic) NSInteger displayType;


@end

