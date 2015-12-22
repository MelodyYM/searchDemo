//
//  YJSortAndIndex.h
//  拼音扩展
//
//  Created by  jason on 15/12/21.
//  Copyright © 2015年 renlairenwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJSortAndIndex : NSObject
/**
 *  把联系人按首字母进行排序
 *
 *  @param array 需要排序的数组
 *
 *  @return 返回按各个字母排序好数组（数组中包含数组）
 */
+ (NSMutableArray*)sortArrayByFirstLetterWithArray:(NSMutableArray*)array;


/**
 *  拖过排序好的数组获取索引
 *
 *  @param sortSecionsArray 字母排序好的数组
 *
 *  @return 索引数组
 */
+ (NSMutableArray*)getSectionIndexsArrayWithSortSecionsArray:(NSMutableArray*)sortSecionsArray;
@end
