//
//  ViewController.m
//  Project
//
//  Created by comdosoft on 13-11-11.
//  Copyright (c) 2013年 Project. All rights reserved.
//

#import "ViewController.h"
#import "Utity.h"
#import "double_metaphone.h"
#define UIDocumentViewTag 181337
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.orgText = @"This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.";
    [Utity shared].isOrg = NO;
    
    self.orgArray = [Utity handleTheString:self.orgText];
    NSLog(@"orgArray = %@",self.orgArray);
    self.metaphoneArray = [Utity metaphoneArray:self.orgArray];
    NSLog(@"metaphoneArray = %@",self.metaphoneArray);
}
-(IBAction)btnPressed:(id)sender {
    [Utity shared].isOrg = NO;
    

    NSString *text = self.textView.text;
    NSArray *array = [Utity handleTheString:text];
    NSLog(@"array = %@",array);
    NSArray *array2 = [Utity metaphoneArray:array];
    NSLog(@"array2 = %@",array2);
    
    [Utity shared].correctArray = [[NSMutableArray alloc]init];
    [Utity shared].noticeArray = [[NSMutableArray alloc]init];
    [Utity shared].greenArray = [[NSMutableArray alloc]init];
    [Utity shared].yellowArray = [[NSMutableArray alloc]init];
    [Utity shared].spaceLineArray = [[NSMutableArray alloc]init];
    [Utity shared].firstpoint = 0;
    NSDictionary *dic = [Utity compareWithArray:array andArray:array2 WithArray:self.orgArray andArray:self.metaphoneArray WithRange:[Utity shared].rangeArray];
    NSLog(@"dic = %@",dic);
    
    if (![[dic objectForKey:@"green"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"green"]!=nil) {
        NSMutableArray *green_array = [dic objectForKey:@"green"];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
