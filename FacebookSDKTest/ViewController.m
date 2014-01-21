//
//  ViewController.m
//  FacebookSDKTest
//
//  Created by SDT-1 on 2014. 1. 21..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController ()<FBLoginViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet FBProfilePictureView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ViewController {
    NSArray *_data;
}


- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    self.userImageView.profileID = user.id;
    self.userNameLabel.text = user.name;
    
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        _data = [result objectForKey:@"data"];
        NSLog(@"%@", result);
        [self.table reloadData];
    }];
}
// 로그아웃시에 뷰 비우기
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"log out");
    self.userImageView.profileID = nil;
    self.userNameLabel.text = @"";
    _data = nil;
    [self.table reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID" forIndexPath:indexPath];
    
    NSDictionary *one = [_data objectAtIndex:indexPath.row];
    cell.textLabel.text = one[@"name"];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.loginView setReadPermissions:@[@"basic_info", @"user_friends"]];
    self.loginView.delegate = self;
    
    [self.view addSubview:self.loginView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
