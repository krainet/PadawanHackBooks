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

#pragma mark - View LifeCycle
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

#pragma mark - Actions
-(void) displayWeb:(id)sender{
    
}

-(void) displayPdf:(id)sender{
    NSLog(@"Go to %@",self.model.pdfUrl);
    
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


-(void) splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    
    self.navigationItem.rightBarButtonItem=nil;
}

#pragma mark LibTableViewControllerDelegate
-(void)tvcSelectsBook:(RADBook *)book arrayOfBooks:(NSArray *)books{
    self.model=book;
    self.title=book.title;
    //Sync vistas
    [self syncViewWithModel];
}


#pragma mark - Utils
-(void) syncViewWithModel{
    self.title=self.model.title;
    self.bootTitle.text=self.model.title;
    self.author.text=self.model.author;
    self.bookUrl.text=[self.model.bookUrl absoluteString];
    self.pdfUrl.text=[self.model.pdfUrl absoluteString];
    NSData *dataURL = [NSData dataWithContentsOfURL:self.model.bookUrl];
    UIImage *bookPicture = [[UIImage alloc]initWithData:dataURL];
    self.photo.image=bookPicture;
}

@end
