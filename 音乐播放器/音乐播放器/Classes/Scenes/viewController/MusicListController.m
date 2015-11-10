//
//  MusicListController.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "MusicListController.h"
#import "MusicCell.h"
#import "DataManager.h"
#import "MusicModel.h"
#import "PlayerManager.h"
#import "PlayingViewController.h"

@interface MusicListController ()

@end

static NSString * identifier = @"musicCell";

static NSString * customCell = @"customCell";

@implementation MusicListController
//代码规范，每一个模块之间要空一行
- (void)viewDidLoad {
    [super viewDidLoad];
//   注册自定义cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicCell" bundle:nil] forCellReuseIdentifier:customCell];
//    把tableView 刷新的值传给 myUpdataUI 然后返回Datamanager
    [DataManager sharedManager].myUpdataUI = ^(){
        [self.tableView reloadData];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [DataManager sharedManager].musicArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    找到复用池中自定义的cell
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:customCell forIndexPath:indexPath];
//   设置cell的点击效果
    cell.selectionStyle = UITableViewCellEditingStyleNone;
//    MusicModel * musicModel = [MusicModel new];
    cell.musicModel = [DataManager sharedManager].musicArray[indexPath.row];
    
//   self.model = 是get方法   _model 不走set方法
    return cell;
}

//点击实现
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    掉用cell方法 要先生成一个cell
//    MusicCell * cell = [tableView cellForRowAtIndexPath:indexPath];
////   传mp3Url的传值并播放
//    [[PlayerManager sharedManager] playWithUrlString:cell.musicModel.mp3Url];
    
//    拿到要模态出来的控制器
    PlayingViewController * playingVC = [PlayingViewController sharedPlayingPVC];
    
    playingVC.index = indexPath.row;
    
//    模态 (进入playingVC视图控制器)
    [self showDetailViewController:playingVC sender:nil];
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
