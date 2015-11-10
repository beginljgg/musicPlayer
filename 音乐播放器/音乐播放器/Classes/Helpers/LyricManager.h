//
//  LyricManager.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricManager : NSObject
// 对外的歌词的数组
@property (nonatomic, strong) NSArray * allLyric;

+ (instancetype)sharedManager;

- (void)loadLyricWith:(NSString *)lyricStr;

/**
 *  根据播放时间，获取到该播放器的歌词的索引
 *
 *  @param time <#time description#>
 *
 *  @return <#return value description#>
 */


- (NSInteger)indexWith:(NSTimeInterval)time;

@end
