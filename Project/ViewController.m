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
    
	self.orgText = @"The communique said the meeting has approved \"a decision on major issues concerning comprehensive and far reaching reforms.\" The decision, which contains many more details, is expected to be released soon";
    [Utity shared].isOrg = NO;
    
    self.orgArray = [Utity handleTheString:self.orgText];
    NSLog(@"orgArray = %@",self.orgArray);
    self.metaphoneArray = [Utity metaphoneArray:self.orgArray];
    NSLog(@"metaphoneArray = %@",self.metaphoneArray);
    
}

-(NSString *)handleText:(NSString *)text WithArray:(NSArray *)array {
    NSMutableString *string = [NSMutableString stringWithString:text];
    if (array.count>0) {
        int m = 0;
        for (int i=0; i<array.count; i++) {
            NSString *str = [array objectAtIndex:i];
            NSMutableString *spaceStr = [NSMutableString string];
            NSArray *arr = [str componentsSeparatedByString:@"_"];
            int location = [[arr objectAtIndex:0]intValue];
            int length = [[arr objectAtIndex:1]intValue];
            for (int k=0; k<length; k++) {
                [spaceStr appendString:@"_"];
            }
            [string insertString:spaceStr atIndex:location+m];
            m +=length;
        }
    }
    return string;
}
-(IBAction)btnPressed:(id)sender {
    [Utity shared].isOrg = NO;
    

    NSString *text = self.textView.text;
    NSArray *array = [Utity handleTheString:text];
    NSLog(@"array = %@",array);
    NSArray *array2 = [Utity metaphoneArray:array];
    NSLog(@"array2 = %@",array2);
    
    [Utity shared].noticeArray = [[NSMutableArray alloc]init];
    [Utity shared].greenArray = [[NSMutableArray alloc]init];
    [Utity shared].yellowArray = [[NSMutableArray alloc]init];
    [Utity shared].spaceLineArray = [[NSMutableArray alloc]init];
    [Utity shared].firstpoint = 0;
    NSDictionary *dic = [Utity compareWithArray:array andArray:array2 WithArray:self.orgArray andArray:self.metaphoneArray WithRange:[Utity shared].rangeArray];
    NSLog(@"dic = %@",dic);

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
