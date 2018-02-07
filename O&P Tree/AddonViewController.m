//
//  AddonViewController.m
//  O&P Tree
//
//  Created by Mobile Developer on 3/3/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

#import "AddonViewController.h"
#import "UIImageView+WebCache.h"
#import "SplashADViewController.h"
#import "AppDelegate.h"

#define layout self.view.frame.size.height/736.0f

@interface AddonViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
{
    NSInteger randomIndex;
}

@property (strong, nonatomic) UITableView *codeTableView;
@property (strong, nonatomic) UIImageView *bannerImageView;
@property (strong, nonatomic) UIWebView *webview;
@end

@implementation AddonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBannerNoti:) name:@"changeBannerImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSplashNoti:) name:@"changeSplashImage" object:nil];
    
    
    
    
    self.title = @"Add on codes";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.codeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5*layout, self.view.frame.size.width, self.view.frame.size.height-66*layout) style:UITableViewStyleGrouped];
    self.codeTableView.dataSource = self;
    self.codeTableView.delegate = self;
    [self.codeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.codeTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.codeTableView];
    
    
    AppDelegate *delegate = GetDM;
    self.bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-59*layout, self.view.frame.size.width, 59*layout)];
    NSURL *url = [NSURL URLWithString:delegate.dataManager.bannerArray[randomIndex][@"imageUrl"]];
    [self.bannerImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"availableYet"]];
    self.bannerImageView.layer.cornerRadius = 3.0f;
    UITapGestureRecognizer *bannerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTap:)];
    self.bannerImageView.userInteractionEnabled = YES;
    bannerTap.delegate = self;
    [self.bannerImageView addGestureRecognizer:bannerTap];
    [self.view addSubview:self.bannerImageView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *delegate = GetDM;
    
    return delegate.dataManager.addonArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    AppDelegate *delegate = GetDM;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"codeNameTableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"codeNameTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:226/255.0 green:231/255.0 blue:235/255.0 alpha:1.0];
    
    UIView *celldBackgroundItemsView = [cell.contentView viewWithTag:2019];
    if (celldBackgroundItemsView == nil) {
        celldBackgroundItemsView = [[UIView alloc] initWithFrame:CGRectMake(2*layout, 1*layout, self.view.frame.size.width-4*layout, 79*layout)];
        celldBackgroundItemsView.tag = 2019;
        celldBackgroundItemsView.layer.cornerRadius = 3.0f;
        celldBackgroundItemsView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:celldBackgroundItemsView];
    }
    
    
    UILabel *codenameLabel = [cell.contentView viewWithTag:2020];
    if (codenameLabel == nil) {
        codenameLabel = [[UILabel alloc] init];
        codenameLabel.tag = 2020;
        codenameLabel.frame = CGRectMake(20*layout, 10*layout, 200*layout, 30*layout);
        codenameLabel.backgroundColor = [UIColor clearColor];
        codenameLabel.textColor = [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1.0];
        codenameLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
        [cell.contentView addSubview:codenameLabel];
    }
    codenameLabel.text = delegate.dataManager.addonArray[indexPath.row][@"roleName"];
    
    
    UIButton *cartButton = [cell.contentView viewWithTag:2000];
    if (cartButton == nil) {
        cartButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50*layout, 5*layout, 40*layout, 35*layout)];
        cartButton.tag = 2000;
        [cartButton setImage:[UIImage imageNamed:@"cart-add"] forState:UIControlStateNormal];
        [cartButton setShowsTouchWhenHighlighted:YES];
        [cartButton addTarget:self action:@selector(clickCartButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cartButton];
    }
    BOOL cartFlag = true;
    for (int i=0; i<delegate.dataManager.cartArray.count; i++) {
        if ([[NSString stringWithFormat:@"%@", delegate.dataManager.addonArray[indexPath.row][@"roleName"]] isEqualToString:[NSString stringWithFormat:@"%@", delegate.dataManager.cartArray[i][@"codeName"]]]) {
            cartFlag = false;
            break;
        }
    }
    if (cartFlag) {
        [cartButton setImage:[UIImage imageNamed:@"cart-add"] forState:UIControlStateNormal];
    } else
        [cartButton setImage:[UIImage imageNamed:@"cart-delete"] forState:UIControlStateNormal];

    
    
    UITextView *codeDescriptionLabel = [cell.contentView viewWithTag:2021];
    if (codeDescriptionLabel == nil) {
        codeDescriptionLabel = [[UITextView alloc] init];
        codeDescriptionLabel.tag = 2021;
        codeDescriptionLabel.frame = CGRectMake(30*layout, 35*layout, self.view.frame.size.width - 50*layout, 20*layout);
        codeDescriptionLabel.backgroundColor = [UIColor clearColor];
        codeDescriptionLabel.textColor = [UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1.0];
        codeDescriptionLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:14*layout];
        codeDescriptionLabel.editable = NO;
        codeDescriptionLabel.scrollEnabled = NO;
        codeDescriptionLabel.userInteractionEnabled = NO;
        [cell.contentView addSubview:codeDescriptionLabel];
    }
    NSString *str = delegate.dataManager.addonArray[indexPath.row][@"description"];
    CGSize textViewSize = [str sizeWithFont:[UIFont fontWithName:@"Montserrat-Regular" size:15*layout]
                          constrainedToSize:CGSizeMake(self.view.frame.size.width-50*layout, FLT_MAX)
                              lineBreakMode:UILineBreakModeTailTruncation];
    
    codeDescriptionLabel.text = delegate.dataManager.addonArray[indexPath.row][@"description"];
    codeDescriptionLabel.frame = CGRectMake(30*layout, 35*layout, self.view.frame.size.width - 50*layout, textViewSize.height+20*layout);
    
    celldBackgroundItemsView.frame = CGRectMake(2*layout, 1*layout, self.view.frame.size.width-4*layout, textViewSize.height+60*layout);
    
    return cell;
    
}


#pragma mark - TableView Delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate = GetDM;
    
    NSString *str = delegate.dataManager.addonArray[indexPath.row][@"description"];
    CGSize textViewSize = [str sizeWithFont:[UIFont fontWithName:@"Montserrat-Regular" size:15*layout]
                          constrainedToSize:CGSizeMake(self.view.frame.size.width-50*layout, FLT_MAX)
                              lineBreakMode:UILineBreakModeTailTruncation];
    
    return textViewSize.height+61*layout;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}



#pragma mark - get Noti
-(void) changeBannerNoti:(NSNotification*) noti{
    AppDelegate *delegate = GetDM;
    
    if ([noti.name isEqualToString:@"changeBannerImage"]) {
        randomIndex = arc4random()%[delegate.dataManager.bannerArray count];
        NSURL *url = [NSURL URLWithString:delegate.dataManager.bannerArray[randomIndex][@"imageUrl"]];
        [self.bannerImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"availableYet"]];
    }
}


-(void) changeSplashNoti:(NSNotification*) noti{
    if ([noti.name isEqualToString:@"changeSplashImage"]) {
        
        SplashADViewController *vc = [[SplashADViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        
    }
}

- (void)bannerTap:(UITapGestureRecognizer *)tap
{
    AppDelegate *delegate = GetDM;
    
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y;
    _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, navHeight, self.view.frame.size.width,self.view.frame.size.height-navHeight)];
    NSString *url= @"http://www.";
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", delegate.dataManager.bannerArray[randomIndex][@"siteUrl"]]];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"/"]];
    NSURL *nsurl= [NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [_webview loadRequest:nsrequest];
    [self.view addSubview:_webview];
    
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navHeight)];
    navBar.backgroundColor = [UIColor whiteColor];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navItem.leftBarButtonItem = leftButton;
    navBar.items = @[ navItem ];
    
    [self.view addSubview:navBar];
    
    
    self.navigationController.navigationBarHidden = YES;
    _bannerImageView.hidden = YES;
}


- (void) back
{
    [self.webview removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
    _bannerImageView.hidden = NO;
    
}


#pragma mark - click addCart Button
- (void) clickCartButton : (UIButton *) buttonTag
{
    AppDelegate *delegate = GetDM;
    
    
    UIView* contentView = buttonTag.superview;
    UITableViewCell* cell = (UITableViewCell*)contentView.superview;
    NSIndexPath* indexPath = [self.codeTableView indexPathForCell:cell];
    
    BOOL cartFlag = true;
    NSInteger tempInteger = 0;
    for (int i=0; i<delegate.dataManager.cartArray.count; i++) {
        if ([[NSString stringWithFormat:@"%@", delegate.dataManager.addonArray[indexPath.row][@"roleName"]] isEqualToString:[NSString stringWithFormat:@"%@", delegate.dataManager.cartArray[i][@"codeName"]]]) {
            cartFlag = false;
            tempInteger = i;
            break;
        }
    }
    if (cartFlag) {
        NSDictionary *tempDic = @{@"codeName" : delegate.dataManager.addonArray[indexPath.row][@"roleName"], @"codeDescription" : delegate.dataManager.addonArray[indexPath.row][@"description"] , @"detailImg" : @"1234567890"};
        [delegate.dataManager.cartArray addObject:tempDic];
    } else
        [delegate.dataManager.cartArray removeObjectAtIndex:tempInteger];
    
    
    [self.codeTableView reloadData];
    
}


@end
