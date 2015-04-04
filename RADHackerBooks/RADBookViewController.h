//
//  RADBookViewController.h
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 28/3/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

@import UIKit;
@class RADBook;
@class RADLibTableViewController;
@class RADBookWebViewController;




//Importamos el .h aqui porque tiene un protocolo
#import "RADLibTableViewController.h"

@interface RADBookViewController : UIViewController<UISplitViewControllerDelegate,LibTableViewControllerDelegate>

@property (strong,nonatomic) RADBook *model;

@property (weak,nonatomic) IBOutlet UIImageView *photo;
@property (weak,nonatomic) IBOutlet UILabel *bookTitle;
@property (weak,nonatomic) IBOutlet UILabel *author;
@property (weak,nonatomic) IBOutlet UILabel *tags;

@property (nonatomic, weak) IBOutlet UISwitch *switch1;

#pragma mark - Init
-(id) initWithModel:(RADBook*) model;


#pragma mark - Actions
-(IBAction)displayPdf:(id)sender;
-(IBAction)toogleUISwitch:(id)sender;


@end
