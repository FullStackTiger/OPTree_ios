//
//  SplashADViewController.m
//  O&P Tree
//
//  Created by Mobile Developer on 3/6/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

#import "SplashADViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

#define layout self.view.frame.size.height/736.0f

@interface SplashADViewController () <UIGestureRecognizerDelegate, UIWebViewDelegate>
{
    NSInteger randomIndex;
}

@property (strong, nonatomic) UIImageView *splashImage;
@property (strong, nonatomic) UIButton *removeButton;
@property (strong, nonatomic) UIWebView *webview;
@end

@implementation SplashADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate *delegate = GetDM;
    
    self.splashImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width)/2, self.view.frame.size.width, self.view.frame.size.width)];
    
    randomIndex = arc4random()%[delegate.dataManager.splashArray count];
    NSURL *url = [NSURL URLWithString:delegate.dataManager.splashArray[randomIndex][@"imageUrl"]];
    [_splashImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"availableYet"]];
    UITapGestureRecognizer *splashTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(splashTap:)];
    _splashImage.userInteractionEnabled = YES;
    splashTap.delegate = self;
    [_splashImage addGestureRecognizer:splashTap];
    [self.view addSubview:self.splashImage];
    
    
    self.removeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60*layout, 35*layout, 40*layout, 40*layout)];
    self.removeButton.backgroundColor = [UIColor clearColor];
    [self.removeButton setImage:[UIImage imageNamed:@"Ps-x-button"] forState:UIControlStateNormal];
    [self.removeButton addTarget:self action:@selector(removeAD) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.removeButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) removeAD
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)splashTap:(UITapGestureRecognizer *)tap
{
    AppDelegate *delegate = GetDM;
    
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y;
    _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, navHeight+60*layout, self.view.frame.size.width,self.view.frame.size.height-navHeight-60*layout)];
    self.webview.delegate = self;
    NSString *url= @"http://www.";
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", delegate.dataManager.splashArray[randomIndex][@"siteUrl"]]];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"/"]];
    NSURL *nsurl= [NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [_webview loadRequest:nsrequest];
    
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60*layout)];
    navBar.backgroundColor = [UIColor whiteColor];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navItem.leftBarButtonItem = leftButton;
    navBar.items = @[ navItem ];
    
    [self.view addSubview:navBar];
    
    [self.view addSubview:_webview];
    
}

- (void) back
{
    [self.webview removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)goBack:(id)sender
{
    [self.webview goBack];
}

/*
 - (void)resumeTimer {
 AppDelegate *delegate = GetDM;
 
 if(delegate.dataManager.splashTimer) {
 [delegate.dataManager.splashTimer invalidate];
 delegate.dataManager.splashTimer = nil;
 }
 delegate.dataManager.splashTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(fireTimer:) userInfo:nil repeats:YES];
 }
 - (void)pauseTimer {
 AppDelegate *delegate = GetDM;
 
 [delegate.dataManager.splashTimer invalidate];
 delegate.dataManager.splashTimer = nil;
 }
 
 - (void)fireTimer:(NSTimer *)inTimer {
 
 SplashADViewController *vc = [[SplashADViewController alloc] init];
 [self presentViewController:vc animated:YES completion:nil];
 
 }
 */

@end
