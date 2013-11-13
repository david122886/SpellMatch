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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.orgText = @"hello,will: you. help me serve?";
    [Utity shared].isOrg = YES;
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
    
    NSLog(@"range = %@",[Utity shared].rangeArray);
    
    [Utity shared].noticeArray = [[NSMutableArray alloc]init];
    [Utity shared].greenArray = [[NSMutableArray alloc]init];
    [Utity shared].yellowArray = [[NSMutableArray alloc]init];
    [Utity shared].spaceLineArray = [[NSMutableArray alloc]init];
    NSDictionary *dic = [Utity compareWithArray:array andArray:array2 WithArray:self.orgArray andArray:self.metaphoneArray WithRange:[Utity shared].rangeArray];
    NSLog(@"dic = %@",dic);
//    NSTextCheckingResult *match = [[Utity shared].rangeArray objectAtIndex:0];
//    NSRange range = [match rangeAtIndex:0];
//    
//    NSMutableAttributedString *attributedString = [self.textView.attributedText mutableCopy];
//    if (range.length == attributedString.length-1 && range.length == self.textView.text.length)
//        ++range.length;
//    
//    [attributedString addAttributes:[NSDictionary dictionaryWithObject:[UIColor greenColor] forKey:NSForegroundColorAttributeName] range:range];
//
//    [self.textView setAttributedText:attributedString];
//    [self.textView setSelectedRange:range];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
