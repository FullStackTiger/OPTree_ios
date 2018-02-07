//
//  MenuSidebarTableViewController.m
//  Homebase Construction-1
//
//  Created by Go Hikaru on 10/20/16.
//  Copyright © 2016 Yuna. All rights reserved.
//

#import "MenuSidebarTableViewController.h"
#import "SWRevealViewController.h"

@interface MenuSidebarTableViewController ()

@end

@implementation MenuSidebarTableViewController
{
    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuItems = @[@"Search by name", @"Search by category" , @"Favorites", @"Cart", @"Glossary", @"Home", @"Log out"];
    
    self.MenuTableView.backgroundColor = [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:1.0];
    [self.MenuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.MenuTableView setSeparatorColor:[UIColor blackColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:1.0];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
