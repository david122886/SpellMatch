//
//  SpellMatchTextView.h
//  MatchSpeedString
//
//  Created by david on 13-11-13.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SpellMatchObjDelegate;
@interface SpellMatchObj : NSObject
@property (assign,nonatomic) NSRange range;
@property (nonatomic,strong) UIColor *color;
@property (assign,nonatomic) BOOL  isUnderLine;
@property (nonatomic,strong) NSString *originText;
@property (nonatomic,assign) int lineIndex;
@property (nonatomic,strong) UILabel *textLabel;
@end

@interface SpellMatchTextView : UITextView<UITextViewDelegate>
@property (nonatomic,assign) float lineHeight;
@property (nonatomic,strong) NSMutableArray *lineTextArr;
@property (weak,nonatomic) id<SpellMatchObjDelegate> spellDelegate;
-(void)setText:(NSString *)text withAttributes:(NSMutableArray*)attributeArr;
@end

@protocol SpellMatchObjDelegate <NSObject>

-(float)getOriginLabelOriginXWithSpellMatchObj:(SpellMatchObj*)spell;

@end