//
//  MainController.m
//  MatchSpeedString
//
//  Created by david on 13-11-12.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "MainController.h"
#import "PracticeObj.h"
#import "PlayerViewController.h"
#import "PracticeObjDao.h"
@interface MainController ()
@property(nonatomic,strong) NSMutableDictionary *listArr;
@end

@implementation MainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self test];
    [self requestData];
	// Do any additional setup after loading the view.
    self.title = @"听写练习";
}

-(void)test{
    NSMutableArray *arr = [NSMutableArray array];
    PracticeObj *p = [[PracticeObj alloc] init];
    p.practiceID = [NSString stringWithFormat:@"%d",index];
    p.practiceAudioURL = @"http://zhangmenshiting.baidu.com/data2/music/97466991/97466991.mp3?xcode=f0a1ec475ee077e1f4fc82801453147dcde6d43be9d29ba9";
    p.practiceText =@"Summer time eh It's summer time wooSummer time eh It's time to the partySummer time eh It's summer timeDon't you know what time it is it's";
    p.practiceTitle = @"第一章，动词应用";
    [arr addObject:p];
    [self.listArr setValue:arr forKey:@"第一章，动词应用"];
}
-(void)requestData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PracticeObjDao downloadAudioDataWithURL:[NSURL URLWithString:URLSTRING] success:^(NSDictionary *dataArr) {
        self.listArr = dataArr;
        [self.tableview reloadData];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc ] initWithTitle:@"" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerViewController *c = [s instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    c.practiceArr = [[self.listArr allValues] objectAtIndex:indexPath.row];
    if ([c.practiceArr count] <= 0) {
        UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"" message:@"没有数据" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alet show];
        return;
    }
    [self.navigationController pushViewController:c animated:YES];
}

#pragma mark --

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [[self.listArr allKeys] objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listArr count];
}

#pragma mark --
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark property
-(NSMutableDictionary *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableDictionary dictionary];
    }
    return _listArr;
}
#pragma mark --
@end
