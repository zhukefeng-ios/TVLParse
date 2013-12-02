//
//  SAXUnionFiled55Utils.m
//  CashBox
//
//  Created by ZKF on 13-11-18.
//  Copyright (c) 2013年 ZKF. All rights reserved.
//

#import "TLVParseUtils.h"

@implementation TLVParseUtils

/**
 * 银联55域
 *
 * 本域将根据不同的交易种类包含不同的子域。银联处理中心仅在受理方和发卡方之间传递这些适用于IC卡交易的特有数据，而不对它们进行任何修改和处理。
 * 为适应该子域需要不断变化的情况
 * ，本域采用TLV（tag-length-value）的表示方式，即每个子域由tag标签(T)，子域取值的长度(L)和子域取值(V)构成。
 * tag标签的属性为bit
 * ，由16进制表示，占1～2个字节长度。例如，"9F33"为一个占用两个字节的tag标签。而"95"为一个占用一个字节的tag标签
 * 。若tag标签的第一个字节
 * （注：字节排序方向为从左往右数，第一个字节即为最左边的字节。bit排序规则同理。）的后五个bit为"11111"，则说明该tag占两个字节
 * ，例如"9F33"；否则占一个字节，例如"95"。 子域长度（即L本身）的属性也为bit，占1～3个字节长度。具体编码规则如下： a)
 * 当L字段最左边字节的最左bit位（即bit8）为0，表示该L字段占一个字节，它的后续7个bit位（即bit7～bit1）表示子域取值的长度，
 * 采用二进制数表示子域取值长度的十进制数
 * 。例如，某个域取值占3个字节，那么其子域取值长度表示为"00000011"。所以，若子域取值的长度在1～127
 * 字节之间，那么该L字段本身仅占一个字节。 b)
 * 当L字段最左边字节的最左bit位（即bit8）为1，表示该L字段不止占一个字节，那么它到底占几个字节由该最左字节的后续7个bit位
 * （即bit7～bit1）的十进制取值表示。例如，若最左字节为10000010，表示L字段除该字节外，后面还有两个字节。其后续字节
 * 的十进制取值表示子域取值的长度。例如，若L字段为"1000 0001 1111 1111"，表示该子域取值占255个字节。
 * 所以，若子域取值的长度在128～255字节之间，那么该L字段本身需占两个字节
 *
 * @return tlv NSArray
 */
-(NSArray*) saxUnionField55_2List:(NSString*) hexfiled55
{
    
    if (nil == hexfiled55) {
        
    }
    return [[[self builderTLV:hexfiled55] retain] autorelease];
}

-(NSArray*) builderTLV:(NSString *)hexString
{
    NSMutableArray *arr = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    int position = 0;
    while (position != hexString.length) {
        NSString * _hexTag = [self getUnionTag:hexString P:position];
        NSLog(@"hex tag :%@",_hexTag);
        if ([_hexTag isEqualToString:@"00"] || [_hexTag isEqualToString:@"0000"]) {
            position += _hexTag.length;
            continue;
        }
        position += _hexTag.length;
        LPositon *l_position = [[[self getUnionLAndPosition:hexString P:position] retain] autorelease];;
        int _vl = l_position.vl;
        NSLog(@"value len :%i",_vl);
        position = l_position.position;
        
        NSString* _value = [hexString substringWithRange:NSMakeRange(position, _vl * 2)];
        NSLog(@"value :%@",_value);
      
        position = position + _value.length;
        TLV *tlv = [[[TLV alloc] init] autorelease];
        tlv.tag = _hexTag;
        tlv.value = _value;
        tlv.length = _vl;
        [arr addObject:tlv];
    }
    return arr;
}

int ChangeNum(char * str,int length)
{
    char  revstr[128] = {0};  //根据十六进制字符串的长度，这里注意数组不要越界
    int   num[16] = {0};
    int   count = 1;
    int   result = 0;
    strcpy(revstr,str);
    for (int i = length - 1;i >= 0;i--)
    {
        if ((revstr[i] >= '0') && (revstr[i] <= '9')) {
            num[i] = revstr[i] - 48;//字符0的ASCII值为48
        } else if ((revstr[i] >= 'a') && (revstr[i] <= 'f')) {
            num[i] = revstr[i] - 'a' + 10;
        } else if ((revstr[i] >= 'A') && (revstr[i] <= 'F')) {
            num[i] = revstr[i] - 'A' + 10;
        } else {
            num[i] = 0;
        }
        result = result+num[i]*count;
        count = count*16;//十六进制(如果是八进制就在这里乘以8)
    }
    return result;
}

-(LPositon *)getUnionLAndPosition:(NSString *)hexString P:(NSInteger) position
{
    NSString *firstByteString = [hexString substringWithRange:NSMakeRange(position, 2)];
    int i = ChangeNum((char *)[firstByteString UTF8String],2);
    
    NSString * hexLength = @"";
    if (((i >> 7) & 1) == 0) {
        hexLength = [hexString substringWithRange:NSMakeRange(position, 2)];
        position = position + 2;
        
    } else {
        // 当最左侧的bit位为1的时候，取得后7bit的值，
        int _L_Len = i & 127;
        position = position + 2;
        hexLength = [hexString substringWithRange:NSMakeRange(position, _L_Len * 2)];
        // position表示第一个字节，后面的表示有多少个字节来表示后面的Value值
        position = position + _L_Len * 2;
        
    }
    LPositon *LP = [[[LPositon alloc] init] autorelease];
    LP.vl = ChangeNum((char *)[hexLength UTF8String],2);
    LP.position = position;
    return LP;
}

-(NSString*) getUnionTag:(NSString* )hexString P:(NSInteger) position
{
    NSString* firstByte = [hexString substringWithRange:NSMakeRange(position, 2)];
    int i = ChangeNum((char *)[firstByte UTF8String],2);
    if ((i & 0x1f) == 0x1f) {
        return [hexString substringWithRange:NSMakeRange(position, 4)];
    } else {
        return [hexString substringWithRange:NSMakeRange(position, 2)];
    }
}
@end
