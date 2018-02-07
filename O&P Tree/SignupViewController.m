//
//  SignupViewController.m
//  O&P Tree
//
//  Created by Mobile Developer on 3/1/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

#import "SignupViewController.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "SignupViewController.h"
#import "AppDelegate.h"
#import "ConfirmViewController.h"

#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

#define layout self.view.frame.size.height/736.0f

static NSString *const BaseURLString = @"http://54.190.195.16:3000/api/";

@interface SignupViewController () <UITextFieldDelegate>
@property (strong, nonatomic) UIScrollView *backgroundScrollView;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *repasswordTextField;


@property (strong, nonatomic) UIButton *signupButton;
@property (strong, nonatomic) UIImageView *backgroundImageView;

@property (strong, nonatomic) UIActivityIndicatorView *waitingView;


@end

@implementation SignupViewController

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




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor =  [UIColor colorWithRed:242/255.0 green:211/255.0 blue:70/255.0 alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(pressBack)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_backgroundImageView setImage:[UIImage imageNamed:@"011"]];
    [self.view addSubview:self.backgroundImageView];
    
    
    self.backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height+self.navigationController.navigationBar.frame.size.height)];
    self.backgroundScrollView.backgroundColor = [UIColor clearColor];
    self.backgroundScrollView.scrollEnabled = NO;
    self.backgroundScrollView.pagingEnabled = NO;
    self.backgroundScrollView.contentSize = CGSizeMake(self.backgroundScrollView.frame.size.width, self.backgroundScrollView.frame.size.height*1.3);
    [self.view addSubview:self.backgroundScrollView];
    
    
    self.logoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(self.view.frame.size.width/2-75*layout, 150*layout, 150*layout, 150*layout)];
    self.logoImageView.backgroundColor = [UIColor clearColor];
    self.logoImageView.layer.cornerRadius = 3.0f;
    [self.logoImageView setImage:[UIImage imageNamed:@"icon_1 copy"]];
    [self.backgroundScrollView addSubview:self.logoImageView];
    
    
    
    for (int i = 1; i < 4; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50*layout, 320*layout+70*i*layout, self.view.frame.size.width-100*layout, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:255/255.0 green:233/255.0 blue:152/255.0 alpha:1.0];
        [self.backgroundScrollView addSubview:lineView];
    }
    
    
    
    
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(60*layout, 360*layout, self.view.frame.size.width-120*layout, 30*layout)];
    self.emailTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Email"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Regular" size:17*layout]
                                                 }];
    self.emailTextField.textColor = [UIColor whiteColor];
    self.emailTextField.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    [self.emailTextField setReturnKeyType:UIReturnKeyDone];
    self.emailTextField.delegate = self;
    self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.backgroundScrollView addSubview:self.emailTextField];
    
    
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(60*layout, 430*layout, self.view.frame.size.width-120*layout, 30*layout)];
    self.passwordTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Password"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Regular" size:17*layout]
                                                 }];
    self.passwordTextField.textColor = [UIColor whiteColor];
    self.passwordTextField.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    [self.passwordTextField setReturnKeyType:UIReturnKeyDone];
    self.passwordTextField.delegate = self;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.secureTextEntry = true;
    [self.backgroundScrollView addSubview:self.passwordTextField];
    
    
    self.repasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(60*layout, 500*layout, self.view.frame.size.width-120*layout, 30*layout)];
    self.repasswordTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Confirm Password"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Regular" size:17*layout]
                                                 }];
    self.repasswordTextField.textColor = [UIColor whiteColor];
    self.repasswordTextField.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    [self.repasswordTextField setReturnKeyType:UIReturnKeyDone];
    self.repasswordTextField.delegate = self;
    self.repasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.repasswordTextField.secureTextEntry = true;
    [self.backgroundScrollView addSubview:self.repasswordTextField];
    
    
    
    self.signupButton = [[UIButton alloc] init];
    self.signupButton.frame = CGRectMake(self.view.frame.size.width/2-80*layout, 660*layout, 160*layout, 50*layout);
    self.signupButton.backgroundColor = [UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1.0];
    [self.signupButton setTitle:@"Sign up" forState:UIControlStateNormal];
    self.signupButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    self.signupButton.layer.cornerRadius = 25.0f*layout;
    [self.signupButton setShowsTouchWhenHighlighted:YES];
    [self.signupButton addTarget:self action:@selector(clickSignupButton) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundScrollView addSubview:self.signupButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void) clickSignupButton
{
    AppDelegate *delegate = GetDM;
    
    [delegate.dataManager.codesNameArray removeAllObjects];
    [delegate.dataManager.categoryArray removeAllObjects];
    [delegate.dataManager.favoritesArray removeAllObjects];
    [delegate.dataManager.detailInfo removeAllObjects];
    [delegate.dataManager.bannerArray removeAllObjects];
    [delegate.dataManager.splashArray removeAllObjects];
    [delegate.dataManager.cartArray removeAllObjects];
    
    
    
    self.waitingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25*layout, self.view.frame.size.height/2-25*layout, 50*layout, 50*layout)];
    [self.waitingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.waitingView setColor:[UIColor blackColor]];
    self.waitingView.hidesWhenStopped = YES;
    [self.view addSubview:self.waitingView];
    self.view.userInteractionEnabled = NO;
    [self.waitingView startAnimating];
    
    
    if ([self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] || [self.repasswordTextField.text isEqualToString:@""] || ![self.passwordTextField.text isEqualToString:self.repasswordTextField.text]) {
        if (![self.passwordTextField.text isEqualToString:self.repasswordTextField.text]) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                            message:@"Password is not matched"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        } else{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                            message:@"Please fill all fields"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        [self.waitingView stopAnimating];
        self.view.userInteractionEnabled = YES;
        
    } else {
        
        BOOL validEmailFlag = [self NSStringIsValidEmail:self.emailTextField.text];
        if (validEmailFlag == true) {
            
            NSString *String = BaseURLString;
            String = [String stringByAppendingString:[NSString stringWithFormat:@"signup"]];
            NSURL *URL = [NSURL URLWithString:String];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            
            
            [manager POST:URL.absoluteString parameters:@{@"email":self.emailTextField.text , @"password":self.passwordTextField.text} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                if ([[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"success"]]   isEqual: @"1"]) {
                    
                    AppDelegate *delegate = GetDM;
                    
                    delegate.dataManager.userID = [responseObject objectForKey:@"_id"];
                    delegate.dataManager.token = [responseObject objectForKey:@"token"];
                    
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
                            
                            [delegate.dataManager.codesNameArray removeAllObjects];
                            [delegate.dataManager.codesNameArray addObjectsFromArray:[responseObject objectForKey:@"codes"]];
                            
                            
                            
                            NSString *String = BaseURLString;
                            String = [String stringByAppendingString:[NSString stringWithFormat:@"treedata"]];
                            NSURL *URL = [NSURL URLWithString:String];
                            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                            
                            [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                                
                                if ([[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"success"]]   isEqual: @"1"]) {
                                    AppDelegate *delegate = GetDM;
                                    
                                    NSString *str = [NSString stringWithFormat:@"We just sent a code to %@.", self.emailTextField.text];
                                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                                                    message:str
                                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                                                 style:UIAlertActionStyleDefault
                                                                               handler:^(UIAlertAction * action) {
                                                                                   [delegate.dataManager.categoryArray removeAllObjects];
                                                                                   [delegate.dataManager.categoryArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
                                                                                   
                                                                                   delegate.dataManager.userEmail = self.emailTextField.text;
                                                                                   delegate.dataManager.userPassword = self.passwordTextField.text;

                                                                                   ConfirmViewController *vc = [[ConfirmViewController alloc] init];
                                                                                   [self.navigationController pushViewController:vc animated:YES];
                                                                                   
                                                                                   self.navigationController.navigationBarHidden = YES;
                                                                                   self.navigationItem.leftItemsSupplementBackButton = NO;
                                                                                   
                                                                                   [self.waitingView stopAnimating];
                                                                                   self.view.userInteractionEnabled = YES;
                                                                                   
                                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                                               }];
                                    
                                    [alert addAction:ok];
                                    [self presentViewController:alert animated:YES completion:nil];
                                    
                                    
                                    
                                    
                                    
                                } else {
                                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                    message:@"Can't get data now.\nPlease try later."
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
                            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Can't get the data now.\nPlease try later."
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
                    delegate.dataManager.userEmail = self.emailTextField.text;
                    delegate.dataManager.userPassword = self.passwordTextField.text;
                    
                    ConfirmViewController *vc = [[ConfirmViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    self.navigationController.navigationBarHidden = YES;
                    self.navigationItem.leftItemsSupplementBackButton = NO;
                    
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
                                                                            message:@"Invalid email adress."
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



- (void) pressBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TextField delegate

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    //    if (sender == self.usernameTextField) {
    //        self.backgroundScrollView.contentOffset = CGPointMake(0, 0);
    //    }
    //    if (sender == self.passwordTextField)
    //        self.backgroundScrollView.contentOffset = CGPointMake(0, self.navigationController.navigationBar.frame.size.height);
    //    if (sender == self.repasswordTextField) {
    //        self.backgroundScrollView.contentOffset = CGPointMake(0, self.navigationController.navigationBar.frame.size.height*1.5);
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
    self.backgroundScrollView.scrollEnabled = YES;
}

-(void)keyboardWillHide {
    self.backgroundScrollView.scrollEnabled = NO;
    self.backgroundScrollView.contentOffset = CGPointMake(0, 0);
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
