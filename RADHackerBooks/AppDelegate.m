//
//  AppDelegate.m
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 28/3/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

#import "AppDelegate.h"
#import "RADBookViewController.h"
#import "RADLibTableViewController.h"
#import "RADBook.h"
#import "RADLibrary.h"

#import "Settings.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    //Detectar Pantalla
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        //Somos tablet
        self.displayType=1;
    } else {
        //Somos phone
        self.displayType=2;
    }
    [self configureForDisplayType:self.displayType];
    
    
    
    self.window.backgroundColor = [UIColor greenColor];
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark - Utils
-(void) configureForDisplayType: (NSUInteger) idType{
    if(idType==1){
        //isPad
        
        //Creamos modelo
        RADLibrary *library = [[RADLibrary alloc]initFromRemoteJson];
        
        //Creamos controlador
        RADLibTableViewController *libVC = [[RADLibTableViewController alloc]initWithModel:library style:UITableViewStyleGrouped];
        
        RADBookViewController *bookVC = [[RADBookViewController alloc]
                                          initWithModel:[libVC lastSelectedBook]];
        
        UINavigationController *navLib=[[UINavigationController alloc]
                                        initWithRootViewController:libVC];
        
        UINavigationController *navBook=[[UINavigationController alloc]
                                         initWithRootViewController:bookVC];
        
        //Creamos Combinador
        UISplitViewController *splitVC = [[UISplitViewController alloc]init];
        splitVC.viewControllers=@[navLib,navBook];
        
        //Asignamos delegados
        splitVC.delegate=bookVC;
        libVC.delegate=bookVC;
        
        //Asignamos root
        self.window.rootViewController=splitVC;
        
        
    } else {
        //is phone
        //Creamos modelo
        RADLibrary *library = [[RADLibrary alloc]initFromRemoteJson];
        
        //Creamos controlador
        //RADLibTableViewController *tVC = [[RADLibTableViewController alloc]initWithModel:library style:UITableViewStyleGrouped];
        RADLibTableViewController *libVC = [[RADLibTableViewController alloc]initWithModel:library style:UITableViewStyleGrouped];
        
        //Creamos Combinador
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:libVC];
        
        //Asegnamos delegados
        libVC.delegate=libVC;
        
        //Asignamos root
        self.window.rootViewController=navVC;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
