//
// Created by Jorg on 08/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotebookPageHostViewController.h"

@class RACSignal;

typedef enum {
    NotebookPageModeSmall,
    NotebookPageModeLarge
} NotebookPageMode;


@protocol INotebookPageHostViewController <NSObject>
- (UIView *)getContainerView;

- (RACSignal *)notebookPaddingLeft;

- (void)embedNotebookWith:(NotebookPageMode)pageMode;

- (NotebookPageMode)pageMode;
@end