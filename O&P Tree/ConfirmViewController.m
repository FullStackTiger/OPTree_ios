//
//  ConfirmViewController.m
//  O&P Tree
//
//  Created by Mobile Developer on 3/10/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

#import "ConfirmViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

#define layout self.view.frame.size.height/736.0f

static NSString *const BaseURLString = @"http://54.190.195.16:3000/api/";

@interface ConfirmViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *textlabel;
@property (strong, nonatomic) UITextField *confirmTextField;
@property (strong, nonatomic) NSString *confirmCode;

@property (strong, nonatomic) UIActivityIndicatorView *waitingView;

@end

@implementation ConfirmViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
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

    
    
    self.logoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(self.view.frame.size.width/2-75*layout, 150*layout, 150*layout, 150*layout)];
    self.logoImageView.backgroundColor = [UIColor clearColor];
    self.logoImageView.layer.cornerRadius = 3.0f;
    [self.logoImageView setImage:[UIImage imageNamed:@"icon1 copy"]];
    [self.view addSubview:self.logoImageView];

    
    self.textlabel = [[UILabel alloc] initWithFrame:CGRectMake(30*layout, 320*layout, self.view.frame.size.width-60*layout, 30*layout)];
    self.textlabel.text = @"Please type the confirm code here.";
    self.textlabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    self.textlabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    self.textlabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.textlabel];
    
    
    
    self.confirmTextField = [[UITextField alloc] initWithFrame:CGRectMake(30*layout, 360*layout, self.view.frame.size.width-80*layout, 30*layout)];
    self.confirmTextField.backgroundColor = [UIColor clearColor];
    self.confirmTextField.placeholder = @"Confirm code";
    [self.confirmTextField setReturnKeyType:UIReturnKeyDone];
    self.confirmTextField.delegate = self;
    [self.confirmTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.confirmTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.confirmTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:self.confirmTextField];
    
    
    
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(30*layout, 390*layout, self.view.frame.size.width-60*layout, 1);
    self.lineView.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
    [self.view addSubview:self.lineView];

    
    self.confirmButton = [[UIButton alloc] init];
    self.confirmButton.frame = CGRectMake(self.view.frame.size.width/2-110*layout, 500*layout, 220*layout, 50*layout);
    self.confirmButton.backgroundColor = [UIColor colorWithRed:81/255.0 green:170/255.0 blue:81/255.0 alpha:1.0];
    [self.confirmButton setTitle:@"Go to Home page" forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17*layout];
    self.confirmButton.layer.cornerRadius = 25.0f*layout;
    [self.confirmButton setShowsTouchWhenHighlighted:YES];
    [self.confirmButton addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
    
    
    self.confirmCode = @"1230";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) pressBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) clickConfirmButton
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
    String = [String stringByAppendingString:[NSString stringWithFormat:@"confirm"]];
    NSURL *URL = [NSURL URLWithString:String];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    
    [manager POST:URL.absoluteString parameters:@{@"email":delegate.dataManager.userEmail , @"password":delegate.dataManager.userPassword, @"confirm_code" : self.confirmTextField.text} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if ([[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"success"]]   isEqual: @"1"]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            
            SWRevealViewController* svc =[storyboard instantiateViewControllerWithIdentifier:@"sw_reveal"];
            [self.navigationController pushViewController:svc animated:YES];
            
            self.navigationController.navigationBarHidden = YES;
            self.navigationItem.leftItemsSupplementBackButton = NO;
            
            [self.waitingView stopAnimating];
            self.view.userInteractionEnabled = YES;

        } else {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                            message:@"Wrong confirm code."
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


-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    
    self.confirmButton.frame = CGRectMake(self.view.frame.size.width/2-110*layout, self.view.frame.size.height-kbSize.height-60*layout, 220*layout, 50*layout);
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.confirmButton.frame = CGRectMake(self.view.frame.size.width/2-110*layout, 500*layout, 220*layout, 50*layout);
    
    [UIView commitAnimations];
}


@end
