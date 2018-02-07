//
//  CartViewController.m
//  O&P Tree
//
//  Created by Mobile Developer on 3/9/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

#import "GlossaryViewController.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "SplashADViewController.h"
#import "AppDelegate.h"

#define layout self.view.frame.size.height/736.0f

@interface GlossaryViewController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (strong, nonatomic) UIImageView *bannerImageView;

@property (strong, nonatomic) UIWebView *webview;

@property (strong, nonatomic) NSArray *glossaryArray;

@property (strong, nonatomic) UITableView *glossaryTableView;

@end

@implementation GlossaryViewController
{
    NSInteger randomIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBannerNoti:) name:@"changeBannerImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSplashNoti:) name:@"changeSplashImage" object:nil];

    
    self.title = @"Glossary";
    
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
    
    
    
    self.glossaryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5*layout, self.view.frame.size.width, self.view.frame.size.height-66*layout) style:UITableViewStyleGrouped];
    self.glossaryTableView.dataSource = self;
    self.glossaryTableView.delegate = self;
    [self.glossaryTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.glossaryTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.glossaryTableView];

    
    
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

    
    
    self.glossaryArray = @[
                           @{ @"title" : @"AE",
                              @"content" : @"Above elbow amputation"},
                           @{ @"title" : @"AFO",
                              @"content" : @"Ankle foot orthosis"},
                           @{ @"title" : @"AK",
                              @"content" : @"Above the Knee.  Usually refers to an above the knee amputation or above the knee compression hose"},
                           @{ @"title" : @"ASIS",
                              @"content" : @"Anterior superior iliac spine of the pelvic bone"},
                           @{ @"title" : @"BE",
                              @"content" : @"Below Elbow amputation"},
                           @{ @"title" : @"BK",
                              @"content" : @"Below the knee amputation"},
                           @{ @"title" : @"CO",
                              @"content" : @"Cervical orthosis"},
                           @{ @"title" : @"CTLSO",
                              @"content" : @"Cervical thoracic lumbar sacral orthosis"},
                           @{ @"title" : @"Custom fit",
                              @"content" : @"Devices that are prefabricated.  They may or may not be supplied as a kit that requires some assembly. Assembly of the item and/or installation of add-on components and/or the use of some basic materials in preparation of the item does not change classification from OTS to custom fitted.  Classification as custom fitted requires substantial modification for fitting at the time of delivery in order to provide an individualized fit, i.e., the item must be trimmed, bent, molded (with or without heat), or otherwise modified resulting in alterations beyond minimal self-adjustment.  This fitting at delivery does require expertise of a certified orthotist or an individual who has equivalent specialized training in the provision of orthosis to fit the item to the individual beneficiary.  Substantial modification is defined as changes made to achieve an individualized fit of the item that requires the expertise of a certified orthotist or an individual who has equivalent specialized training in the provision of orthotics such as a physician, treating practitioner, an occupational therapist, or physical therapist in compliance with all applicable Federal and State licensure and regulatory requirements"},
                           @{ @"title" : @"DIP",
                              @"content" : @"Distal Inter phalange"},
                           @{ @"title" : @"DME",
                              @"content" : @"Durable medical equipment"},
                           @{ @"title" : @"ED",
                              @"content" : @"Elbow disarticulation amputation"},
                           @{ @"title" : @"ENDO",
                              @"content" : @"Endoskeletal"},
                           @{ @"title" : @"EO",
                              @"content" : @"Elbow orthosis"},
                           @{ @"title" : @"EWHO",
                              @"content" : @"Elbow wrist hand orthosis"},
                           @{ @"title" : @"EXO",
                              @"content" : @"Exoskeletal"},
                           @{ @"title" : @"FFO",
                              @"content" : @"Functional foot orthotics"},
                           @{ @"title" : @"FO",
                              @"content" : @"Finger orthosis"},
                           @{ @"title" : @"HD",
                              @"content" : @"Hip disarticulation"},
                           @{ @"title" : @"HEMI",
                              @"content" : @"Hemi pelvectomy"},
                           @{ @"title" : @"HFO",
                              @"content" : @"Hand finger orthosis"},
                           @{ @"title" : @"HKAFO",
                              @"content" : @"Hip knee ankle foot orthosis"},
                           @{ @"title" : @"HO",
                              @"content" : @"Refers to hand orthosis when referring to upper extremity, or hip orthosis for lower extremity"},
                           @{ @"title" : @"IT",
                              @"content" : @"Interscapular thoracic amputation"},
                           @{ @"title" : @"KAFO",
                              @"content" : @"Knee ankle foot orthosis"},
                           @{ @"title" : @"KO",
                              @"content" : @"Knee orthosis"},
                           @{ @"title" : @"LO",
                              @"content" : @"Lumbar orthosis"},
                           @{ @"title" : @"LSO",
                              @"content" : @"Lumbar sacral orthosis"},
                           @{ @"title" : @"OTS",
                              @"content" : @"Off-the-shelf"},
                           @{ @"title" : @"PIP",
                              @"content" : @"Proximal inter phalange"},
                           @{ @"title" : @"Prefab",
                              @"content" : @"Pre fabricated device"},
                           @{ @"title" : @"PTB",
                              @"content" : @"Patellar tendon bearing"},
                           @{ @"title" : @"SACH",
                              @"content" : @"Solid ankle cushion heel"},
                           @{ @"title" : @"SD",
                              @"content" : @"Shoulder disarticulation"},
                           @{ @"title" : @"SEWHFO",
                              @"content" : @"shoulder elbow wrist hand finger orthosis"},
                           @{ @"title" : @"SEWHO",
                              @"content" : @"Shoulder elbow wrist hand orthosis"},
                           @{ @"title" : @"SMO",
                              @"content" : @"Supra malleolar orthosis"},
                           @{ @"title" : @"SO",
                              @"content" : @"shoulder orthosis when referring to upper extremity, sacral orthosis when referring to spine"},
                           @{ @"title" : @"TLSO",
                              @"content" : @"Thoraco lumbar sacral orthosis"},
                           @{ @"title" : @"UCBL",
                              @"content" : @"High profile foot orthotics"},
                           @{ @"title" : @"VC",
                              @"content" : @"voluntary closing terminal device"},
                           @{ @"title" : @"VO",
                              @"content" : @"voluntary opening terminal device"},
                           @{ @"title" : @"WD",
                              @"content" : @"wrist disarticulation"},
                           @{ @"title" : @"WHFO",
                              @"content" : @"wrist hand finger orthosis"},
                           @{ @"title" : @"WHO",
                              @"content" : @"wrist hand orthosis"}];

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
    return self.glossaryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"glossaryTableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"glossaryTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    
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
    codenameLabel.text = self.glossaryArray[indexPath.row][@"title"];
    
    
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
    NSString *str = self.glossaryArray[indexPath.row][@"content"];
    CGSize textViewSize = [str sizeWithFont:[UIFont fontWithName:@"Montserrat-Regular" size:15*layout]
                          constrainedToSize:CGSizeMake(self.view.frame.size.width-50*layout, FLT_MAX)
                              lineBreakMode:UILineBreakModeTailTruncation];
    
    codeDescriptionLabel.text = str;
    if (indexPath.row == 8) {
        codeDescriptionLabel.frame = CGRectMake(30*layout, 35*layout, self.view.frame.size.width - 50*layout, textViewSize.height);

    } else
        codeDescriptionLabel.frame = CGRectMake(30*layout, 35*layout, self.view.frame.size.width - 50*layout, textViewSize.height+20*layout);
    
    return cell;
    
}


#pragma mark - TableView Delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.glossaryArray[indexPath.row][@"content"];
    CGSize textViewSize = [str sizeWithFont:[UIFont fontWithName:@"Montserrat-Regular" size:15*layout]
                          constrainedToSize:CGSizeMake(self.view.frame.size.width-50*layout, FLT_MAX)
                              lineBreakMode:UILineBreakModeTailTruncation];
    if (indexPath.row == 8) {
        return textViewSize.height;
    }
    return textViewSize.height+50*layout;
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
