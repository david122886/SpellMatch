//
//  PlayerViewController.h
//  MatchSpeedString
//
//  Created by david on 13-11-12.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "PracticeObj.h"
#import "SpellMatchTextView.h"
@interface PlayerViewController : UIViewController<AVAudioPlayerDelegate,SpellMatchObjDelegate,UITextViewDelegate>
@property (strong,nonatomic) NSString *audioURL;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong,nonatomic) NSArray *practiceArr;
@property (weak, nonatomic) IBOutlet SpellMatchTextView *spellTextView;
@end
