//
//  RADBookViewController.m
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 28/3/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

#import "RADBookViewController.h"
#import "RADBook.h"
#import "RADBookWebViewController.h"

#import "Settings.h"

@interface RADBookViewController ()

@end

@implementation RADBookViewController

#pragma mark - Init
-(id) initWithModel:(RADBook*) model{
    if(self = [super initWithNibName:nil bundle:nil]){
        _model=model;
        self.title=model.title;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - View
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    // Si estoy dentro de un SplitVC me pongo el botón
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    [self syncViewWithModel];
}


#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
-(void) displayPdf:(id)sender{
    
    //Creo instancia de WebViewController
    RADBookWebViewController *webVC = [[RADBookWebViewController alloc] initWithModel:self.model];
    
    //Hago push al NavigatorController
    [self.navigationController pushViewController:webVC animated:TRUE];
}


#pragma mark Delegate UISplitViewControllerDelegate
-(void) splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc{
    
    self.navigationItem.rightBarButtonItem=barButtonItem;
}

//TODO revisar estos delegates

-(void) splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    
    self.navigationItem.rightBarButtonItem=nil;
    self.navigationItem.leftBarButtonItem=nil;
    
}


//TODO convencion de nombre para esto
#pragma mark LibTableViewControllerDelegate
-(void)tvcSelectsBook:(RADBook *)book{
    self.model=book;
    self.title=book.title;
    //Sync vistas
    [self syncViewWithModel];
}


#pragma mark - Utils
-(void) syncViewWithModel{
    self.title=self.model.title;
    self.bookTitle.text=self.model.title;
    self.tags.text=@"hola";
    self.author.text=[@"Autor : " stringByAppendingString: self.model.author];
    self.tags.text=[self arrayToString:self.model.tags];
    [self.switch1 setOn:self.model.isFavorite];
    self.photo.image=self.model.bookUrl;
}



-(NSString *) arrayToString:(NSArray *) myArray{
    NSString *repr = nil;
    
    if([myArray count] == 1) {
        repr = [@"Temática/s : " stringByAppendingString:[myArray lastObject]];
    }else{
        repr = [@"Temática/s : " stringByAppendingString: [[myArray componentsJoinedByString:@", "] stringByAppendingString:@"."]];
    }
    
    return repr;
}

#pragma mark IBActions switch
-(IBAction)toogleUISwitch:(id)sender{
    UISwitch *mySwitch = (UISwitch *)sender;
    
    if ([mySwitch isOn]) {
        [self saveFavoriteToUserDefaults:self.model.title Activated:YES];
        self.model.isFavorite=YES;
    } else {
        [self saveFavoriteToUserDefaults:self.model.title Activated:NO];
        self.model.isFavorite=NO;
    }
}

#pragma mark - Utils
-(void) saveFavoriteToUserDefaults:(NSString*) bookTitle Activated:(BOOL)activated{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    NSMutableDictionary *bookDict = [[NSMutableDictionary alloc]init];
    
    BOOL isActive = activated==YES?YES:NO;
    NSMutableArray *muTags = [[NSMutableArray alloc]initWithArray:self.model.tags];
    
    if((dict=[[def objectForKey:DEF_FAV_KEY]mutableCopy])){
        //Actualizo model
        BOOL deleting = NO;
        for (int i = 0; i<self.model.tags.count; i++) {
            if ([[muTags objectAtIndex:i]isEqualToString:FAV_NAME]) {
                [muTags removeObjectAtIndex:i];
                deleting=YES;
                
            }
        }
        if(deleting==NO){
            [muTags addObject:FAV_NAME];
        }
        
        self.model.tags=muTags;
        self.model.isFavorite=isActive;
        
        [dict setObject:@(isActive) forKey:bookTitle];
        [def setObject:dict forKey:DEF_FAV_KEY];
        [self sendNotificationForFavoriteChangeWithBook:self.model];
    } else {
        [muTags addObject:FAV_NAME];
        self.model.tags=muTags;
        self.model.isFavorite=isActive;        
        [bookDict setObject:@(isActive) forKey:bookTitle];
        [def setObject:bookDict forKey:DEF_FAV_KEY];
        [self sendNotificationForFavoriteChangeWithBook:self.model];
    }
    //for the flys
    [def synchronize];
    
    [self syncViewWithModel];
}


-(void) sendNotificationForFavoriteChangeWithBook:(RADBook*)book {
    //mandar la notificacion
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; // es singletone
    NSDictionary *dict=@{BOOK_KEY:book};
    
    NSNotification *n = [NSNotification notificationWithName:BOOK_DID_CHANGE_FAV_NOTIFICATION_NAME object:self userInfo:dict];
    
    [nc postNotification:n];
}

@end
