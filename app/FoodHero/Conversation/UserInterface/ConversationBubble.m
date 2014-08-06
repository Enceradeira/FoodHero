//
//  ConversationBubble.m
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationBubble.h"
#import "Restaurant.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCDFAInspection"

@implementation ConversationBubble {
    UIImage *_image;
    UIFont *_font;
    NSDictionary *_textAttritbutes;
    NSStringDrawingOptions _textDrawingOptions;

    Statement *_statement;
}

- (UIImage *)getImage {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

- (NSString *)getBubbleViewConstraint {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

- (CGFloat)textPaddingLeft {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0;
}

- (CGFloat)textPaddingRight {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0;
}

- (NSString *)cellId {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

- (CGFloat)width:(CGFloat)viewWidth {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0;
}

- (CGFloat)paddingTopText {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0;
}

- (CGFloat)paddingBottomText {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0;
}

- (CGFloat)height {
    return _image.size.height;
}

- (NSString *)text {
    return _statement.text;
}

- (NSString *)semanticId {
    return _statement.semanticId;
}

- (id)initWithStatement:(Statement *)statement width:(CGFloat)viewWidth index:(NSUInteger)index {
    self = [super init];
    if (self == nil)
        return nil;

    _statement = statement;
    _index = index;

    _font = [UIFont systemFontOfSize:16];
    _textAttritbutes = @{NSFontAttributeName : _font};
    _textDrawingOptions = NSStringDrawingUsesLineFragmentOrigin;

    _image = [self renderTextIntoImage:[self getImage] text:[self text] viewWitdh:viewWidth];
    return self;
}

- (CGFloat)calculateTextHeightFromImageWidth:(CGFloat)imageWidth text:(NSString *)text {
    CGSize rectWithFixedWidth = CGSizeMake(imageWidth - [self textPaddingLeft] - [self textPaddingRight], 0);
    CGRect rectWithWidthAndHeight = [text boundingRectWithSize:rectWithFixedWidth options:_textDrawingOptions attributes:_textAttritbutes context:nil];
    return (CGFloat) ceil(rectWithWidthAndHeight.size.height);
}

- (UIImage *)renderTextIntoImage:(UIImage *)bubble text:(NSString *)text viewWitdh:(CGFloat)viewWidth {
    CGFloat minHeight = bubble.size.height;
    CGFloat textHeight = [self calculateTextHeightFromImageWidth:[self width:viewWidth] text:text];

    CGFloat height = textHeight + [self paddingTopText] + [self paddingBottomText];
    // if textHeight was smaller the minHeight there is an y-offset otherwise text won't appear vertically centered
    CGFloat yOffset = height < minHeight ? (minHeight - height) / 2 : 0;
    height = (CGFloat) fmax(height, minHeight);
    CGRect resizedImageRect = CGRectMake(0, 0, [self width:viewWidth], height);

    CGFloat textX = resizedImageRect.origin.x + [self textPaddingLeft];
    CGFloat textY = resizedImageRect.origin.y + [self paddingTopText] + yOffset;
    CGFloat textWidth = resizedImageRect.size.width - [self textPaddingLeft] - [self textPaddingRight];
    CGRect resizedTextRect = CGRectMake(textX, textY, textWidth, height);

    UIGraphicsBeginImageContextWithOptions(resizedImageRect.size, NO, bubble.scale);

    [bubble drawInRect:resizedImageRect];
    [text drawWithRect:resizedTextRect options:_textDrawingOptions attributes:_textAttritbutes context:nil];

    /*
    // Draw a rectangle showing border of text-rectangle
    CGRect calculatedTextRect = CGRectMake(textX,textY,textWidth,textHeight);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1);
    CGContextStrokeRect(UIGraphicsGetCurrentContext(),calculatedTextRect);
    */

    UIImage *bubbleWithText = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return bubbleWithText;
}

- (Restaurant *)suggestedRestaurant {
    return _statement.suggestedRestaurant;
}
@end

#pragma clang diagnostic pop