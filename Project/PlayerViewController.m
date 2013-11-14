//
//  PlayerViewController.m
//  MatchSpeedString
//
//  Created by david on 13-11-12.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "PlayerViewController.h"
#import "Utity.h"
@interface PlayerViewController ()
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *playBt;
@property (weak, nonatomic) IBOutlet UIButton *ckeckBt;
@property (nonatomic,assign) int playTime;
@property (nonatomic, strong) NSArray *orgArray;
@property (nonatomic, strong) NSArray *metaphoneArray;
- (IBAction)playBtClicked:(id)sender;
- (IBAction)checkBtClicked:(id)sender;

@end

@implementation PlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.spellTextView.text = nil;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self downloadAudio];
   
    [Utity shared].isOrg = NO;
    
    self.orgArray = [Utity handleTheString:self.practice.practiceText];
    NSLog(@"orgArray = %@",self.orgArray);
    self.metaphoneArray = [Utity metaphoneArray:self.orgArray];
    NSLog(@"metaphoneArray = %@",self.metaphoneArray);
   
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.player stop];
    self.player = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"听写";
    self.spellTextView.delegate = self;

    
//    [self test];
	// Do any additional setup after loading the view.
}

-(void)test{
    NSString *str = @"First of all, I've been::::::: doing research with no success, and I can't figure out what's happening.doing research with no success, and I can't figure out what's happening.";
    NSMutableString *muStr = [NSMutableString stringWithString:str];
//    [muStr insertString:@"\n" atIndex:12];
    NSMutableArray *arr = [NSMutableArray array];
    SpellMatchObj *obj1 = [[SpellMatchObj alloc] init];
    obj1.range = NSMakeRange(0, 14);
    obj1.color = [UIColor redColor];
    obj1.originText = @"research";
    [arr addObject:obj1];
    
    SpellMatchObj *obj2 = [[SpellMatchObj alloc] init];
    obj2.range = NSMakeRange(14, 1);
    //    obj2.color = [UIColor redColor];
    obj2.isUnderLine = YES;
    obj2.originText = @"research";
    [arr addObject:obj2];
    
    SpellMatchObj *obj3 = [[SpellMatchObj alloc] init];
    obj3.range = NSMakeRange(141, 21);
    obj3.color = [UIColor greenColor];
    obj3.originText = @"research";
    //    obj3.isUnderLine = YES;
    [arr addObject:obj3];
    self.spellTextView.lineHeight = 40.0f;
    [self.spellTextView setText:muStr withAttributes:arr];
    [self addTipString:arr];
}

#pragma mark SpellMatchObjDelegate
-(float)getOriginLabelOriginXWithSpellMatchObj:(SpellMatchObj *)spell{
    UITextPosition *startPosition = [self.spellTextView positionFromPosition:self.spellTextView.beginningOfDocument offset:spell.range.location];
    UITextPosition *endPosition = [self.spellTextView positionFromPosition:startPosition offset:spell.range.length];
    UITextRange *textRange = [self.spellTextView textRangeFromPosition:startPosition toPosition:endPosition];
    CGRect rect = [self.spellTextView firstRectForRange:textRange];
    return CGRectGetMinX(rect);
}
#pragma mark --
-(void)addTipString:(NSArray*)arr{
    for (SpellMatchObj *spell in arr) {
        UITextPosition *startPosition = [self.spellTextView positionFromPosition:self.spellTextView.beginningOfDocument offset:spell.range.location];
        UITextPosition *endPosition = [self.spellTextView positionFromPosition:startPosition offset:spell.range.length];
        UITextRange *textRange = [self.spellTextView textRangeFromPosition:startPosition toPosition:endPosition];
        CGRect rect = [self.spellTextView firstRectForRange:textRange];
        spell.textLabel.frame = (CGRect){CGRectGetMinX(rect),CGRectGetMinY(spell.textLabel.frame),spell.textLabel.frame.size};
//        [self.spellTextView setNeedsDisplay];
//        [self.spellTextView addSubview:spell.textLabel];
    }
}
-(void)downloadAudio{
    [self.playBt setEnabled:NO];
    [self.ckeckBt setEnabled:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.practice.practiceAudioURL]];
        NSString *path= [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",self.practice.practiceID]];
        self.audioURL = path;
        NSLog(@"%@>>>\n%@",path,self.practice.practiceAudioURL);
        [data writeToFile:path atomically:YES];
        [self.playBt setEnabled:YES];
//        [self.ckeckBt setEnabled:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    self.playTime = 0;
    
}


#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    //    NSLog(@"%@",NSStringFromRange(textView.selectedRange) );
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChangeSelection:(UITextView *)textView{
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
}
#pragma mark --

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateProgress{
    self.progressView.progress = self.player.currentTime/self.player.duration;
}

- (IBAction)playBtClicked:(id)sender {
    [self.playBt setTitle:@"正在播放" forState:UIControlStateNormal];
    [self.playBt setEnabled:NO];
    [self.ckeckBt setEnabled:NO];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
        [self.player play];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
//    [self.timer fire];

}

- (IBAction)checkBtClicked:(id)sender {
    self.playTime++;
//    [self test];
//    NSError *err;
//    NSDataDetector *d = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeDate error:&err];
//    NSString *str = @"There is a pan";
//    [d enumerateMatchesInString:str options:kNilOptions range:(NSRange){0,[str length]} usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//        NSLog(@"match:%@",result);
//    }];
//    NSLog(@"error:%@",err);
    
    [Utity shared].isOrg = NO;
    
    
    NSString *text = self.spellTextView.text;
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
    
    //绿色
    if (![[dic objectForKey:@"green"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"green"]!=nil) {
        NSMutableArray *green_array = [dic objectForKey:@"green"];
        for (int i=0; i<green_array.count; i++) {
            SpellMatchObj *spell = [[SpellMatchObj alloc] init];
            NSTextCheckingResult *math = (NSTextCheckingResult *)[green_array objectAtIndex:i];
            NSRange range = [math rangeAtIndex:0];
            spell.range = range;
            spell.color = [UIColor greenColor];
            spell.isUnderLine = NO;
            
            if (![[dic objectForKey:@"notice"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"notice"]!=nil) {
                NSMutableArray *notice_array = [dic objectForKey:@"notice"];
                for (int k=0; k<green_array.count; k++) {
                    NSTextCheckingResult *math2 = (NSTextCheckingResult *)[notice_array objectAtIndex:k];
                    NSRange range2 = [math2 rangeAtIndex:0];
                    if (range.location==range2.location && range.length==range2.length) {
                        NSMutableArray *correct_array = [dic objectForKey:@"correct"];
                        spell.originText = [correct_array objectAtIndex:k];
                        break;
                    }
                }
            }
        }
    }
    //黄色
    if (![[dic objectForKey:@"yellow"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"yellow"]!=nil) {
        NSMutableArray *yellow_array = [dic objectForKey:@"yellow"];
        for (int i=0; i<yellow_array.count; i++) {
            SpellMatchObj *spell = [[SpellMatchObj alloc] init];
            NSTextCheckingResult *math = (NSTextCheckingResult *)[yellow_array objectAtIndex:i];
            NSRange range = [math rangeAtIndex:0];
            spell.range = range;
            spell.color = [UIColor yellowColor];
            spell.isUnderLine = NO;
        }
    }
    //下划线
    if (![[dic objectForKey:@"space"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"space"]!=nil) {
        NSMutableArray *space_array = [dic objectForKey:@"space"];
        for (int i=0; i<space_array.count; i++) {
            NSString *str = [array objectAtIndex:i];
            NSMutableString *spaceStr = [NSMutableString string];
            NSArray *arr = [str componentsSeparatedByString:@"_"];
            int location = [[arr objectAtIndex:0]intValue];
            int length = [[arr objectAtIndex:1]intValue];
            
            SpellMatchObj *spell = [[SpellMatchObj alloc] init];
            NSRange range =NSMakeRange(location, length);
            spell.range = range;
            spell.isUnderLine = YES;
        }
    }
    
    for (NSString *key  in [dic allKeys]) {
        for (int index = 0;index < [[dic valueForKey:key] count];index++) {
            id obj = [[dic valueForKey:key] objectAtIndex:index];
            if ([obj isKindOfClass:[NSTextCheckingResult class]]) {
                NSTextCheckingResult *result = obj;
                SpellMatchObj *spell = [[SpellMatchObj alloc] init];
                spell.range = result.range;
                if ([key isEqualToString:@"green"]) {
                    spell.color = [UIColor greenColor];
                    spell.originText = [[Utity shared].greenArray objectAtIndex:index];
                }
                if ([key isEqualToString:@"yellow"]) {
                    spell.color = [UIColor yellowColor];
                    spell.originText = [[Utity shared].yellowArray objectAtIndex:index];
                }
                if ([key isEqualToString:@"green"]) {
                    spell.color = [UIColor greenColor];
                    spell.originText = [[Utity shared].greenArray objectAtIndex:index];
                }
            }
        }
       
    }
}


#pragma mark AVAudioPlayerDelegate
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    NSLog(@"audioPlayerBeginInterruption");
}
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{

}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.playBt setTitle:@"点击播放" forState:UIControlStateNormal];
    [self.playBt setEnabled:YES];
    [self.ckeckBt setHidden:NO];
    [self.timer invalidate];
    self.timer = nil;
    [self.ckeckBt setEnabled:YES];
}
#pragma mark --
#pragma mark property
-(void)setPlayTime:(int)playTime{
    _playTime = playTime;
    self.player.rate = (1-0.05*playTime)>0.7?(1-0.05*playTime):0.7;
}
-(void)setPractice:(PracticeObj *)practice{
    _practice = practice;
    self.audioURL = practice.practiceAudioURL;
}
-(AVAudioPlayer *)player{
    if (!_player) {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.audioURL?:@"http://www.baidu.com"] error:Nil];
        [_player prepareToPlay];
        _player.delegate =self;
    }
    return _player;
}
#pragma mark --
@end
