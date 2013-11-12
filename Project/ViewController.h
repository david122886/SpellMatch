//
//  ViewController.h
//  Project
//
//  Created by comdosoft on 13-11-11.
//  Copyright (c) 2013年 Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) NSString *orgText;
@property (nonatomic, strong) NSArray *orgArray;
@property (nonatomic, strong) NSArray *metaphoneArray;
@end
