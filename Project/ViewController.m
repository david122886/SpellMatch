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
    
	self.orgText = @"time";
    [Utity shared].isOrg = NO;
    
    self.orgArray = [Utity handleTheString:self.orgText];
    NSLog(@"orgArray = %@",self.orgArray);
    self.metaphoneArray = [Utity metaphoneArray:self.orgArray];
    NSLog(@"metaphoneArray = %@",self.metaphoneArray);


    /*
    for (UIView *view in self.textView.subviews)
        
    {
        
        if ([view isKindOfClass:NSClassFromString(@"_UITextContainerView")] || [view isKindOfClass:NSClassFromString(@"UIWebDocumentView")])
            
        {
            
            view.tag = UIDocumentViewTag;
            
            break;
            
        }
        
    }
    
    
    
    NSRange range = NSMakeRange(49, 1);
    
    UITextPosition *startPosition = [self.textView positionFromPosition:self.textView.beginningOfDocument offset:range.location];
    
    UITextPosition *endPosition = [self.textView positionFromPosition:startPosition offset:range.length];
    
    UITextRange *textRange = [self.textView textRangeFromPosition:startPosition toPosition:endPosition];
    
    CGRect rect = [self.textView firstRectForRange:textRange];
    
    NSLog(@"x=%f,y=%f,wigth=%f,height=%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    
    float curHeight = self.textView.frame.size.height;
    float conHeight = self.textView.contentSize.height;
    
    NSLog(@"curHeight=%f,conHeight=%f",curHeight,conHeight);
//    UIView *vv = [[UIView alloc]initWithFrame:rect];
//    
//    vv.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:200.0/255.0 blue:1.0 alpha:1.0];
//    vv.layer.cornerRadius =  rect.size.height * 0.2;
//    
//    [self.textView insertSubview:vv belowSubview:[self.textView viewWithTag:UIDocumentViewTag]];
*/
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
    
    [Utity shared].sureArray = [[NSMutableArray alloc]init];
    [Utity shared].correctArray = [[NSMutableArray alloc]init];
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
