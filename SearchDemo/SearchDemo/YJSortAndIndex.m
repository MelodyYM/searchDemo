//
//  YJSortAndIndex.m
//  拼音扩展
//
//  Created by  jason on 15/12/21.
//  Copyright © 2015年 renlairenwang. All rights reserved.
//

#import "YJSortAndIndex.h"
#import "NSString+PinYin.h"

#define GB18030_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
@implementation YJSortAndIndex



/**
 *  把联系人按首字母进行排序
 *
 *  @param array 需要排序的数组
 *
 *  @return 返回按各个字母排序好数组（数组中包含数组）
 */
+ (NSMutableArray*)sortArrayByFirstLetterWithArray:(NSMutableArray*)array {
    
    NSMutableArray *sortSectionArray = [NSMutableArray array];
    
    NSString *tempString;
    
    NSMutableArray *itme;
    
    // 首先对其进行排序
    NSMutableArray *sortArray = [[array sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        
        NSString *str1 = [obj1 ChineseStringTransformToPinYin];
        
        NSString *str2 = [obj2 ChineseStringTransformToPinYin];
        
        return [str1 compare:str2];

    
    }] mutableCopy];
    

    // 对其排序
    for (int i = 0; i<sortArray.count; i++) {
        
        NSString *str = sortArray[i];
        
        NSLog(@"%@",str);
        
        NSString*firstString;
        
                if (str.length>0&&![str isContainChinese]) {
        
                    firstString = [[str substringToIndex:1] uppercaseString];
                }
                else if(str.length>0&&[str isContainChinese]){
        
        
                    firstString = [str fisrtUppercasePinYin];
        
                }
                NSLog(@"%@",firstString);
        
                // 不同
                if (![tempString isEqualToString:firstString]) {
        
                    //分组
                    itme = [NSMutableArray array];
                    [itme addObject:str];
                    tempString = firstString;
                    [sortSectionArray addObject:itme];
                }
                else {
                
                    [itme addObject:str];
                }
    }
    
    
    
    return sortSectionArray;
}


// 通过分组数组来获取索引
+ (NSMutableArray*)getSectionIndexsArrayWithSortSecionsArray:(NSMutableArray*)sortSecionsArray {
    
    
    NSMutableArray *indexsArray = [NSMutableArray array];
    
    for (NSArray *arr in sortSecionsArray) {
        
        NSString *str = [arr firstObject];
        
        NSString *firstLetter = @"";
        
        if (str.length>0&&![str isContainChinese]) {
            
            firstLetter = [[str substringToIndex:1] uppercaseString];
            
        }
        else if (str.length>0&&[str isContainChinese]) {
            
            
            firstLetter = [str fisrtUppercasePinYin];
            
        }
        
        [indexsArray addObject:firstLetter];
        
        
    }
    
    return indexsArray;
}

@end
