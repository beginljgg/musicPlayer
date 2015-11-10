//
//  PlayingViewController.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "PlayingViewController.h"
#import "PlayerManager.h"
#import "DataManager.h"
#import "MusicModel.h"
#import "LyricManager.h"
#import "LyricModel.h"

@interface PlayingViewController ()<playerManagerDelegate,UITableViewDataSource>
//记录一下当前播放音乐的索引
@property (nonatomic, assign) NSInteger currentIndex;
//记录当前正在播放的音乐
@property (nonatomic, strong) MusicModel * currentModel;

#pragma mark - 控件

@property (strong, nonatomic) IBOutlet UIImageView *img4pic;

@property (strong, nonatomic) IBOutlet UILabel *lab4PlayedTime;

@property (strong, nonatomic) IBOutlet UILabel *lab4LastTime;

@property (strong, nonatomic) IBOutlet UISlider *slider4Time;

@property (strong, nonatomic) IBOutlet UISlider *slider4Volume;

@property (strong, nonatomic) IBOutlet UILabel *lab4SongName;

@property (strong, nonatomic) IBOutlet UILabel *lab4SingerName;

@property (strong, nonatomic) IBOutlet UIButton *btn4PlayOrPause;

@property (strong, nonatomic) IBOutlet UITableView *tableView4lyric;

@property (strong, nonatomic) IBOutlet UIImageView *backImage;

#pragma mark - 控制事件

- (IBAction)action4PlayOrPause:(UIButton *)sender;

- (IBAction)action4Prev:(id)sender;

- (IBAction)action4Next:(UIButton *)sender;

- (IBAction)action4ChangeTime:(UISlider *)sender;

- (IBAction)cation4ChangeVolume:(UISlider *)sender;

@end

static NSString * cellIdentifier = @"cellResue";

@implementation PlayingViewController

+ (instancetype)sharedPlayingPVC{
    static PlayingViewController * playingVC = nil;
    
    static dispatch_once_t oncrToken;
    dispatch_once(&oncrToken, ^{
//     拿到main 的 sb
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//     在main sb 拿到我们要用的视图控制器
       playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
        
    });
    return playingVC;
}
// 调用 视图将出现时的方法
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//   如果要播放的音乐和当前的音乐一样，就return
    if (_index == _currentIndex) {
        return;
    }
//    如果不等于，把当前的音乐改成要播放的音乐。从新播放
    _currentIndex = _index;
//    开始播放
    [self startPlay];
    
}


- (IBAction)action4Back:(UIButton *)sender {
//    返回
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
// 开始播放
- (void)startPlay{
//    取到要播放的model
//    MusicModel * model = [[DataManager sharedManager] musicModelWithIndex:self.currentIndex];
    
//    self.currentModel.mp3Url != _currentModel.mp3Url; 用_currentModel 没有音乐。
    [[PlayerManager sharedManager] playWithUrlString:self.currentModel.mp3Url];
    
    [self buildUI];
}
// 构建UI
//用self.currentModel走get方法，用_currentModel不走，取不到值。
- (void)buildUI{
    
    self.lab4SingerName.text = self.currentModel.singer;
    self.lab4SongName.text = self.currentModel.name;
    [self.img4pic sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl]];
#pragma mark - tableView背景
    
//    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.currentModel.picUrl]];
//   
//    imgView.frame = CGRectMake(0, 0, 100, 100);
//    self.tableView4lyric.backgroundView = imgView;
    
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:self.currentModel.blurPicUrl]];
    
//    更改Button
    [self.btn4PlayOrPause setTitle:@"暂停" forState:(UIControlStateNormal)];
    
    self.slider4Time.maximumValue = [self.currentModel.duration integerValue]/1000;

//    更改旋转的角度(图片归位)
    self.img4pic.transform = CGAffineTransformMakeRotation(0);
//    解析歌词
    [[LyricManager sharedManager]loadLyricWith:self.currentModel.lyric];
//    
    [self.tableView4lyric reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    给一个初始位。
    _currentIndex = -1;
//    _img4pic.layer.position = CGPointMake(_img4pic.center.x, _img4pic.center.y);
    
    _img4pic.layer.masksToBounds = YES;
    _img4pic.layer.cornerRadius = 120;
    
//    第一个参数，是跳动间隔的时间，设置的够小，就变成平滑的旋转了。
//    [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(runChange) userInfo:nil repeats:YES];
//     设置自己为播放器的代理，帮播放器干一些事情（这个指播放下一曲）；
    [PlayerManager sharedManager].delegate = self;
//    注册
    [self.tableView4lyric registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    

    
     
    
    self.slider4Volume.value = [[PlayerManager sharedManager] volume];
    
    
}

//- (void)runChange{
//    _img4pic.layer.transform = CATransform3DRotate(_img4pic.layer.transform, M_PI/600, 0, 0, 1);
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// 暂停或者播放事件
- (IBAction)action4PlayOrPause:(UIButton *)sender {
    if ([PlayerManager sharedManager].isPlaying) {
//     如果正在播放，就让播放器暂停，同时改变button 的 text为 播放；
        [[PlayerManager sharedManager] pause];
        [sender setTitle:@"播放" forState:(UIControlStateNormal)];
        
    }else{
//        如果是暂停，就让播放器播放，同时改变Button 的 text为 暂停
        [[PlayerManager sharedManager] play];
        
        [sender setTitle:@"暂停" forState:(UIControlStateNormal)];
    }

    
    
}

// 上一首
- (IBAction)action4Prev:(id)sender {
    _currentIndex --;
//    判断是否是第一首
    if (_currentIndex == -1) {
//        如果是就播放最后一首
        _currentIndex = [DataManager sharedManager].musicArray.count-1;
    }
    [self startPlay];
    
    
    
}

// 下一首
- (IBAction)action4Next:(UIButton *)sender {
    
    _currentIndex ++;
//    判断是不是最后一首
    if (_currentIndex == [DataManager sharedManager].musicArray.count) {
//        如果是最后一首播放第一首
        _currentIndex = 0;
    }
    [self startPlay];
}
// 改变播放的进度
- (IBAction)action4ChangeTime:(UISlider *)sender {
    
    UISlider * slider = sender;
//   调用接口
    [[PlayerManager sharedManager] seekToTime:slider.value];
}

- (IBAction)cation4ChangeVolume:(UISlider *)sender {
    
    [[PlayerManager sharedManager] changeToVolume:sender.value];
    
}

#pragma mark - getter
// 重写get方法 （确保当前播放的音乐是最新的）
- (MusicModel *)currentModel{
//     取到要播放的model
   MusicModel * model = [[DataManager sharedManager] musicModelWithIndex:self.currentIndex];
    
    return model;
}

#pragma mark - UItableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [LyricManager sharedManager].allLyric.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//    取到对应的cell
    LyricModel * lyric = [LyricManager sharedManager].allLyric[indexPath.row];
//    设置歌词
    cell.textLabel.text = lyric.lyricContext;
//    设置cell。textlabel文本居中。
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
//    设置文本内容是 高亮的
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
//    设置选中的view 的背景
    cell.selectedBackgroundView = view;
    
    return cell;
}






#pragma mark - playerManagerDelegate
//播放结束了，开始 播放下一首
- (void)playerDidPlayEnd{
//    调用下一首的button
    [self action4Next:nil];
    
}
// 播放器每0。1秒会让代理（也就是这个页面）执行一下这个事件
- (void)playerPlayingWithTime:(NSTimeInterval)time{
    
    self.slider4Time.value = time;
    
    self.lab4PlayedTime.text = [self stringWithTime:time];
    
//    剩余时间
    NSTimeInterval time2 = [self.currentModel.duration integerValue]/1000- time;
    self.lab4LastTime.text = [self stringWithTime:time2];
    
    //    每0.1秒旋转1度。
    self.img4pic.transform = CGAffineTransformRotate(self.img4pic.transform, M_PI/180);
    
//    根据当前播放时间，获取到应该播放那句歌词。
    
    NSInteger index = [[LyricManager sharedManager] indexWith:time];
    
    NSIndexPath * path = [NSIndexPath indexPathForRow:index inSection:0];
//   让tableView选中我呢吧要找的单词
    [self.tableView4lyric selectRowAtIndexPath:path animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
    
}


//  根据事件获取到字符串
- (NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger minutes = time/60;
    NSInteger seconde = (int)time%60;
    return [NSString stringWithFormat:@"%ld:%ld",minutes,seconde];

    
}


@end
