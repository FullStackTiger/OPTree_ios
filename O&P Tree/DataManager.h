//
//  DataManager.h
//  O&P Tree
//
//  Created by Mobile Developer on 3/2/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userPassword;

@property (strong, nonatomic) NSMutableArray *codesNameArray;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSMutableArray *favoritesArray;
@property (strong, nonatomic) NSMutableDictionary *detailInfo;

@property (strong, nonatomic) NSMutableArray *bannerArray;
@property (strong, nonatomic) NSMutableArray *splashArray;

@property (strong, nonatomic) NSMutableArray *addonArray;
@property (strong, nonatomic) NSMutableArray *cartArray;

@property (strong, nonatomic) NSTimer *bannerTimer;
@property (strong, nonatomic) NSTimer *splashTimer;
@end
