//
//  RADLibTableViewController.m
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 2/4/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

#import "RADLibTableViewController.h"
#import "RADBook.h"
#import "RADBookViewController.h"
#import "RADLibrary.h"

@interface RADLibTableViewController ()

@end

@implementation RADLibTableViewController


-(id) initWithModel:(RADLibrary*) model style:(UITableViewStyle) style{
    if(self=[super initWithStyle:style]){
        _model=model;
        self.title=@"Hacker Books r00lz!";
    }
    return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.tagsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model bookCountForTag:[self.model.tags objectAtIndex:section]];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //averiguar de que tag nos están hablando
    RADBook *book = [self.model bookForTag:[self.model.tags objectAtIndex:indexPath.section] atIndex:indexPath.row];

    //reutilizar
    if(cell==nil){
        //no tenia celda a mano y tenemos que crearla a mano
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    
    //syncronize cell & model
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:book.bookUrl]];
    cell.imageView.image=image;
    cell.textLabel.text=book.title;
    cell.detailTextLabel.text=book.author;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Suponemos que estamos en un navigation controller.
    
    //Que libro tengo
    RADBook *book = [self.model bookForTag:[self.model.tags objectAtIndex:indexPath.section] atIndex:indexPath.row];
    [self.delegate tvcSelectsBook:book arrayOfBooks:self.model.libraryBooks];
    
    
    
    //Creamos una instancia del libro
    //RADBookViewController *bookVC = [[RADBookViewController alloc]initWithModel:book];
    
    //Hacemos push al navigation controller
    //[self.navigationController pushViewController:bookVC animated:YES];
    
    
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[[self.model tags]objectAtIndex:section]capitalizedString];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.5 green:0 blue:0.13 alpha:1];
}


#pragma mark Delegate LibTableViewControllerDelegate
-(void)tvcSelectsBook:(RADBook*)book arrayOfBooks:(NSArray*)books{
    RADBookViewController *bookVC = [[RADBookViewController alloc]initWithModel:book];
    [self.navigationController pushViewController:bookVC animated:YES];
}



#pragma mark Unused
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
