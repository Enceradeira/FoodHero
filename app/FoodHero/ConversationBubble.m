//
//  ConversationBubble.m
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationBubble.h"

@implementation ConversationBubble
{
    UIImage *_image;
    UIFont *_font;
    NSDictionary *_textAttritbutes;
    NSStringDrawingOptions _textDrawingOptions;
    
}

- (UIImage*) getImage
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

- (NSString*) getBubbleViewConstraint
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

- (CGFloat)textPaddingLeft
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0;
    
}

- (CGFloat)textPaddingRight
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0;
}

- (NSString*) cellId
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

- (CGFloat) width: (CGFloat) viewWidth
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0;
}

- (CGFloat) paddingTopText
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0;
}

- (CGFloat) paddingBottomText
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0;
}

- (CGFloat) height
{
    return _image.size.height;
}

-(id) initWithText:(NSString*) text semanticId: (NSString*)semanticId viewWitdh: (CGFloat) viewWidth;
{
    self =[super init];
    if( self == nil)
        return nil;
 
    _text = text;
    _semanticId = semanticId;
    
    _font = [UIFont systemFontOfSize:16];
    _textAttritbutes = [NSDictionary dictionaryWithObjectsAndKeys:
                        _font ,NSFontAttributeName,
                        nil];
    _textDrawingOptions = NSStringDrawingUsesLineFragmentOrigin;
    
    _image = [self renderTextIntoImage:[self getImage] text:text viewWitdh:viewWidth];
    return self;
}

- (CGFloat)calculateTextHeightFromImageWidth:(CGFloat) imageWidth text: (NSString*)text
{
    CGSize rectWithFixedWidth = CGSizeMake(imageWidth-[self textPaddingLeft]-[self textPaddingRight],0);
    CGRect rectWithWidthAndHeight = [text boundingRectWithSize:rectWithFixedWidth options:_textDrawingOptions attributes:_textAttritbutes context:nil];
    return ceil(rectWithWidthAndHeight.size.height);
}

- (UIImage *)renderTextIntoImage:(UIImage *)bubble text:(NSString *)text viewWitdh: (CGFloat) viewWidth
{
    CGFloat minHeight = bubble.size.height;
    CGFloat textHeight = [self calculateTextHeightFromImageWidth:[self width:viewWidth] text:text];
    
    CGFloat height = textHeight + [self paddingTopText] + [self paddingBottomText];
    height = fmax(height,minHeight);
    CGRect resizedImageRect = CGRectMake(0, 0, [self width:viewWidth], height);
    
    CGFloat textX = resizedImageRect.origin.x+[self textPaddingLeft];
    CGFloat textY = resizedImageRect.origin.y+[self paddingTopText];
    CGFloat textWidth = resizedImageRect.size.width-[self textPaddingLeft]-[self textPaddingRight];
    CGRect resizedTextRect = CGRectMake(textX, textY, textWidth, height);
    CGRect calculatedTextRect = CGRectMake(textX,textY,textWidth,textHeight);
    
    UIGraphicsBeginImageContextWithOptions(resizedImageRect.size, NO, bubble.scale);
    
    [bubble drawInRect:resizedImageRect];
    [text drawWithRect:resizedTextRect options:_textDrawingOptions attributes:_textAttritbutes context:nil];
    
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1);
    CGContextStrokeRect(UIGraphicsGetCurrentContext(),calculatedTextRect);
    
    UIImage *bubbleWithText = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return bubbleWithText;
}
@end
