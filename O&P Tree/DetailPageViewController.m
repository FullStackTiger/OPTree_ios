//
//  DetailPageViewController.m
//  O&P Tree
//
//  Created by Mobile Developer on 3/3/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

#import "DetailPageViewController.h"
#import "AddonViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SplashADViewController.h"

#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

static NSString *const BaseURLString = @"http://54.190.195.16:3000/api/";

#define Pagelayout self.view.frame.size.height/736.0f

@interface DetailPageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
{
    NSInteger randomIndex;
}


@property (strong, nonatomic) UIScrollView *backgroundScrollView;

@property (strong, nonatomic) UICollectionView *photoCollectionView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UITextView *descriptionTextView;

@property (strong, nonatomic) UIButton *favoritesButton;
@property (strong, nonatomic) UIButton *addonButton;
@property (strong, nonatomic) UIButton *cartButton;
@property (assign) BOOL flag;

@property (strong, nonatomic) UIImageView *bannerImageView;
@property (strong, nonatomic) UIActivityIndicatorView *waitingView;
@property (strong, nonatomic) UIWebView *webview;
@end

@implementation DetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBannerNoti:) name:@"changeBannerImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSplashNoti:) name:@"changeSplashImage" object:nil];
    
    
    
    self.title = @"Detail Page";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    AppDelegate *delegate = GetDM;
    
    NSString *str = delegate.dataManager.detailInfo[@"code"][@"codeDescription"];
    CGSize textViewSize = [str sizeWithFont:[UIFont fontWithName:@"Montserrat-Regular" size:15*Pagelayout]
                          constrainedToSize:CGSizeMake(self.view.frame.size.width-50*Pagelayout, FLT_MAX)
                              lineBreakMode:UILineBreakModeTailTruncation];
    
    if ([[NSString stringWithFormat:@"%@", [delegate.dataManager.detailInfo objectForKey:@"favorite"]]   isEqual: @"1"]) {
        self.flag = YES;
    } else
        self.flag = NO;
    
    
    
    
    
    self.backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-60*Pagelayout)];
    self.backgroundScrollView.backgroundColor = [UIColor whiteColor];
    self.backgroundScrollView.contentSize = CGSizeMake(self.view.frame.size.width, textViewSize.height);
    self.backgroundScrollView.scrollEnabled = YES;
    self.backgroundScrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.backgroundScrollView];
    
    
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.photoCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(20*Pagelayout, 10*Pagelayout, self.backgroundScrollView.frame.size.width-40*Pagelayout, self.backgroundScrollView.frame.size.width-40*Pagelayout) collectionViewLayout:layout];
    self.photoCollectionView.backgroundColor = [UIColor whiteColor];
    [self.photoCollectionView setDataSource:self];
    [self.photoCollectionView setDelegate:self];
    [self.photoCollectionView flashScrollIndicators];
    [self.photoCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.backgroundScrollView addSubview:self.photoCollectionView];
    
    
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*Pagelayout, self.photoCollectionView.frame.size.height+self.photoCollectionView.frame.origin.y, self.view.frame.size.width/2, 50*Pagelayout)];
    self.nameLabel.text = delegate.dataManager.detailInfo[@"code"][@"codeName"];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:25*Pagelayout];
    self.nameLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.backgroundScrollView addSubview:self.nameLabel];
    
    
    
    self.descriptionTextView = [[UITextView alloc] init];
    self.descriptionTextView.frame = CGRectMake(30*Pagelayout, self.nameLabel.frame.size.height+self.nameLabel.frame.origin.y-15*Pagelayout, self.view.frame.size.width-50*Pagelayout, textViewSize.height+40*Pagelayout);
    self.descriptionTextView.backgroundColor = [UIColor clearColor];
    self.descriptionTextView.textColor = [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1.0];
    self.descriptionTextView.font = [UIFont fontWithName:@"Montserrat-Regular" size:15*Pagelayout];
    self.descriptionTextView.editable = NO;
    self.descriptionTextView.scrollEnabled = NO;
    self.descriptionTextView.userInteractionEnabled = NO;
    self.descriptionTextView.text = str;
    self.descriptionTextView.backgroundColor = [UIColor whiteColor];
    [self.backgroundScrollView addSubview:self.descriptionTextView];
    
    
    CGFloat positionForButton = self.descriptionTextView.frame.size.height+self.descriptionTextView.frame.origin.y;
    
    self.favoritesButton = [[UIButton alloc] initWithFrame:CGRectMake(50*Pagelayout, positionForButton, 35*Pagelayout, 35*Pagelayout)];
    self.favoritesButton.backgroundColor = [UIColor clearColor];
    if (self.flag) {
        [self.favoritesButton setImage:[UIImage imageNamed:@"favorites1"] forState:UIControlStateNormal];
    } else
        [self.favoritesButton setImage:[UIImage imageNamed:@"favorites_unfill"] forState:UIControlStateNormal];
    [self.favoritesButton addTarget:self action:@selector(clickFavoritesButton) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundScrollView addSubview:_favoritesButton];
    
    
    BOOL cartFlag = true;
    self.cartButton = [[UIButton alloc] initWithFrame:CGRectMake(100*Pagelayout, positionForButton, 40*Pagelayout, 30*Pagelayout)];
    for (int i=0; i<delegate.dataManager.cartArray.count; i++) {
        if ([[NSString stringWithFormat:@"%@", delegate.dataManager.detailInfo[@"code"][@"codeName"]] isEqualToString:[NSString stringWithFormat:@"%@", delegate.dataManager.cartArray[i][@"codeName"]]]) {
            cartFlag = false;
            break;
        }
    }
    if (cartFlag) {
        [self.cartButton setImage:[UIImage imageNamed:@"cart-add"] forState:UIControlStateNormal];
    } else
        [self.cartButton setImage:[UIImage imageNamed:@"cart-delete"] forState:UIControlStateNormal];
    [self.cartButton addTarget:self action:@selector(clickCartButton) forControlEvents:UIControlEventTouchUpInside];
    self.cartButton.showsTouchWhenHighlighted = YES;
    [self.backgroundScrollView addSubview:self.cartButton];

    
    
    self.addonButton = [[UIButton alloc] initWithFrame:CGRectMake(290*Pagelayout, positionForButton, 100*Pagelayout, 35*Pagelayout)];
    self.addonButton.backgroundColor = [UIColor clearColor];
    self.addonButton.backgroundColor = [UIColor colorWithRed:81/255.0 green:170/255.0 blue:81/255.0 alpha:1.0];
    [self.addonButton setTitle:@"Add-on codes" forState:UIControlStateNormal];
    self.addonButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:16*Pagelayout];
    self.addonButton.layer.cornerRadius = 3.0f*Pagelayout;
    [self.addonButton setShowsTouchWhenHighlighted:YES];
    [self.addonButton addTarget:self action:@selector(clickAddonButton) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundScrollView addSubview:self.addonButton];
    if ([delegate.dataManager.detailInfo[@"addon"] count] == 0) {
        self.addonButton.hidden = YES;
    }
    
    
    
    self.backgroundScrollView.contentSize = CGSizeMake(self.view.frame.size.width, positionForButton+50*Pagelayout);
    if (positionForButton < self.backgroundScrollView.frame.size.height-120*Pagelayout) {
        self.favoritesButton.frame = CGRectMake(35*Pagelayout, self.backgroundScrollView.frame.size.height-130*Pagelayout, 35*Pagelayout, 35*Pagelayout);
        self.addonButton.frame = CGRectMake(270*Pagelayout, self.backgroundScrollView.frame.size.height-130*Pagelayout, 120*Pagelayout, 35*Pagelayout);
        self.cartButton.frame = CGRectMake(100*Pagelayout, self.backgroundScrollView.frame.size.height-130*Pagelayout, 40*Pagelayout, 35*Pagelayout);
    }
    
    
    self.bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-59*Pagelayout, self.view.frame.size.width, 59*Pagelayout)];
    NSURL *url = [NSURL URLWithString:delegate.dataManager.bannerArray[randomIndex][@"imageUrl"]];
    [self.bannerImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"availableYet"]];
    self.bannerImageView.layer.cornerRadius = 3.0f;
    UITapGestureRecognizer *bannerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTap:)];
    self.bannerImageView.userInteractionEnabled = YES;
    bannerTap.delegate = self;
    [self.bannerImageView addGestureRecognizer:bannerTap];
    [self.view addSubview:self.bannerImageView];
    
    
    
}


#pragma mark - collectionView datasource and delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    AppDelegate *delegate = GetDM;
    if([delegate.dataManager.detailInfo[@"code"][@"details"] count] == 0) {
        return 1;
    }
    return [delegate.dataManager.detailInfo[@"code"][@"details"] count];
    
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate = GetDM;
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    
    UIImageView *cellImage = [cell.contentView viewWithTag:2100];
    if (cellImage == nil) {
        cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.photoCollectionView.frame.size.width/3, self.photoCollectionView.frame.size.width/3)];
        cellImage.tag = 2100;
        cellImage.frame = CGRectMake(0, -10*Pagelayout, self.photoCollectionView.frame.size.width/1.4, self.photoCollectionView.frame.size.width/1.4);
        cellImage.backgroundColor = [UIColor clearColor];
        cellImage.layer.cornerRadius = 3.0;
        [cell.contentView addSubview:cellImage];
    }
    if([delegate.dataManager.detailInfo[@"code"][@"details"] count] == 0) {
        [cellImage setImage:[UIImage imageNamed:@"availableYet"]];
    } else {
        NSURL *url = [NSURL URLWithString:delegate.dataManager.detailInfo[@"code"][@"details"][indexPath.section][@"imageUrl"]];
        [cellImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"availableYet"]];
    }
    //    UITapGestureRecognizer *detailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTap:)];
    //    cellImage.userInteractionEnabled = YES;
    //    detailTap.delegate = self;
    //    [cellImage addGestureRecognizer:detailTap];
    
    
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.photoCollectionView.frame.size.width/1.4, self.photoCollectionView.frame.size.width/1.4);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate = GetDM;
    
    if ([delegate.dataManager.detailInfo[@"code"][@"details"] count] != 0) {
        CGFloat navHeight = self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y;
        _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, navHeight, self.view.frame.size.width,self.view.frame.size.height-navHeight)];
        NSString *url= @"http://www.";
        url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", delegate.dataManager.detailInfo[@"code"][@"details"][indexPath.section][@"siteUrl"]]];
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void) clickCartButton
{
    AppDelegate *delegate = GetDM;
    
    BOOL cartFlag = true;
    NSInteger tempInteger = 0;
    for (int i=0; i<delegate.dataManager.cartArray.count; i++) {
        if ([[NSString stringWithFormat:@"%@", delegate.dataManager.detailInfo[@"code"][@"codeName"]] isEqualToString:[NSString stringWithFormat:@"%@", delegate.dataManager.cartArray[i][@"codeName"]]]) {
            cartFlag = false;
            tempInteger = i;
            break;
        }
    }
    NSString *tempStr;
    if ([delegate.dataManager.detailInfo[@"code"][@"details"] count] == 0) {
        tempStr = @"123456789";
    } else
        tempStr = [NSString stringWithFormat:@"%@", delegate.dataManager.detailInfo[@"code"][@"details"][0][@"imageUrl"]];
    if (cartFlag) {
        NSDictionary *tempDic = @{@"codeName" : delegate.dataManager.detailInfo[@"code"][@"codeName"], @"codeDescription" : delegate.dataManager.detailInfo[@"code"][@"codeDescription"], @"detailImg" : tempStr};
        [delegate.dataManager.cartArray addObject:tempDic];
        [self.cartButton setImage:[UIImage imageNamed:@"cart-delete"] forState:UIControlStateNormal];
    } else {
        [delegate.dataManager.cartArray removeObjectAtIndex:tempInteger];
        [self.cartButton setImage:[UIImage imageNamed:@"cart-add"] forState:UIControlStateNormal];
    }
}

- (void) clickFavoritesButton
{
    
    AppDelegate *delegate = GetDM;
    
    self.waitingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25*Pagelayout, self.view.frame.size.height/2-25*Pagelayout, 50*Pagelayout, 50*Pagelayout)];
    [self.waitingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.waitingView setColor:[UIColor blackColor]];
    self.waitingView.hidesWhenStopped = YES;
    [self.view addSubview:self.waitingView];
    self.view.userInteractionEnabled = NO;
    [self.waitingView startAnimating];
    
    BOOL cartFlag = true;
    NSInteger tempInteger = 0;
    for (int i=0; i<delegate.dataManager.favoritesArray.count; i++) {
        if ([[NSString stringWithFormat:@"%@", delegate.dataManager.detailInfo[@"code"][@"codeName"]] isEqualToString:[NSString stringWithFormat:@"%@", delegate.dataManager.favoritesArray[i][@"cname"]]]) {
            cartFlag = false;
            tempInteger = i;
            break;
        }
    }
    if (cartFlag) {
        NSString *String = BaseURLString;
        String = [String stringByAppendingString:[NSString stringWithFormat:@"add_favitem"]];
        NSURL *URL = [NSURL URLWithString:String];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSString *imgUrl;
        if ([delegate.dataManager.detailInfo[@"code"][@"details"] count] != 0) {
            imgUrl = delegate.dataManager.detailInfo[@"code"][@"details"][0][@"imageUrl"];
        }else
            imgUrl = @"";
        
        [manager POST:URL.absoluteString parameters:@{@"userid":delegate.dataManager.userID , @"cname":delegate.dataManager.detailInfo[@"code"][@"codeName"] , @"description" : delegate.dataManager.detailInfo[@"code"][@"codeDescription"] , @"imgUrl" : imgUrl} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            if ([[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"success"]]   isEqual: @"1"]) {
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                                message:@"Successfully added to favorites codes"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
                [self.favoritesButton setImage:[UIImage imageNamed:@"favorites1"] forState:UIControlStateNormal];
                
                NSDictionary *favDic = @{@"cname":delegate.dataManager.detailInfo[@"code"][@"codeName"], @"description":delegate.dataManager.detailInfo[@"code"][@"codeDescription"], @"imgUrl":imgUrl};
                [delegate.dataManager.favoritesArray addObject:favDic];
                
                
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
    } else {
        NSString *String = BaseURLString;
        String = [String stringByAppendingString:[NSString stringWithFormat:@"del_favitem"]];
        NSURL *URL = [NSURL URLWithString:String];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setValue:delegate.dataManager.token forHTTPHeaderField:@"Authorization"];
        
        [manager POST:URL.absoluteString parameters:@{@"userid":delegate.dataManager.userID , @"cname":delegate.dataManager.detailInfo[@"code"][@"codeName"]} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            if ([[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"success"]]   isEqual: @"1"]) {
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                                message:@"Successfully deleted from favorites codes"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];

                
                [delegate.dataManager.favoritesArray removeObjectAtIndex:tempInteger];
                [self.favoritesButton setImage:[UIImage imageNamed:@"favorites_unfill"] forState:UIControlStateNormal];
                
                [self.waitingView stopAnimating];
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
    
}


- (void) clickAddonButton
{
    AppDelegate *delegate = GetDM;
    [delegate.dataManager.addonArray removeAllObjects];
    [delegate.dataManager.addonArray addObjectsFromArray:delegate.dataManager.detailInfo[@"addon"]];
    
    AddonViewController *vc = [[AddonViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
