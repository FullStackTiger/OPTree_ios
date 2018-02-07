//
//  LoginViewController.m
//  O&P Tree
//
//  Created by Mobile Developer on 3/1/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

#import "LoginViewController.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "SignupViewController.h"
#import "AppDelegate.h"

#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "MICheckBox.h"

#import <Foundation/Foundation.h>
#import "MICheckBox.h"

#define layout self.view.frame.size.height/736.0f
static NSString *const BaseURLString = @"http://54.190.195.16:3000/api/";

@interface LoginViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *signupButton;
@property (strong, nonatomic) UIButton *forgotButton;
@property (strong, nonatomic) UIImageView *backgroundImageView;

@property (strong, nonatomic) UIImageView *logoImageView;

@property (strong, nonatomic) UITextField *usernameTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIImageView *usernameIconImageView;
@property (strong, nonatomic) UIImageView *passwordIconImageView;
@property (strong, nonatomic) UIView *firstLineView;
@property (strong, nonatomic) UIView *secondLineView;

@property (strong, nonatomic) UIView *parentBackView;

@property (strong, nonatomic) UIView *temppp;
@property (strong, nonatomic) UIView *forgot_BackView;
@property (strong, nonatomic) UITextField *forgot_TextField;
@property (strong, nonatomic) UIButton *forgot_sendButton;
@property (strong, nonatomic) UIButton *forgot_cancelButton;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UILabel *forgot_title;

@property (strong, nonatomic) UIActivityIndicatorView *waitingView;
@property (strong, nonatomic) UIActivityIndicatorView *waitingView1;

//Save username and password

@property (strong, nonatomic) UIButton *saveinforButton;
@property (strong, nonatomic) MICheckBox *checkboxRemember;

@end

//End Save username and password
@implementation LoginViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.parentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.parentBackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.parentBackView];
    
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_backgroundImageView setImage:[UIImage imageNamed:@"002"]];
    [self.parentBackView addSubview:self.backgroundImageView];
    
    
    self.logoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(self.view.frame.size.width/2-75*layout, 100*layout, 150*layout, 150*layout)];
    self.logoImageView.backgroundColor = [UIColor clearColor];
    self.logoImageView.layer.cornerRadius = 3.0f;
    [self.logoImageView setImage:[UIImage imageNamed:@"icon_1 copy"]];
    [self.parentBackView addSubview:self.logoImageView];

    
    
    self.usernameIconImageView = [[UIImageView alloc] init];
    self.usernameIconImageView.frame = CGRectMake(30*layout, 285*layout, 30*layout, 30*layout);
    self.usernameIconImageView.backgroundColor = [UIColor clearColor];
    [self.usernameIconImageView setImage: [UIImage imageNamed:@"username"]];
    [self.parentBackView addSubview:self.usernameIconImageView];
    
    
    self.passwordIconImageView = [[UIImageView alloc] init];
    self.passwordIconImageView.frame = CGRectMake(30*layout, 360*layout, 30*layout, 30*layout);
    self.passwordIconImageView.backgroundColor = [UIColor clearColor];
    [self.passwordIconImageView setImage: [UIImage imageNamed:@"password"]];
    [self.parentBackView addSubview:self.passwordIconImageView];
    
    
    self.usernameTextField = [[UITextField alloc] init];
    self.usernameTextField.frame = CGRectMake(70*layout, 285*layout, self.view.frame.size.width-100*layout, 30*layout);
    self.usernameTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Email"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Regular" size:17*layout]
                                                 }
     ];
    self.usernameTextField.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    self.usernameTextField.textColor = [UIColor whiteColor];
    [self.usernameTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    self.usernameTextField.backgroundColor = [UIColor clearColor];
    [self.usernameTextField setReturnKeyType:UIReturnKeyDone];
    self.usernameTextField.delegate = self;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.parentBackView addSubview:self.usernameTextField];
//    display saved useremail
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * strUsername = [userDefaults valueForKey:@"username"];
    [self.usernameTextField setText:strUsername];

    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.frame = CGRectMake(70*layout, 360*layout, self.view.frame.size.width-100*layout, 30*layout);
    self.passwordTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Password"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Regular" size:17*layout]
                                                 }
     ];
    self.passwordTextField.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    self.passwordTextField.textColor = [UIColor whiteColor];
    self.passwordTextField.secureTextEntry = true;
    self.passwordTextField.backgroundColor = [UIColor clearColor];
    [self.passwordTextField setReturnKeyType:UIReturnKeyDone];
    self.passwordTextField.delegate = self;
    [self.parentBackView addSubview:self.passwordTextField];
    
//    didspaly saved password
    NSUserDefaults *passDefaults = [NSUserDefaults standardUserDefaults];
    NSString * strPwd = [passDefaults valueForKey:@"pwd"];
    [self.passwordTextField setText:strPwd];
    
    

    
    
    
    self.firstLineView = [[UIView alloc] init];
    self.firstLineView.frame = CGRectMake(30*layout, 330*layout, self.view.frame.size.width-60*layout, 1);
    self.firstLineView.backgroundColor = [UIColor colorWithRed:255/255.0 green:233/255.0 blue:152/255.0 alpha:1.0];
    [self.parentBackView addSubview:self.firstLineView];
    
    
    
    self.secondLineView = [[UIView alloc] init];
    self.secondLineView.frame = CGRectMake(30*layout, 405*layout, self.view.frame.size.width-60*layout, 1);
    self.secondLineView.backgroundColor = [UIColor colorWithRed:255/255.0 green:233/255.0 blue:152/255.0 alpha:1.0];
    [self.parentBackView addSubview:self.secondLineView];
    
    
    
    self.loginButton = [[UIButton alloc] init];
    self.loginButton.frame = CGRectMake(self.view.frame.size.width/2-110*layout, 500*layout, 220*layout, 50*layout);
    self.loginButton.backgroundColor = [UIColor colorWithRed:59/255.0 green:89/255.0 blue:125/255.0 alpha:1.0];
    [self.loginButton setTitle:@"Log in" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    self.loginButton.layer.cornerRadius = 25.0f*layout;
    [self.loginButton setShowsTouchWhenHighlighted:YES];
    [self.loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.parentBackView addSubview:self.loginButton];
    
    self.signupButton = [[UIButton alloc] init];
    self.signupButton.frame = CGRectMake(self.view.frame.size.width/2-110*layout, 570*layout, 220*layout, 50*layout);
    self.signupButton.backgroundColor = [UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1.0];
    [self.signupButton setTitle:@"Sign up" forState:UIControlStateNormal];
    self.signupButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    self.signupButton.layer.cornerRadius = 25.0f*layout;
    [self.signupButton setShowsTouchWhenHighlighted:YES];
    [self.signupButton addTarget:self action:@selector(clickSignupButton) forControlEvents:UIControlEventTouchUpInside];
    [self.parentBackView addSubview:self.signupButton];
    
        /////////////////***********   Save usernam and Password     ************/////////////////////

    
    self.checkboxRemember = [[MICheckBox alloc] initWithFrame:CGRectMake(self.view.frame.size.width/5+10*layout, 630*layout, 240*layout, 30*layout)];
    self.checkboxRemember.isChecked = [[NSUserDefaults standardUserDefaults] boolForKey:@"button_status"];
    [self.checkboxRemember setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.checkboxRemember setTitle:@" Save email and passowrd?" forState:UIControlStateNormal];
    [self.parentBackView addSubview:self.checkboxRemember];
    
    /////////////////***********   Forogt Password     ************/////////////////////
    
    self.forgotButton = [[UIButton alloc] init];
    self.forgotButton.frame = CGRectMake(self.view.frame.size.width/2+40*layout, 670*layout, 150*layout, 30*layout);
    self.forgotButton.backgroundColor = [UIColor clearColor];
    [self.forgotButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
    self.forgotButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:16*layout];
    [self.forgotButton setTitleColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.forgotButton setShowsTouchWhenHighlighted:YES];
    [self.forgotButton addTarget:self action:@selector(clickforgotButton) forControlEvents:UIControlEventTouchUpInside];
    [self.parentBackView addSubview:self.forgotButton];

    
    

    self.temppp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.temppp.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.temppp];
    self.temppp.hidden = YES;
    self.temppp.alpha = 0.7;

    
    self.forgot_BackView = [[UIView alloc] initWithFrame:CGRectMake(50*layout, 250*layout, self.view.frame.size.width-100*layout, 200*layout)];
    self.forgot_BackView.backgroundColor =  [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    [self.view addSubview:self.forgot_BackView];
    self.forgot_BackView.layer.cornerRadius = 20.0*layout;
    self.forgot_BackView.hidden = YES;
    
    
    self.forgot_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*layout, self.forgot_BackView.frame.size.width, 70*layout)];
    self.forgot_title.text = @"Forgot Password";
    self.forgot_title.font = [UIFont fontWithName:@"Montserrat-Regular" size:22*layout];
    self.forgot_title.textColor = [UIColor blackColor];
    self.forgot_title.textAlignment = NSTextAlignmentCenter;
    [self.forgot_BackView addSubview:self.forgot_title];
    
    
    self.forgot_TextField = [[UITextField alloc] initWithFrame:CGRectMake(20*layout, 90*layout, self.forgot_BackView.frame.size.width-40*layout, 30*layout)];
    self.forgot_TextField.placeholder = @"Email address";
    [self.forgot_TextField setKeyboardType:UIKeyboardTypeEmailAddress];
    self.forgot_TextField.backgroundColor = [UIColor clearColor];
    [self.forgot_TextField setReturnKeyType:UIReturnKeyDone];
    self.forgot_TextField.delegate = self;
    self.forgot_TextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.forgot_TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.forgot_TextField.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    [self.forgot_BackView addSubview:self.forgot_TextField];
    
    
    self.line = [[UIView alloc] init];
    self.line.frame = CGRectMake(17*layout, 120*layout, self.forgot_BackView.frame.size.width-34*layout, 1);
    self.line.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
    [self.forgot_BackView addSubview:self.line];
    
    
    self.forgot_cancelButton = [[UIButton alloc] init];
    self.forgot_cancelButton.frame = CGRectMake(40*layout, 150*layout, 80*layout, 35*layout);
    self.forgot_cancelButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:180/255.0 alpha:1.0];
    [self.forgot_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    self.forgot_cancelButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    self.forgot_cancelButton.layer.cornerRadius = 15*layout;
    [self.forgot_cancelButton setShowsTouchWhenHighlighted:YES];
    [self.forgot_cancelButton addTarget:self action:@selector(clickForgotCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.forgot_BackView addSubview:self.forgot_cancelButton];
    
    
    self.forgot_sendButton = [[UIButton alloc] init];
    self.forgot_sendButton.frame = CGRectMake(190*layout, 150*layout, 80*layout, 35*layout);
    self.forgot_sendButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:180/255.0 alpha:1.0];
    [self.forgot_sendButton setTitle:@"Send" forState:UIControlStateNormal];
    self.forgot_sendButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    self.forgot_sendButton.layer.cornerRadius = 15*layout;
    [self.forgot_sendButton setShowsTouchWhenHighlighted:YES];
    [self.forgot_sendButton addTarget:self action:@selector(clickforgotButton) forControlEvents:UIControlEventTouchUpInside];
    [self.forgot_BackView addSubview:self.forgot_sendButton];

}


//Checkbox button


//End Chekox button

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) clickLoginButton
{
    
    self.waitingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25*layout, self.view.frame.size.height/2-25*layout, 50*layout, 50*layout)];
    [self.waitingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.waitingView setColor:[UIColor blackColor]];
    self.waitingView.hidesWhenStopped = YES;
    [self.view addSubview:self.waitingView];
    self.view.userInteractionEnabled = NO;
    [self.waitingView startAnimating];
    
    if ([self.usernameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:@"Please type your email or password"
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
        
    } else {
        
        BOOL validEmailFlag = [self NSStringIsValidEmail:self.usernameTextField.text];
        NSString*    strUsername = [self.usernameTextField text];
        NSString*    strPwd = [self.passwordTextField text];

        //   Validate checkbox state
        if (self.checkboxRemember.isChecked == true) {
            [[NSUserDefaults standardUserDefaults] setValue:strUsername forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:strPwd forKey:@"pwd"];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"pwd"];
        }
        [[NSUserDefaults standardUserDefaults] setBool:self.checkboxRemember.isChecked forKey:@"button_status"];

        
        if (validEmailFlag == true) {
            NSString *String = BaseURLString;
            String = [String stringByAppendingString:[NSString stringWithFormat:@"login"]];
            NSURL *URL = [NSURL URLWithString:String];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            
            [manager POST:URL.absoluteString parameters:@{@"email":self.usernameTextField.text , @"password":self.passwordTextField.text} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                if ([[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"success"]]   isEqual: @"1"]) {
                    
                    AppDelegate *delegate = GetDM;
                    
                    delegate.dataManager.token = [responseObject objectForKey:@"token"];
                    delegate.dataManager.userID = [responseObject objectForKey:@"_id"];
                    
                    [delegate.dataManager.bannerArray removeAllObjects];
                    [delegate.dataManager.splashArray removeAllObjects];
                    [delegate.dataManager.bannerArray addObjectsFromArray:[responseObject objectForKey:@"banner"]];
                    [delegate.dataManager.splashArray addObjectsFromArray:[responseObject objectForKey:@"splash"]];
                    
                    NSString *String = BaseURLString;
                    String = [String stringByAppendingString:[NSString stringWithFormat:@"codes"]];
                    NSURL *URL = [NSURL URLWithString:String];
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                        if ([[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"success"]]   isEqual: @"1"]) {
                            
                            AppDelegate *delegate = GetDM;
                            
                            [delegate.dataManager.codesNameArray removeAllObjects];
                            [delegate.dataManager.codesNameArray addObjectsFromArray:[responseObject objectForKey:@"codes"]];
                            
                            
                            NSString *String = BaseURLString;
                            String = [String stringByAppendingString:[NSString stringWithFormat:@"treedata"]];
                            NSURL *URL = [NSURL URLWithString:String];
                            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                            
                            [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                                if ([[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"success"]]   isEqual: @"1"]) {
                                    AppDelegate *delegate = GetDM;
                                    
                                    [delegate.dataManager.categoryArray removeAllObjects];
                                    [delegate.dataManager.categoryArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
                                    
                                    
                                    NSString *String = BaseURLString;
                                    String = [String stringByAppendingString:[NSString stringWithFormat:@"get_favlist"]];
                                    NSURL *URL = [NSURL URLWithString:String];
                                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                    
                                    [manager POST:URL.absoluteString parameters:@{@"userid" : delegate.dataManager.userID} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                                        if ([[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"success"]]   isEqual: @"1"]) {
                                            
                                            AppDelegate *delegate = GetDM;
                                            [delegate.dataManager.favoritesArray removeAllObjects];
                                            [delegate.dataManager.favoritesArray addObjectsFromArray:[responseObject objectForKey:@"favlist"]];
                                            
                                            
                                            
                                            //////////*************    Main function   *******************////////////
                                            SWRevealViewController* svc =[self.storyboard instantiateViewControllerWithIdentifier:@"sw_reveal"];
                                            [self.navigationController pushViewController:svc animated:YES];
                                            
                                            self.navigationController.navigationBarHidden = YES;
                                            self.navigationItem.leftItemsSupplementBackButton = NO;
                                            
                                            [delegate.dataManager.cartArray removeAllObjects];
                                            
                                            
                                            [self.waitingView stopAnimating];
                                            self.view.userInteractionEnabled = YES;
                                            
                                            
                                            
                                        } else {
                                            UIAlertController * alert = [UIAlertController alertControllerWithTitle: @"Message"
                                                                                                            message:@"Can't get the data now.\nPlease try later."
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
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                            message:@"Invalid email address"
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
        
    }
    
}

- (void) clickSignupButton
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignupViewController *viewController = (SignupViewController *)[storyboard instantiateViewControllerWithIdentifier:@"signup"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) clicksaveinforButton
{
    self.parentBackView.userInteractionEnabled = NO;
    
    self.forgot_BackView.hidden = NO;
    self.temppp.hidden = NO;
    
}


- (void) clickRememberButton
{
}

- (void) clickforgotButton
{
    self.parentBackView.userInteractionEnabled = NO;
    
    self.forgot_BackView.hidden = NO;
    self.temppp.hidden = NO;
    
}


- (void) clickForgotCancelButton
{
    self.parentBackView.userInteractionEnabled = YES;
    self.temppp.hidden = YES;
    self.forgot_BackView.hidden = YES;
    self.forgot_TextField.text = @"";
}

- (void) clickForgotSendButton
{
    
    self.waitingView1 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25*layout, self.view.frame.size.height/2-25*layout, 50*layout, 50*layout)];
    [self.waitingView1 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.waitingView1 setColor:[UIColor blackColor]];
    self.waitingView1.hidesWhenStopped = YES;
    [self.view addSubview:self.waitingView1];
    self.view.userInteractionEnabled = NO;
    [self.waitingView1 startAnimating];

    
    if ([self.forgot_TextField.text isEqualToString:@""]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:@"Please type your email"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        [self.waitingView1 stopAnimating];
        self.view.userInteractionEnabled = YES;

    } else {
        
        BOOL validEmailFlag = [self NSStringIsValidEmail:self.forgot_TextField.text];
        if (validEmailFlag == true) {
            
            NSString *String = BaseURLString;
            String = [String stringByAppendingString:[NSString stringWithFormat:@"forgot_password"]];
            NSURL *URL = [NSURL URLWithString:String];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
           
            [manager POST:URL.absoluteString parameters:@{@"email":self.forgot_TextField.text} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                
                if ([[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"success"]]   isEqual: @"1"]) {
                    NSString *str = [NSString stringWithFormat:@"We just sent a code to %@.\nYou can login with that a code.", self.forgot_TextField.text];
                    
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                                    message:str
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   
                                                                   self.parentBackView.userInteractionEnabled = YES;
                                                                   self.temppp.hidden = YES;
                                                                   self.forgot_BackView.hidden = YES;
                                                                   self.forgot_TextField.text = @"";
                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                               }];
                    
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];


                    [self.waitingView1 stopAnimating];
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
                    
                    [self.waitingView1 stopAnimating];
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
                
                [self.waitingView1 stopAnimating];
                self.view.userInteractionEnabled = YES;
            }];

            
            
            
        } else {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                            message:@"Invalid email address"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
            [self.waitingView1 stopAnimating];
            self.view.userInteractionEnabled = YES;

        }

    }
}



#pragma mark - TextField delegate

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    //    if ([sender isEqual:mailTf])
    //    {
    //        //move the main view, so that the keyboard does not hide it.
    //        if  (self.view.frame.origin.y >= 0)
    //        {
    //            [self setViewMovedUp:YES];
    //        }
    //    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


-(void)keyboardWillShow
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.usernameTextField.frame = CGRectMake(70*layout, 245*layout, self.view.frame.size.width-100*layout, 30*layout);
    self.usernameIconImageView.frame = CGRectMake(30*layout, 245*layout, 30*layout, 30*layout);
    self.passwordIconImageView.frame = CGRectMake(30*layout, 320*layout, 30*layout, 30*layout);
    self.loginButton.frame = CGRectMake(self.view.frame.size.width/2-110*layout, 400*layout, 220*layout, 50*layout);
    self.passwordTextField.frame = CGRectMake(70*layout, 320*layout, self.view.frame.size.width-100*layout, 30*layout);
    self.firstLineView.frame = CGRectMake(30*layout, 290*layout, self.view.frame.size.width-60*layout, 1);
    self.secondLineView.frame = CGRectMake(30*layout, 365*layout, self.view.frame.size.width-60*layout, 1);
    self.signupButton.hidden = YES;
    
    [UIView commitAnimations];
}

-(void)keyboardWillHide
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.usernameTextField.frame = CGRectMake(70*layout, 285*layout, self.view.frame.size.width-100*layout, 30*layout);
    self.usernameIconImageView.frame = CGRectMake(30*layout, 285*layout, 30*layout, 30*layout);
    self.passwordIconImageView.frame = CGRectMake(30*layout, 360*layout, 30*layout, 30*layout);
    self.loginButton.frame = CGRectMake(self.view.frame.size.width/2-110*layout, 500*layout, 220*layout, 50*layout);
    self.passwordTextField.frame = CGRectMake(70*layout, 360*layout, self.view.frame.size.width-100*layout, 30*layout);
    self.firstLineView.frame = CGRectMake(30*layout, 330*layout, self.view.frame.size.width-60*layout, 1);
    self.secondLineView.frame = CGRectMake(30*layout, 405*layout, self.view.frame.size.width-60*layout, 1);
    self.signupButton.hidden = NO;
    
    [UIView commitAnimations];
}


-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}



@end
