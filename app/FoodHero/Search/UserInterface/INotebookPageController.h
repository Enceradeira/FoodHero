//
// Created by Jorg on 08/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <Foundation/Foundation.h>

@protocol INotebookPageController <NSObject>
- (RACSignal *)paddingLeft;
@end