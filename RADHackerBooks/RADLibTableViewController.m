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
#import "Settings.h"

@interface RADLibTableViewController ()

@end

@implementation RADLibTableViewController


-(id) initWithModel:(RADLibrary*) model style:(UITableViewStyle) style{
    if(self=[super initWithStyle:style]){
        _model=model;
        self.title=@"Mi Librería";
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
    
    //REUTILIZAR celdas
    if(cell==nil){
        //no tenia celda a mano y tenemos que crearla a mano
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //syncronize cell & model
    //TODO implementar celda personalizada
    UIImage *image = book.bookUrl;
    cell.imageView.image=image;
    cell.textLabel.text=book.title;
    cell.detailTextLabel.text=book.author;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Suponemos que estamos en un navigation controller.
    
    //Que libro tengo
    RADBook *book = [self.model bookForTag:[self.model.tags objectAtIndex:indexPath.section] atIndex:indexPath.row];
    
    //Delegado
    [self.delegate tvcSelectsBook:book];
    
    //Save defaults
    //TODO comprobar si un favorito ya no está para poder mostrarlo como userdefault.
    if(indexPath.section!=0){
        [self saveLastSelectedBookAtSectio:indexPath.section row:indexPath.row];
    }
    
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[[self.model tags]objectAtIndex:section]capitalizedString];
}

-(void) viewWillDisappear:(BOOL)animated{
    //baja notif
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    //alta notif
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(notifyThatBookFavDidChange:)
               name:BOOK_DID_CHANGE_FAV_NOTIFICATION_NAME
             object:nil];
}


#pragma mark Delegate LibTableViewControllerDelegate
-(void)tvcSelectsBook:(RADBook*)book{
    RADBookViewController *bookVC = [[RADBookViewController alloc]initWithModel:book];
    [self.navigationController pushViewController:bookVC animated:YES];
}

#pragma mark Utils
-(RADBook*) lastSelectedBook{
    NSIndexPath *indexPath=nil;
    NSDictionary *coords=nil;
    
    coords=[[NSUserDefaults standardUserDefaults]objectForKey:LAST_BOOK_KEY];
    
    if(coords==nil){
        coords=[self setDefaults];
    }else{
        //nothing to do
    }
    
    NSUInteger row = [[coords objectForKey:ROW_KEY] integerValue];
    NSUInteger section = [[coords objectForKey:SECTION_KEY] integerValue];
    
    indexPath=[NSIndexPath indexPathForRow:row inSection:section];
    
    return [self bookForIndexPath:indexPath];
}

-(void) saveLastSelectedBookAtSectio:(NSUInteger)section row:(NSUInteger)row{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@{SECTION_KEY : @(section),ROW_KEY : @(row)} forKey:LAST_BOOK_KEY];
    
    //for the flys
    [def synchronize];
}

-(NSDictionary*) setDefaults{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDictionary *defBookCoords = @{SECTION_KEY:@(DEF_START_SECTION),ROW_KEY:@0};
    
    [def setObject:defBookCoords forKey:LAST_BOOK_KEY];
    
    //for the flys
    [def synchronize];
    
    return defBookCoords;
}

-(RADBook*) bookForIndexPath: (NSIndexPath*) indexPath{
    //averiguar de que book nos están hablando
    RADBook *book = [self.model bookForTag:[self.model.tags objectAtIndex:indexPath.section] atIndex:indexPath.row];
    return book;
}

#pragma mark Notifications
-(void)notifyThatBookFavDidChange:(NSNotification*) notification{
    //Obtengo Libro desde notification
    
    RADBook *book = [notification.userInfo objectForKey:BOOK_KEY];
    
    NSMutableArray *mutBooks = [[NSMutableArray alloc]initWithArray:self.model.libraryBooks];

    
    for (int x=0; x<mutBooks.count; x++) {
        //NSLog(@"title %@",[[mutBooks objectAtIndex:x] title]);
        if([[[mutBooks objectAtIndex:x]title] containsString:book.title]){
            [mutBooks replaceObjectAtIndex:x withObject:book];
        }
    }
    
    //actualizamos el modelo
    self.model.libraryBooks=mutBooks;
    [self.tableView reloadData];
    
}


#pragma mark Unused
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
