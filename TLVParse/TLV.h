//
//  TLV.h
//  CashBox
//
//  Created by ZKF on 13-11-18.
//  Copyright (c) 2013年 ZKF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLV : NSObject

@property (nonatomic, assign) NSInteger length;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *tag;

@end
