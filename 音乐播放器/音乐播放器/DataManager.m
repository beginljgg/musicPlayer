//
//  DataManager.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "DataManager.h"
#import "MusicModel.h"

@interface DataManager()

//@property (nonatomic, strong) NSMutableArray *  musicArray;

@end


@implementation DataManager

+ (DataManager *)sharedManager{
    static DataManager * manager = nil;
//    gcd提供的一种单例方法
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [DataManager new];
//        请求数据
        [manager requestData];
    });
    
    return manager;
}

//- (instancetype)init{
//    self = [super init];
//    if (self) {
//        [self requestData];
//    }
//    return self;
//}





- (void)requestData{
//    在子线程请求数据，防止假死。
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        数据连接
        NSURL * url = [NSURL URLWithString:kMusicListURL];
        //一次把所有的数据解析完，实际应用中会造成费流量（请求数据）
        NSArray * dataArray = [NSArray arrayWithContentsOfURL:url];
//        开始解析
        for (int i = 0; i < dataArray.count; i ++) {
//            NSLog(@"%@",dataArray[i]);
//        构建一个model
            MusicModel * model = [MusicModel new];
            [model setValuesForKeysWithDictionary:dataArray[i]];
            [self.musicArray addObject:model];
        }
//        返回主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!self.myUpdataUI) {
//                NSLog(@"block 没有代码");
            }else{
//          block的刷新方法
//                [self.tableView reloadData];
                self.myUpdataUI();
            }
        });
    });
}

#pragma mark - lazy load
// get方法   懒加载
- (NSMutableArray *)musicArray{
//    用self.musicArray 会造成无限重复调用
    if (!_musicArray) {
        _musicArray = [NSMutableArray array];
    }
    return _musicArray;
}

//- (NSArray *)allmusic{
//    return self.musicArray;
//}

- (MusicModel *)musicModelWithIndex:(NSInteger)index{
    return self.musicArray[index];
}









@end
