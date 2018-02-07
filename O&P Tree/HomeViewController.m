
#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "SearchCategoryViewController.h"
#import "SearchNameViewController.h"
#import "FavoritesViewController.h"
#import "SplashADViewController.h"


#define layout self.view.frame.size.height/736.0f

@interface HomeViewController ()

@property (strong, nonatomic) UIButton *searchNameButton;
@property (strong, nonatomic) UIButton *searchCategoryButton;
@property (strong, nonatomic) UIButton *favoritesButton;
@property (strong, nonatomic) UIButton *cartButton;
@property (strong, nonatomic) UIButton *glossaryButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property (strong, nonatomic) UIButton *logoImageViewButton;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSplashNoti:) name:@"changeSplashImage" object:nil];
    
    
    
    self.title = @"O&P Tree";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
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
    
    
    self.logoImageViewButton = [[UIButton alloc] initWithFrame: CGRectMake(self.view.frame.size.width/2-75*layout, 130*layout, 150*layout, 150*layout)];
    self.logoImageViewButton.backgroundColor = [UIColor clearColor];
    self.logoImageViewButton.layer.cornerRadius = 3.0f;
    self.logoImageViewButton.showsTouchWhenHighlighted = YES;
    [self.logoImageViewButton setImage:[UIImage imageNamed:@"icon1 copy"] forState:UIControlStateNormal];
    [self.logoImageViewButton addTarget:self action:@selector(clickLogoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logoImageViewButton];
    
    
    self.searchNameButton = [[UIButton alloc] init];
    self.searchNameButton.frame = CGRectMake(70*layout, 330*layout, self.view.frame.size.width-140*layout, 50*layout);
    self.searchNameButton.backgroundColor = [UIColor colorWithRed:81/255.0 green:170/255.0 blue:81/255.0 alpha:1.0];
    [self.searchNameButton setTitle:@"Search by List" forState:UIControlStateNormal];
    self.searchNameButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    self.searchNameButton.layer.cornerRadius = 25.0f*layout;
    [self.searchNameButton setShowsTouchWhenHighlighted:YES];
    [self.searchNameButton addTarget:self action:@selector(clickSearchNameButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchNameButton];
    
    
    
    self.searchCategoryButton = [[UIButton alloc] init];
    self.searchCategoryButton.frame = CGRectMake(70*layout, 400*layout, self.view.frame.size.width-140*layout, 49*layout);
    self.searchCategoryButton.backgroundColor = [UIColor colorWithRed:81/255.0 green:170/255.0 blue:81/255.0 alpha:1.0];
    [self.searchCategoryButton setTitle:@"Search by category" forState:UIControlStateNormal];
    self.searchCategoryButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    self.searchCategoryButton.layer.cornerRadius = 25.0f*layout;
    [self.searchCategoryButton setShowsTouchWhenHighlighted:YES];
    [self.searchCategoryButton addTarget:self action:@selector(clickSearchCategoryButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchCategoryButton];
    
    
    
    self.favoritesButton = [[UIButton alloc] init];
    self.favoritesButton.frame = CGRectMake(70*layout, 470*layout, self.view.frame.size.width-140*layout, 49*layout);
    self.favoritesButton.backgroundColor = [UIColor colorWithRed:81/255.0 green:170/255.0 blue:81/255.0 alpha:1.0];
    [self.favoritesButton setTitle:@"Favorites" forState:UIControlStateNormal];
    self.favoritesButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    self.favoritesButton.layer.cornerRadius = 25.0f*layout;
    [self.favoritesButton setShowsTouchWhenHighlighted:YES];
    [self.favoritesButton addTarget:self action:@selector(clickFavoritesButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.favoritesButton];
    
    
    self.cartButton = [[UIButton alloc] init];
    self.cartButton.frame = CGRectMake(70*layout, 540*layout, self.view.frame.size.width-140*layout, 49*layout);
    self.cartButton.backgroundColor = [UIColor colorWithRed:81/255.0 green:170/255.0 blue:81/255.0 alpha:1.0];
    [self.cartButton setTitle:@"Cart" forState:UIControlStateNormal];
    self.cartButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    self.cartButton.layer.cornerRadius = 25.0f*layout;
    [self.cartButton setShowsTouchWhenHighlighted:YES];
    [self.cartButton addTarget:self action:@selector(clickCartButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cartButton];

    
    self.glossaryButton = [[UIButton alloc] init];
    self.glossaryButton.frame = CGRectMake(70*layout, 610*layout, self.view.frame.size.width-140*layout, 49*layout);
    self.glossaryButton.backgroundColor = [UIColor colorWithRed:81/255.0 green:170/255.0 blue:81/255.0 alpha:1.0];
    [self.glossaryButton setTitle:@"Glossary" forState:UIControlStateNormal];
    self.glossaryButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    self.glossaryButton.layer.cornerRadius = 25.0f*layout;
    [self.glossaryButton setShowsTouchWhenHighlighted:YES];
    [self.glossaryButton addTarget:self action:@selector(clickGlossaryButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.glossaryButton];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) clickSearchNameButton
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchNameViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"searchNameVC"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [navController setViewControllers: @[rootViewController] animated: YES];
    
    [self.revealViewController setFrontViewController:navController];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    
    //    self.navigationItem.leftItemsSupplementBackButton = NO;
    
}

- (void) clickSearchCategoryButton
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchCategoryViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"searchCategoryVC"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [navController setViewControllers: @[rootViewController] animated: YES];
    
    [self.revealViewController setFrontViewController:navController];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}

- (void) clickFavoritesButton
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FavoritesViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"favoritesVC"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [navController setViewControllers: @[rootViewController] animated: YES];
    
    [self.revealViewController setFrontViewController:navController];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}


- (void) clickCartButton
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FavoritesViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"cartVC"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [navController setViewControllers: @[rootViewController] animated: YES];
    
    [self.revealViewController setFrontViewController:navController];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}


- (void) clickGlossaryButton
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FavoritesViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"glossaryVC"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [navController setViewControllers: @[rootViewController] animated: YES];
    
    [self.revealViewController setFrontViewController:navController];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}


-(void) changeSplashNoti:(NSNotification*) noti{
    if ([noti.name isEqualToString:@"changeSplashImage"]) {
        
        SplashADViewController *vc = [[SplashADViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        
    }
}


- (void) clickLogoButton
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Welcome to O&P Tree!"      message:@"Thank you for downloading O&P Tree, the first mobile application for orthotic and prosthetic coding.\nYou can search for codes by description or with the advanced decision tree search function." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                         {
                             self.searchNameButton.hidden = NO;
                             self.searchCategoryButton.hidden = NO;
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
    self.searchNameButton.hidden = YES;
    self.searchCategoryButton.hidden = YES;

}


@end
