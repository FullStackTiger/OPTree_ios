//
//  FavoritesViewController.m
//  O&P Tree
//
//  Created by Mobile Developer on 3/2/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

#import "FavoritesViewController.h"
#import "SWRevealViewController.h"
#import "DetailPageViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SplashADViewController.h"

#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

static NSString *const BaseURLString = @"http://54.190.195.16:3000/api/";

#define layout self.view.frame.size.height/736.0f

@interface FavoritesViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
{
    NSInteger randomIndex;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property (strong, nonatomic) NSMutableArray *searchArray;

@property (strong, nonatomic) UISearchBar *searchbar;
@property (strong, nonatomic) UITableView *codeTableView;
@property (strong, nonatomic) UIImageView *bannerImageView;
@property (strong, nonatomic) UIActivityIndicatorView *waitingView;
@property (strong, nonatomic) UIActivityIndicatorView *waitingView2;
@property (strong, nonatomic) UIWebView *webview;
@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBannerNoti:) name:@"changeBannerImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSplashNoti:) name:@"changeSplashImage" object:nil];
    
    
    self.title = @"Favorites";
    
    [self.navigationController.navigationBar setBarTintColor : [UIColor colorWithRed:240/255.0 green:197/255.0 blue:24/255.0 alpha:1.0] ];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        _menuButton.target = self.revealViewController;
        _menuButton.action = @selector(revealToggle:);
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.searchbar = [[UISearchBar alloc] init];
    self.searchbar.frame = CGRectMake(5*layout, self.navigationController.navigationBar.frame.size.height+30, self.view.frame.size.width-10*layout,40*layout);
    self.searchbar.delegate = self;
    self.searchbar.autocapitalizationType  = UITextAutocapitalizationTypeWords;
    self.searchbar.text = UITextAutocapitalizationTypeNone;
    self.searchbar.barTintColor = [UIColor whiteColor];
    self.searchbar.backgroundColor = [UIColor whiteColor];
    self.searchbar.layer.borderWidth = 1;
    self.searchbar.layer.borderColor = [[UIColor colorWithRed:226/255.0 green:231/255.0 blue:235/255.0 alpha:1.0] CGColor];
    self.searchbar.layer.cornerRadius = 10.0f*layout;
    self.searchbar.placeholder = @"Search";
    self.searchbar.delegate = self;
    [self.searchbar setReturnKeyType:UIReturnKeyDone];
    [self.searchbar setEnablesReturnKeyAutomatically:NO];
    [self.searchbar setBackgroundImage:[[UIImage alloc]init]];
    [self.view addSubview:self.searchbar];
    
    CGFloat height = self.searchbar.frame.size.height+self.searchbar.frame.origin.y;
    
    self.codeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height+5*layout, self.view.frame.size.width, self.view.frame.size.height-height-66*layout) style:UITableViewStyleGrouped];
    self.codeTableView.dataSource = self;
    self.codeTableView.delegate = self;
    [self.codeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.codeTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.codeTableView];
    
    CGFloat tableHeight = self.codeTableView.frame.size.height+self.codeTableView.frame.origin.y;
    
    AppDelegate *delegate = GetDM;

    self.bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, tableHeight+2*layout, self.view.frame.size.width, 59*layout)];
    NSURL *url = [NSURL URLWithString:delegate.dataManager.bannerArray[randomIndex][@"imageUrl"]];
    [self.bannerImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"availableYet"]];
    self.bannerImageView.layer.cornerRadius = 3.0f;
    UITapGestureRecognizer *bannerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTap:)];
    self.bannerImageView.userInteractionEnabled = YES;
    bannerTap.delegate = self;
    [self.bannerImageView addGestureRecognizer:bannerTap];
    [self.view addSubview:self.bannerImageView];
    
    
    self.searchArray = [[NSMutableArray alloc] initWithArray:delegate.dataManager.favoritesArray];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchBar delegate
bool isSearchingFlag = YES;

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearchingFlag = YES;
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    AppDelegate *delegate = GetDM;
    
    [self.searchArray removeAllObjects];
    
    for (int i=0; i<delegate.dataManager.favoritesArray.count; i++) {
        if ([[NSString stringWithFormat:@"%@", delegate.dataManager.favoritesArray[i][@"cname"]].lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound) {
            [self.searchArray addObject:delegate.dataManager.favoritesArray[i]];
        }
    }
    if ([searchText isEqualToString:@""]) {
        [self.searchArray removeAllObjects];
        [self.searchArray addObjectsFromArray:delegate.dataManager.favoritesArray];
    }
    if([searchText length] != 0) {
        isSearchingFlag = YES;
    }
    else {
        isSearchingFlag = NO;
    }
    
    [self.codeTableView reloadData];
    
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favoritesTableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"favoritesTableViewCell"];
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
    
    
    
    UIImageView *codeImg = [cell.contentView viewWithTag:2020];
    if (codeImg == nil) {
        codeImg = [[UIImageView alloc] initWithFrame:CGRectMake(10*layout, 10*layout, 58*layout, 58*layout)];
        codeImg.tag = 2020;
        codeImg.backgroundColor = [UIColor clearColor];
        codeImg.layer.cornerRadius = 3.0f;
        [cell.contentView addSubview:codeImg];
    }
    if ([[NSString stringWithFormat:@"%@", self.searchArray[indexPath.row][@"imgUrl"]] isEqualToString:@""]) {
        [codeImg setImage:[UIImage imageNamed:@"availableYet"]];
    } else {
        NSURL *url = [NSURL URLWithString:self.searchArray[indexPath.row][@"imgUrl"]];
        [codeImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"availableYet"]];
    }
    
    
    
    UILabel *codenameLabel = [cell.contentView viewWithTag:2021];
    if (codenameLabel == nil) {
        codenameLabel = [[UILabel alloc] init];
        codenameLabel.frame = CGRectMake(90*layout, 10*layout, 200*layout, 30*layout);
        codenameLabel.tag = 2021;
        codenameLabel.backgroundColor = [UIColor clearColor];
        codenameLabel.textColor = [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1.0];
        codenameLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
        [cell.contentView addSubview:codenameLabel];
    }
    codenameLabel.text = self.searchArray[indexPath.row][@"cname"];
    
    
    
    UILabel *codeDescriptionLabel = [cell.contentView viewWithTag:2022];
    if (codeDescriptionLabel == nil) {
        codeDescriptionLabel = [[UILabel alloc] init];
        codeDescriptionLabel.tag = 2022;
        codeDescriptionLabel.frame = CGRectMake(90*layout, 45*layout, self.view.frame.size.width - 110*layout, 20*layout);
        codeDescriptionLabel.backgroundColor = [UIColor clearColor];
        codeDescriptionLabel.textColor = [UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1.0];
        codeDescriptionLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:14*layout];
        [cell.contentView addSubview:codeDescriptionLabel];
    }
    codeDescriptionLabel.text = self.searchArray[indexPath.row][@"description"];
    
    
    return cell;
    
}


#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate = GetDM;
    
    self.waitingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25*layout, self.view.frame.size.height/2-25*layout, 50*layout, 50*layout)];
    [self.waitingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.waitingView setColor:[UIColor blackColor]];
    self.waitingView.hidesWhenStopped = YES;
    [self.view addSubview:self.waitingView];
    self.view.userInteractionEnabled = NO;
    [self.waitingView startAnimating];
    
    
    
    NSString *String = BaseURLString;
    String = [String stringByAppendingString:[NSString stringWithFormat:@"code"]];
    NSURL *URL = [NSURL URLWithString:String];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:URL.absoluteString parameters:@{@"codeName":self.searchArray[indexPath.row][@"cname"] , @"userid":delegate.dataManager.userID} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        if ([[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"success"]]   isEqual: @"1"]) {
            
            delegate.dataManager.detailInfo = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            
            
            DetailPageViewController *vc = [[DetailPageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
            [self.waitingView stopAnimating];
            self.view.userInteractionEnabled = YES;
            
            
        } else{
            NSString *messageStr = [responseObject objectForKey:@"message"];
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                            message:messageStr
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            [self.waitingView stopAnimating];
            self.view.userInteractionEnabled = YES;
            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:@"Internet disconnect"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        [self.waitingView stopAnimating];
        self.view.userInteractionEnabled = YES;
    }];
    
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate = GetDM;
    
    self.waitingView2 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25*layout, self.view.frame.size.height/2-25*layout, 50*layout, 50*layout)];
    [self.waitingView2 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.waitingView2 setColor:[UIColor blackColor]];
    self.waitingView2.hidesWhenStopped = YES;
    [self.view addSubview:self.waitingView2];
    self.view.userInteractionEnabled = NO;
    [self.waitingView2 startAnimating];
    
    
    NSString *String = BaseURLString;
    String = [String stringByAppendingString:[NSString stringWithFormat:@"del_favitem"]];
    NSURL *URL = [NSURL URLWithString:String];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:delegate.dataManager.token forHTTPHeaderField:@"Authorization"];
    
    [manager POST:URL.absoluteString parameters:@{@"userid":delegate.dataManager.userID , @"cname":self.searchArray[indexPath.row][@"cname"]} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        if ([[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"success"]]   isEqual: @"1"]) {
            
            [delegate.dataManager.favoritesArray removeObjectAtIndex:indexPath.row];
            
            [self.searchArray removeAllObjects];
            [self.searchArray addObjectsFromArray:delegate.dataManager.favoritesArray];
            
            [self.codeTableView reloadData];
            
            [self.waitingView2 stopAnimating];
            self.view.userInteractionEnabled = YES;
            
        } else{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                            message:@"Can't delete it.\nPlease try it later."
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
            [self.waitingView2 stopAnimating];
            self.view.userInteractionEnabled = YES;
            
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:@"Internet disconnect"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        [self.waitingView2 stopAnimating];
        self.view.userInteractionEnabled = YES;
        
    }];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0*layout;
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

@end
