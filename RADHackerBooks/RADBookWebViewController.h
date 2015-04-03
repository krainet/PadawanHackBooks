//
//  RADBookWebViewController.h
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 3/4/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

@import UIKit;
@class RADBook;

@interface RADBookWebViewController : UIViewController<UIWebViewDelegate>

@property (strong,nonatomic) RADBook *model;
@property (weak,nonatomic) IBOutlet UIWebView *browser;
@property (weak,nonatomic) IBOutlet UIActivityIndicatorView *activityView;

-(id) initWithModel: (RADBook *) model;

@end
