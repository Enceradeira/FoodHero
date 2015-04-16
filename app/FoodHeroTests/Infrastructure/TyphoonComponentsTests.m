//
//  TyphoonComponentsTests.m
//  FoodHero
//
//  Created by Jorg on 08/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "TyphoonComponents.h"
#import "DesignByContractException.h"
#import "DefaultAssembly.h"
#import "HCIsExceptionOfType.h"

@interface TyphoonComponentsTests : XCTestCase

@end

@implementation TyphoonComponentsTests
- (void)setUp {
    [super setUp];

    [TyphoonComponents reset];
}

- (void)test_factory_ShouldThrowException_IfApplicationAssemblyNotConfigured {
    assertThat(^() {
        [TyphoonComponents getAssembly];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_storyboard_ShouldThrowException_IfApplicationAssemblyNotConfigured {
    assertThat(^() {
        [TyphoonComponents storyboard];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_factory_ShouldReturnFactory_IfApplicationAssemblyConfigured {
    [TyphoonComponents configure:[DefaultAssembly new]];
    assertThat(TyphoonComponents.getAssembly, is(notNilValue()));
}

- (void)test_factory_ShouldReturnStoryboard_IfApplicationAssemblyConfigured {
    [TyphoonComponents configure:[DefaultAssembly new]];
    assertThat(TyphoonComponents.storyboard, is(notNilValue()));
}

@end
