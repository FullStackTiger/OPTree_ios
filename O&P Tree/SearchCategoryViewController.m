//
//  SearchCategoryViewController.m
//  O&P Tree
//
//  Created by Mobile Developer on 3/2/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

#import "SearchCategoryViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "DetailPageViewController.h"
#import "UIImageView+WebCache.h"
#import "SplashADViewController.h"

#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

static NSString *const BaseURLString = @"http://54.190.195.16:3000/api/";

#define layout self.view.frame.size.height/736.0f

@interface SearchCategoryViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
{
    NSInteger passIndex;
    NSInteger randomIndex;
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

//@property (strong, nonatomic) UITableView *codeTableView;
@property (strong, nonatomic) UITableView *categoryTableView;
@property (strong, nonatomic) UIImageView *bannerImageView;

@property (strong, nonatomic) NSMutableArray *categoryArray;

@property (strong, nonatomic) UIButton *firstButon;
@property (strong, nonatomic) UIButton *secondButton;
@property (strong, nonatomic) UIButton *thirdButton;
@property (strong, nonatomic) UIButton *forthButton;
@property (strong, nonatomic) UIButton *fifthButton;
@property (strong, nonatomic) UIButton *sixthButton;

@property (strong, nonatomic) UIImageView *symbolImg1;
@property (strong, nonatomic) UIImageView *symbolImg2;
@property (strong, nonatomic) UIImageView *symbolImg3;
@property (strong, nonatomic) UIImageView *symbolImg4;
@property (strong, nonatomic) UIImageView *symbolImg5;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) NSMutableArray *passArray;

@property (strong, nonatomic) UIActivityIndicatorView *waitingView;
@property (strong, nonatomic) UIWebView *webview;

@end

@implementation SearchCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBannerNoti:) name:@"changeBannerImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSplashNoti:) name:@"changeSplashImage" object:nil];
    
    
    
    self.title = @"Search by Category";
    
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
    
    CGFloat naviHeight = self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y;
    
    /////////////////////////**************  > Symbol     *************************//////////////////////////
    self.symbolImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6, naviHeight+20*layout, 7*layout, 15*layout)];
    self.symbolImg1.backgroundColor = [UIColor clearColor];
    [self.symbolImg1 setImage:[UIImage imageNamed:@"symbol"]];
    [self.view addSubview:self.symbolImg1];
    self.symbolImg1.hidden = YES;
    
    
    self.symbolImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6*2, naviHeight+20*layout, 7*layout, 15*layout)];
    self.symbolImg2.backgroundColor = [UIColor clearColor];
    [self.symbolImg2 setImage:[UIImage imageNamed:@"symbol"]];
    [self.view addSubview:self.symbolImg2];
    self.symbolImg2.hidden = YES;
    
    
    self.symbolImg3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6*3, naviHeight+20*layout, 7*layout, 15*layout)];
    self.symbolImg3.backgroundColor = [UIColor clearColor];
    [self.symbolImg3 setImage:[UIImage imageNamed:@"symbol"]];
    [self.view addSubview:self.symbolImg3];
    self.symbolImg3.hidden = YES;
    
    
    self.symbolImg4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6*4, naviHeight+20*layout, 7*layout, 15*layout)];
    self.symbolImg4.backgroundColor = [UIColor clearColor];
    [self.symbolImg4 setImage:[UIImage imageNamed:@"symbol"]];
    [self.view addSubview:self.symbolImg4];
    self.symbolImg4.hidden = YES;
    
    
    self.symbolImg5 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6*5, naviHeight+20*layout, 7*layout, 15*layout)];
    self.symbolImg5.backgroundColor = [UIColor clearColor];
    [self.symbolImg5 setImage:[UIImage imageNamed:@"symbol"]];
    [self.view addSubview:self.symbolImg5];
    self.symbolImg5.hidden = YES;
    
    
    
    /////////////////////////**************  Button     *************************//////////////////////////
    self.firstButon = [[UIButton alloc] initWithFrame:CGRectMake(0, naviHeight+12*layout, self.view.frame.size.width/6-0*layout, 30*layout)];
    [self.firstButon setTitle:@"firstButonasdfasdfasdf asdf sdf" forState:UIControlStateNormal];
    self.firstButon.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.firstButon.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:11*layout];
    [self.firstButon setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.firstButon addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
    [self.firstButon setShowsTouchWhenHighlighted:YES];
    self.firstButon.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.firstButon];
    self.firstButon.hidden = YES;
    
    
    self.secondButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6+10*layout, naviHeight+12*layout, self.view.frame.size.width/6-10*layout, 30*layout)];
    [self.secondButton setTitle:@"secondButtonsdf df sdf" forState:UIControlStateNormal];
    self.secondButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.secondButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:11*layout];
    [self.secondButton setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.secondButton addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
    [self.secondButton setShowsTouchWhenHighlighted:YES];
    self.secondButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.secondButton];
    self.secondButton.hidden = YES;
    
    
    self.thirdButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6*2+10*layout, naviHeight+12*layout, self.view.frame.size.width/6-10*layout, 30*layout)];
    [self.thirdButton setTitle:@"thi sdf d df df d r" forState:UIControlStateNormal];
    self.thirdButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.thirdButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:11*layout];
    [self.thirdButton setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.thirdButton addTarget:self action:@selector(click3) forControlEvents:UIControlEventTouchUpInside];
    [self.thirdButton setShowsTouchWhenHighlighted:YES];
    self.thirdButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.thirdButton];
    self.thirdButton.hidden = YES;
    
    
    self.forthButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6*3+10*layout, naviHeight+12*layout, self.view.frame.size.width/6-10*layout, 30*layout)];
    [self.forthButton setTitle:@"forthButdfsd e ton" forState:UIControlStateNormal];
    self.forthButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.forthButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:11*layout];
    [self.forthButton setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.forthButton addTarget:self action:@selector(click4) forControlEvents:UIControlEventTouchUpInside];
    [self.forthButton setShowsTouchWhenHighlighted:YES];
    self.forthButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.forthButton];
    self.forthButton.hidden = YES;
    
    
    self.fifthButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6*4+10*layout, naviHeight+12*layout, self.view.frame.size.width/6-10*layout, 30*layout)];
    [self.fifthButton setTitle:@"fsdfg dfg dfg i" forState:UIControlStateNormal];
    self.fifthButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.fifthButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:11*layout];
    [self.fifthButton setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.fifthButton addTarget:self action:@selector(click5) forControlEvents:UIControlEventTouchUpInside];
    [self.fifthButton setShowsTouchWhenHighlighted:YES];
    self.fifthButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.fifthButton];
    self.fifthButton.hidden = YES;
    
    
    self.sixthButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6*5+10*layout, naviHeight+12*layout, self.view.frame.size.width/6-10*layout, 30*layout)];
    [self.sixthButton setTitle:@"fsdfg dfg dfg i" forState:UIControlStateNormal];
    self.sixthButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.sixthButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:11*layout];
    [self.sixthButton setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.sixthButton addTarget:self action:@selector(click6) forControlEvents:UIControlEventTouchUpInside];
    [self.sixthButton setShowsTouchWhenHighlighted:YES];
    self.sixthButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.sixthButton];
    self.sixthButton.hidden = YES;
    
    
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, naviHeight+48*layout, self.view.frame.size.width, 1)];
    self.lineView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    [self.view addSubview:self.lineView];
    
    
    self.categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, naviHeight+50*layout, self.view.frame.size.width, self.view.frame.size.height-naviHeight-110*layout) style:UITableViewStylePlain];
    self.categoryTableView.dataSource = self;
    self.categoryTableView.delegate = self;
    [self.categoryTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.categoryTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.categoryTableView];
    
    CGFloat tableHeight = self.categoryTableView.frame.size.height+self.categoryTableView.frame.origin.y;
    
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
    
    
    self.categoryArray = [[NSMutableArray alloc] initWithArray:delegate.dataManager.categoryArray];
    self.passArray = [[NSMutableArray alloc] initWithObjects:@"-1", @"-1", @"-1", @"-1", @"-1", @"-1", nil];
    passIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCategoryTableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCategoryTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:226/255.0 green:231/255.0 blue:235/255.0 alpha:1.0];
    
    NSString *str = self.categoryArray[indexPath.row][@"roleName"];
    CGSize textViewSize = [str sizeWithFont:[UIFont fontWithName:@"Montserrat-Regular" size:17*layout]
                          constrainedToSize:CGSizeMake(self.view.frame.size.width-30*layout, FLT_MAX)
                              lineBreakMode:UILineBreakModeTailTruncation];
    
    
    UIView *celldBackgroundItemsView = [cell.contentView viewWithTag:2019];
    if (celldBackgroundItemsView == nil) {
        celldBackgroundItemsView = [[UIView alloc] initWithFrame:CGRectMake(2*layout, 1*layout, self.view.frame.size.width-4*layout, 50*layout)];
        celldBackgroundItemsView.tag = 2019;
        celldBackgroundItemsView.layer.cornerRadius = 3.0f;
        celldBackgroundItemsView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:celldBackgroundItemsView];
    }
    celldBackgroundItemsView.frame = CGRectMake(2*layout, 1*layout, self.view.frame.size.width-4*layout, textViewSize.height+25*layout);
    
    
    
    
    UITextView *codenameTextView = [cell.contentView viewWithTag:2018];
    if (codenameTextView == nil) {
        codenameTextView = [[UITextView alloc] init];
        codenameTextView.tag = 2018;
        codenameTextView.frame = CGRectMake(15*layout, 0*layout, self.view.frame.size.width-30*layout, 50*layout);
        codenameTextView.backgroundColor = [UIColor clearColor];
        codenameTextView.textColor = [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1.0];
        codenameTextView.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
        codenameTextView.editable = NO;
        codenameTextView.scrollEnabled = NO;
        [cell.contentView addSubview:codenameTextView];
    }
    codenameTextView.text = self.categoryArray[indexPath.row][@"roleName"];
    codenameTextView.frame = CGRectMake(15*layout, 1*layout, self.view.frame.size.width-30*layout, textViewSize.height+24*layout);
    codenameTextView.backgroundColor = [UIColor clearColor];
    codenameTextView.userInteractionEnabled = NO;
    codenameTextView.superview.userInteractionEnabled = YES;
    
    [cell bringSubviewToFront:self.view];
    celldBackgroundItemsView.userInteractionEnabled = YES;
    
    cell.superview.userInteractionEnabled = YES;
    cell.userInteractionEnabled = YES;
    
    
    
    UIButton *cartButon = [cell.contentView viewWithTag:2000];
    if (cartButon == nil) {
        cartButon = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50*layout, 7.5*layout, 40*layout, 35*layout)];
        cartButon.tag = 2000;
        [cartButon setImage:[UIImage imageNamed:@"cart-add"] forState:UIControlStateNormal];
        cartButon.showsTouchWhenHighlighted = YES;
        [cartButon addTarget:self action:@selector(clickCartButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cartButon];
    }
    AppDelegate *delegate = GetDM;
    
    if ([self.categoryArray[indexPath.row][@"children"] count] == 0) {
        cartButon.hidden = NO;
        BOOL cartFlag = true;
        for (int i=0; i<delegate.dataManager.cartArray.count; i++) {
            if ([[NSString stringWithFormat:@"%@", self.categoryArray[indexPath.row][@"roleName"]] isEqualToString:[NSString stringWithFormat:@"%@", delegate.dataManager.cartArray[i][@"codeName"]]]) {
                cartFlag = false;
                break;
            }
        }
        if (cartFlag) {
            [cartButon setImage:[UIImage imageNamed:@"cart-add"] forState:UIControlStateNormal];
        } else
            [cartButon setImage:[UIImage imageNamed:@"cart-delete"] forState:UIControlStateNormal];

    } else
        cartButon.hidden = YES;

    
    return cell;
    
}


#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (passIndex == 0) {
        if ([self.categoryArray[indexPath.row][@"children"] count] >= 1) {
            [self.firstButon setTitle:self.categoryArray[indexPath.row][@"roleName"] forState:UIControlStateNormal];
        }
        
        self.firstButon.hidden = NO;
        self.secondButton.hidden = YES;
        self.thirdButton.hidden = YES;
        self.forthButton.hidden = YES;
        self.fifthButton.hidden = YES;
        self.sixthButton.hidden = YES;
        
        self.symbolImg1.hidden = NO;
        self.symbolImg2.hidden = YES;
        self.symbolImg3.hidden = YES;
        self.symbolImg4.hidden = YES;
        self.symbolImg5.hidden = YES;
    } else if (passIndex == 1) {
        if ([self.categoryArray[indexPath.row][@"children"] count] >= 1) {
            [self.secondButton setTitle:self.categoryArray[indexPath.row][@"roleName"] forState:UIControlStateNormal];
        }
        
        self.firstButon.hidden = NO;
        self.secondButton.hidden = NO;
        self.thirdButton.hidden = YES;
        self.forthButton.hidden = YES;
        self.fifthButton.hidden = YES;
        self.sixthButton.hidden = YES;
        
        self.symbolImg1.hidden = NO;
        self.symbolImg2.hidden = NO;
        self.symbolImg3.hidden = YES;
        self.symbolImg4.hidden = YES;
        self.symbolImg5.hidden = YES;
    } else if (passIndex == 2) {
        if ([self.categoryArray[indexPath.row][@"children"] count] >= 1) {
            [self.thirdButton setTitle:self.categoryArray[indexPath.row][@"roleName"] forState:UIControlStateNormal];
        }
        
        self.firstButon.hidden = NO;
        self.secondButton.hidden = NO;
        self.thirdButton.hidden = NO;
        self.forthButton.hidden = YES;
        self.fifthButton.hidden = YES;
        self.sixthButton.hidden = YES;
        
        self.symbolImg1.hidden = NO;
        self.symbolImg2.hidden = NO;
        self.symbolImg3.hidden = NO;
        self.symbolImg4.hidden = YES;
        self.symbolImg5.hidden = YES;
    } else if (passIndex == 3) {
        if ([self.categoryArray[indexPath.row][@"children"] count] >= 1) {
            [self.forthButton setTitle:self.categoryArray[indexPath.row][@"roleName"] forState:UIControlStateNormal];
        }
        
        self.firstButon.hidden = NO;
        self.secondButton.hidden = NO;
        self.thirdButton.hidden = NO;
        self.forthButton.hidden = NO;
        self.fifthButton.hidden = YES;
        self.sixthButton.hidden = YES;
        
        self.symbolImg1.hidden = NO;
        self.symbolImg2.hidden = NO;
        self.symbolImg3.hidden = NO;
        self.symbolImg4.hidden = NO;
        self.symbolImg5.hidden = YES;
    } else if (passIndex == 4) {
        if ([self.categoryArray[indexPath.row][@"children"] count] >= 1) {
            [self.fifthButton setTitle:self.categoryArray[indexPath.row][@"roleName"] forState:UIControlStateNormal];
        }
        
        self.firstButon.hidden = NO;
        self.secondButton.hidden = NO;
        self.thirdButton.hidden = NO;
        self.forthButton.hidden = NO;
        self.fifthButton.hidden = NO;
        self.sixthButton.hidden = YES;
        
        self.symbolImg1.hidden = NO;
        self.symbolImg2.hidden = NO;
        self.symbolImg3.hidden = NO;
        self.symbolImg4.hidden = NO;
        self.symbolImg5.hidden = NO;
    } else {
        if ([self.categoryArray[indexPath.row][@"children"] count] == 1) {
            [self.sixthButton setTitle:self.categoryArray[indexPath.row][@"roleName"] forState:UIControlStateNormal];
        }
        
        self.firstButon.hidden = NO;
        self.secondButton.hidden = NO;
        self.thirdButton.hidden = NO;
        self.forthButton.hidden = NO;
        self.fifthButton.hidden = NO;
        self.sixthButton.hidden = NO;
        
        self.symbolImg1.hidden = NO;
        self.symbolImg2.hidden = NO;
        self.symbolImg3.hidden = NO;
        self.symbolImg4.hidden = NO;
        self.symbolImg5.hidden = NO;
    }
    
    if ([self.categoryArray[indexPath.row][@"children"] count] >= 1 ) {
        [self.passArray replaceObjectAtIndex:passIndex withObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
        if ([self.categoryArray[indexPath.row][@"children"] count] != 1) {
            passIndex += 1;
        }
        
        [self getChildArray:self.categoryArray seletectedIndex:indexPath.row];
        [self.categoryTableView reloadData];
        
    } else {
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
        
        [manager POST:URL.absoluteString parameters:@{@"codeName":self.categoryArray[0][@"roleName"] , @"userid":delegate.dataManager.userID} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
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
    
}



- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *str = self.categoryArray[indexPath.row][@"roleName"];
    CGSize textViewSize = [str sizeWithFont:[UIFont fontWithName:@"Montserrat-Regular" size:17*layout]
                          constrainedToSize:CGSizeMake(self.view.frame.size.width-30*layout, FLT_MAX)
                              lineBreakMode:UILineBreakModeTailTruncation];
    
    return textViewSize.height+26*layout;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}


#pragma mark - get height of dynamic label
- (CGFloat)getLabelHeight:(NSString*)text
{
    CGSize size = CGSizeMake(self.categoryTableView.frame.size.width-15*layout, 10000);
    CGRect textRect = [text boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Regular" size:13*layout]}
                                         context:nil];
    
    return textRect.size.height;
}


#pragma mark - click Button...
- (NSMutableArray *) getChildArray : (NSMutableArray *) array seletectedIndex:(NSInteger)index
{
    self.categoryArray = array[index][@"children"];
    return array;
}

#pragma mark - click Button...
- (void) click1
{
    AppDelegate *delegate = GetDM;
    
    passIndex = 0;
    self.categoryArray = delegate.dataManager.categoryArray;
    [self.categoryTableView reloadData];
    
    self.firstButon.hidden = YES;
    self.secondButton.hidden = YES;
    self.thirdButton.hidden = YES;
    self.forthButton.hidden = YES;
    self.fifthButton.hidden = YES;
    self.sixthButton.hidden = YES;
    
    self.symbolImg1.hidden = YES;
    self.symbolImg2.hidden = YES;
    self.symbolImg3.hidden = YES;
    self.symbolImg4.hidden = YES;
    self.symbolImg5.hidden = YES;
}

- (void) click2
{
    AppDelegate *delegate = GetDM;
    
    passIndex = 1;
    NSInteger i = [self.passArray[0] intValue];
    [self getChildArray:delegate.dataManager.categoryArray seletectedIndex:i];
    [self.categoryTableView reloadData];
    
    self.firstButon.hidden = NO;
    self.secondButton.hidden = YES;
    self.thirdButton.hidden = YES;
    self.forthButton.hidden = YES;
    self.fifthButton.hidden = YES;
    self.sixthButton.hidden = YES;
    
    self.symbolImg1.hidden = NO;
    self.symbolImg2.hidden = YES;
    self.symbolImg3.hidden = YES;
    self.symbolImg4.hidden = YES;
    self.symbolImg5.hidden = YES;
    
}

- (void) click3
{
    AppDelegate *delegate = GetDM;
    
    passIndex = 2;
    [self getChildArray:delegate.dataManager.categoryArray[[self.passArray[0] intValue]][@"children"] seletectedIndex:[self.passArray[1] intValue]];
    [self.categoryTableView reloadData];
    
    self.firstButon.hidden = NO;
    self.secondButton.hidden = NO;
    self.thirdButton.hidden = YES;
    self.forthButton.hidden = YES;
    self.fifthButton.hidden = YES;
    self.sixthButton.hidden = YES;
    
    self.symbolImg1.hidden = NO;
    self.symbolImg2.hidden = NO;
    self.symbolImg3.hidden = YES;
    self.symbolImg4.hidden = YES;
    self.symbolImg5.hidden = YES;
    
}

- (void) click4
{
    AppDelegate *delegate = GetDM;
    
    passIndex = 3;
    [self getChildArray:delegate.dataManager.categoryArray[[self.passArray[0] intValue]][@"children"][[self.passArray[1] intValue]][@"children"] seletectedIndex:[self.passArray[2] intValue]];
    [self.categoryTableView reloadData];
    
    self.firstButon.hidden = NO;
    self.secondButton.hidden = NO;
    self.thirdButton.hidden = NO;
    self.forthButton.hidden = YES;
    self.fifthButton.hidden = YES;
    self.sixthButton.hidden = YES;
    
    self.symbolImg1.hidden = NO;
    self.symbolImg2.hidden = NO;
    self.symbolImg3.hidden = NO;
    self.symbolImg4.hidden = YES;
    self.symbolImg5.hidden = YES;
    
}

- (void) click5
{
    AppDelegate *delegate = GetDM;
    
    passIndex = 4;
    [self getChildArray:delegate.dataManager.categoryArray[[self.passArray[0] intValue]][@"children"][[self.passArray[1] intValue]][@"children"][[self.passArray[2] intValue]][@"children"] seletectedIndex:[self.passArray[3] intValue]];
    [self.categoryTableView reloadData];
    
    self.firstButon.hidden = NO;
    self.secondButton.hidden = NO;
    self.thirdButton.hidden = NO;
    self.forthButton.hidden = NO;
    self.fifthButton.hidden = YES;
    self.sixthButton.hidden = YES;
    
    self.symbolImg1.hidden = NO;
    self.symbolImg2.hidden = NO;
    self.symbolImg3.hidden = NO;
    self.symbolImg4.hidden = NO;
    self.symbolImg5.hidden = YES;
    
}

- (void) click6
{
    AppDelegate *delegate = GetDM;
    
    passIndex = 5;
    [self getChildArray:delegate.dataManager.categoryArray[[self.passArray[0] intValue]][@"children"][[self.passArray[1] intValue]][@"children"][[self.passArray[2] intValue]][@"children"][[self.passArray[3] intValue]][@"children"] seletectedIndex:[self.passArray[4] intValue]];
    [self.categoryTableView reloadData];
    
    self.firstButon.hidden = NO;
    self.secondButton.hidden = NO;
    self.thirdButton.hidden = NO;
    self.forthButton.hidden = NO;
    self.fifthButton.hidden = NO;
    self.sixthButton.hidden = YES;
    
    self.symbolImg1.hidden = NO;
    self.symbolImg2.hidden = NO;
    self.symbolImg3.hidden = NO;
    self.symbolImg4.hidden = NO;
    self.symbolImg5.hidden = NO;
    
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



#pragma mark - click addFriend Button
- (void) clickCartButton : (UIButton *) buttonTag
{
    AppDelegate *delegate = GetDM;
    
    
    UIView* contentView = buttonTag.superview;
    UITableViewCell* cell = (UITableViewCell*)contentView.superview;
    NSIndexPath* indexPath = [self.categoryTableView indexPathForCell:cell];
    
    BOOL cartFlag = true;
    NSInteger tempInteger = 0;
    NSString *imgStr;
    for (int j=0; j<delegate.dataManager.codesNameArray.count; j++) {
        if ([[NSString stringWithFormat:@"%@", self.categoryArray[indexPath.row][@"roleName"]] isEqualToString:[NSString stringWithFormat:@"%@", delegate.dataManager.codesNameArray[j][@"codeName"]]]) {
            imgStr = delegate.dataManager.codesNameArray[j][@"detailImg"];
        }
    }

    for (int i=0; i<delegate.dataManager.cartArray.count; i++) {
        if ([[NSString stringWithFormat:@"%@", self.categoryArray[indexPath.row][@"roleName"]] isEqualToString:[NSString stringWithFormat:@"%@", delegate.dataManager.cartArray[i][@"codeName"]]]) {
            cartFlag = false;
            tempInteger = i;
            break;
        }
    }
    if (cartFlag) {
        NSDictionary *tempDic = @{@"codeName" : self.categoryArray[indexPath.row][@"roleName"], @"codeDescription" : self.categoryArray[indexPath.row][@"description"] , @"detailImg" : imgStr};
        [delegate.dataManager.cartArray addObject:tempDic];
    } else
        [delegate.dataManager.cartArray removeObjectAtIndex:tempInteger];

    
    [self.categoryTableView reloadData];
    
}


@end
