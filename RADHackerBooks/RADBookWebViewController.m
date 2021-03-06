//
//  RADBookWebViewController.m
//  RADHackerBooks
//
//  Created by RAMON ALBERTI DANES on 3/4/15.
//  Copyright (c) 2015 Krainet. All rights reserved.
//

#import "RADBookWebViewController.h"
#import "RADBook.h"

@interface RADBookWebViewController ()

@end

@implementation RADBookWebViewController

#pragma mark Inits
-(id) initWithModel:(RADBook *)model{
    if(self=[super init]){
        _model=model;
        self.title=self.model.title;
    }
    return self;
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self displayUrl:self.model.pdfUrl];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utilidades
-(void) displayUrl: (NSURL *) aUrl{
    self.browser.delegate = self;
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
    [self.browser loadRequest:[NSURLRequest requestWithURL:aUrl]];
}



#pragma mark - WebView delegate
-(void) webViewDidFinishLoad:(UIWebView *)webView{
    webView.scrollView.delegate=self;
    webView.scrollView.maximumZoomScale=20;
    webView.scrollView.minimumZoomScale=1;
    
    webView.scrollView.zoomScale=2;
    webView.scrollView.zoomScale=1;
    
    
    [self.activityView stopAnimating];
    self.activityView.hidden = TRUE;
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    self.browser.scrollView.maximumZoomScale=20;
}

@end
