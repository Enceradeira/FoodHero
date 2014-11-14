//
// Created by Jorg on 14/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUITextVisualizer.h"


@interface UITextViewVisualizer : NSObject <IUITextVisualizer>
+ (instancetype)create:(UITextView *)view;
@end