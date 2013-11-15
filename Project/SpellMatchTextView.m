//
//  SpellMatchTextView.m
//  MatchSpeedString
//
//  Created by david on 13-11-13.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SpellMatchTextView.h"
@implementation SpellMatchObj
-(NSString *)description{
    return [NSString stringWithFormat:@"range:%@==color:%@==underline:%@==originText:%@",NSStringFromRange(self.range),self.color,self.isUnderLine?@"_":@"NO",self.originText];
}
@end

@interface Lineobj : NSObject
@property (nonatomic,assign) NSRange lineRange;
@property (nonatomic,strong) NSString *lineText;
@property (nonatomic,assign) int lineIndex;
@end
@implementation Lineobj
@end

@interface SpellMatchTextView()

@end

@implementation SpellMatchTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
}





-(void)modifyTextAttributesArr:(NSMutableArray*)attributeArr withLinesArr:(NSArray*)linesArr withTextString:(NSString*)text{
    if (!attributeArr || !linesArr ||attributeArr.count <= 0 || linesArr.count <= 0) {
        return;
    }
    for (int index = 0; index < attributeArr.count; index++) {
        SpellMatchObj *spellMatch = [attributeArr objectAtIndex:index];
        int beforeLineCount = 0;
        int lengthCount = 0;
        for (int line = 0;line < linesArr.count;line++) {
            Lineobj *lineObj = [linesArr objectAtIndex:line];
            if (spellMatch.range.location+spellMatch.range.length-1 >  lineObj.lineRange.location+lineObj.lineRange.length-line) {
                if  (spellMatch.range.location < lineObj.lineRange.location+lineObj.lineRange.length-line){
                    lengthCount++;
                }else{
                    beforeLineCount++;
                }
            }else{
                spellMatch.lineIndex = line;
                spellMatch.textLabel = [self createLabelForSpellMatchObj:spellMatch withLinesArr:self.lineTextArr withTextString:text];
                spellMatch.range = NSMakeRange(spellMatch.range.location+beforeLineCount, spellMatch.range.length+lengthCount);
                break;
            }
        }
    }
}

-(UILabel*)createLabelForSpellMatchObj:(SpellMatchObj*)spell withLinesArr:(NSArray*)linesArr withTextString:(NSString*)text{
    if (spell.isUnderLine) {
        return nil;
    }
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = spell.color;
    label.font = self.font;
    self.textColor = [UIColor whiteColor];
    Lineobj *lineObj = [linesArr objectAtIndex:spell.lineIndex];
    NSString *subText = [text substringWithRange:NSMakeRange(lineObj.lineRange.location, spell.range.location-lineObj.lineRange.location)];
    CGSize size = [subText sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGSize originSize = [spell.originText sizeWithAttributes:@{NSFontAttributeName:self.font}];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    if (self.spellDelegate && [self.spellDelegate respondsToSelector:@selector(getOriginLabelOriginXWithSpellMatchObj:)]) {
        float X = [self.spellDelegate getOriginLabelOriginXWithSpellMatchObj:spell];
        label.frame = (CGRect){X,(spell.lineIndex+1)*(self.lineHeight) -style.lineSpacing*spell.lineIndex-25,originSize};
    }else{
        label.frame = (CGRect){size.width,(spell.lineIndex+1)*(self.lineHeight) -style.lineSpacing*spell.lineIndex-25,originSize};
    }
    
    label.text = spell.originText;
//    NSLog(@"%@",NSStringFromCGRect(label.frame));
    return label;
}

-(NSString*)addUnderlineForText:(NSMutableString*)text withAttributes:(NSMutableArray*)attributeArr{
    if (!text || [text isEqualToString:@""] || [attributeArr count] <= 0) {
        return nil;
    }
    NSMutableArray *underLineArr = [NSMutableArray array];
    for (SpellMatchObj *obj in attributeArr) {
        if (obj.isUnderLine) {
            [underLineArr addObject:obj];
        }
    }
    for (int index = 0; index < underLineArr.count; index++) {
        SpellMatchObj *underlineSpell = [underLineArr objectAtIndex:index];
        for (int index = 0; index < underlineSpell.range.length; index++) {
            [text insertString:@"_ " atIndex:underlineSpell.range.location];
        }
        
        BOOL isUn = NO;
        for (SpellMatchObj *obj in attributeArr) {
            if (obj.isUnderLine) {
                isUn=YES;
            }

            if (obj.range.location >= underlineSpell.range.location) {
                if (obj.isUnderLine && obj.range.location == underlineSpell.range.location) {
                    
                }else{
                    obj.range = NSMakeRange(obj.range.location+underlineSpell.range.length*2, obj.range.length);
                }
                
                if (isUn) {
                    NSLog(@"%@",[text substringWithRange:obj.range]);
                    isUn = NO;
                }
            }
        }
    }
    return text;
}

-(NSString*)splitText:(NSString*)textstr intoLinesArr:(NSMutableArray*)linesArr{
    if (!textstr || [textstr isEqualToString:@""]) {
        DLog(@"invild text");
        return textstr;
    }
    float height = 0;
    int startIndex = 0;

    NSMutableString *text = [NSMutableString stringWithString:textstr];
    for (int length = 1; length <= text.length; length++) {
        NSString *subString = [text substringToIndex:length];
        CGRect rect = [subString boundingRectWithSize:(CGSize){self.bounds.size.width - self.contentInset.left-self.contentInset.right-20,MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil];
        NSLog(@"%@",NSStringFromCGRect(self.frame));
        if (length == 1) {
            height = rect.size.height;
            startIndex = 0;
        }else{
            if (fabsf(rect.size.height - height) < 0.00001) {
                
            }else{
                for (int index = length-1; index> startIndex; index--) {
                    NSString *lastChar = [subString substringFromIndex:index];
                    NSRange range = [lastChar rangeOfString:@"[., ?!]" options:NSRegularExpressionSearch];
                    if (range.length != 0) {
                        Lineobj *obj = [[Lineobj alloc] init];
                        obj.lineRange = NSMakeRange(startIndex, index-startIndex);
                        startIndex= index;
                        height = rect.size.height;
                        obj.lineText = [text substringWithRange:obj.lineRange];
                        [linesArr addObject:obj];
                        break;
                    }
                }
            }
        }
    }
    
    Lineobj *obj = [[Lineobj alloc] init];
    obj.lineRange = NSMakeRange(startIndex, text.length-startIndex);
    obj.lineText = [text substringWithRange:obj.lineRange];
    [linesArr addObject:obj];
    
    for (int index = 0;index < [linesArr count];index++) {
        Lineobj *obj = [linesArr objectAtIndex:index];
        obj.lineIndex = index;
        if (index > 0) {
            obj.lineRange = NSMakeRange(obj.lineRange.location+index, obj.lineRange.length);
        }
        [text insertString:@"\n" atIndex:obj.lineRange.location+obj.lineRange.length];
        NSLog(@"SubString:%@\nRange:%@",obj.lineText,NSStringFromRange(obj.lineRange));
    }
    return text;
}

-(void)setText:(NSString *)text withAttributes:(NSMutableArray*)attributeArr{
    NSLog(@"%@",text);
    if (text == nil || attributeArr.count <= 0) {
        self.attributedText = nil;
        self.text = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"匹配失败" message:text?:@"文本为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    for (UIView *sub in self.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            [sub removeFromSuperview];
        }
    }
    text = [self addUnderlineForText:[NSMutableString stringWithString:text] withAttributes:attributeArr];
    NSLog(@"underString:%@\n%@",text,attributeArr);
    text = [self splitText:text intoLinesArr:self.lineTextArr];//分行
    if (!text) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"参考文本无效" message:text?:@"文本为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [self modifyTextAttributesArr:attributeArr withLinesArr:self.lineTextArr withTextString:text];//修改属性range
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineHeightMultiple = 2.0f;
    paraStyle.minimumLineHeight = self.lineHeight;
    [attri addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, text.length)];
    [attri addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
   
    for (SpellMatchObj *obj in attributeArr) {
        if (obj.color) {
            [attri addAttribute:NSForegroundColorAttributeName value:obj.color range:obj.range];
            [self addSubview:obj.textLabel];
        }
        if (obj.isUnderLine) {
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:obj.range];
//            for (int index = 0; index < obj.range.length; index++) {
//                [attri addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(obj.range.location+index*2, 1)];
//            }
//            
        }
    }
    self.attributedText = attri;    
}



-(NSMutableArray *)lineTextArr{
    if (!_lineTextArr) {
        _lineTextArr = [NSMutableArray array];
    }
    return _lineTextArr;
}
@end
