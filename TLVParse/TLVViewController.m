//
//  TLVViewController.m
//  TLVParse
//
//  Created by ZKF on 13-12-2.
//  Copyright (c) 2013年 朱克锋. All rights reserved.
//

#import "TLVViewController.h"
#import "TLVParseUtils.h"
@interface TLVViewController ()

@end

@implementation TLVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    TLVParseUtils*s = [[[TLVParseUtils alloc] init] autorelease];
    NSArray *tlvArr =  [s saxUnionField55_2List:@"9F260879CC8EC5A09FB9479F2701809F100807010199A0B806019F3704000000009F360201C2950500001800009A031205089C01609F02060000000000005F2A02015682027D009F1A0201569F03060000000000009F3303E0F0F09F34036003029F3501119F1E0832303033313233318405FFFFFFFFFF9F090220069F4104000000019F74064543433030319F631030313032303030308030303030303030"];
    
    NSLog(@"tlv arr :%@",tlvArr);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
