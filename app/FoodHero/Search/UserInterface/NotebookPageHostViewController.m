//
// Created by Jorg on 06/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "NotebookPageHostViewController.h"
#import "DesignByContractException.h"
#import "NotebookPageViewController.h"


@implementation NotebookPageHostViewController {

    __weak IBOutlet NSLayoutConstraint *leftBorderConstraint;
    NotebookPageViewController *_notebookController;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString:@"Container"]) {
        _notebookController = (NotebookPageViewController *) [segue destinationViewController];
    }
}

- (CGFloat)notebookPaddingLeft {
    if (!_notebookController) {
        @throw [DesignByContractException createWithReason:@"NotebookController was not found in prepareForSeque"];
    }
    return _notebookController.paddingLeft;
}

@end