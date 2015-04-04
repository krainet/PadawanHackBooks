//
//  RADLibTableViewController.h
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 2/4/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

@import UIKit;

@class RADBook;
@class RADLibrary;
@class RADBookViewController;
@class RADLibTableViewController;

#define LAST_BOOK_KEY @"lastBook"
#define ROW_KEY @"row"
#define SECTION_KEY @"section"
#define DEF_START_SECTION 1


@protocol LibTableViewControllerDelegate <NSObject>

@optional
-(void)tvcSelectsBook:(RADBook*)book;
-(void)libTableViewControlle:(RADLibTableViewController*)bookVC didSelected:(RADBook *) book;

@end



@interface RADLibTableViewController : UITableViewController<LibTableViewControllerDelegate>

@property (strong,nonatomic) RADLibrary *model;

//Ojo al 'id' , ya que podria ser de cualquier tipo
@property (weak, nonatomic)id<LibTableViewControllerDelegate>delegate;

-(id) initWithModel:(RADLibrary*) model style:(UITableViewStyle) style;
-(RADBook*) lastSelectedBook;

@end
