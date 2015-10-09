//
//  NetworkError.m
//  FoodHero
//
//  Created by Jorg on 09/10/2015.
//  Copyright © 2015 JENNIUS LTD. All rights reserved.
//

#import "NetworkError.h"


@implementation NetworkError

-(instancetype)init{
    self = [super initWithDomain:@"uk.co.jennius" code:0 userInfo:nil];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    return self;
}

@end


/*
 
 public class NetworkError: NSError {
 public  init() {
 super.init(domain: "uk.co.jennius", code: 0, userInfo: nil)
 }
 
 public required init?(coder: NSCoder) {
 super.init(coder: coder)
 }
 */