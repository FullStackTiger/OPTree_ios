//
//  AppDelegate.h
//  O&P Tree
//
//  Created by Mobile Developer on 3/1/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataManager.h"

#define GetDM (AppDelegate*)[[UIApplication sharedApplication] delegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong, nonatomic) DataManager* dataManager;

- (void)saveContext;


@end

