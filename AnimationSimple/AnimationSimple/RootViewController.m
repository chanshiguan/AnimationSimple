//
//  RootViewController.m
//  AnimationSimple
//
//  Created by Owen.li on 2017/1/18.
//  Copyright © 2017年 Owen.li. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
{
    NSDictionary *_dataList;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AnimationSimple";
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"AnimationType" ofType:@"plist"];
    _dataList = [NSDictionary dictionaryWithContentsOfFile:urlStr];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.allKeys.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_identifier" forIndexPath:indexPath];
    cell.textLabel.text = [[_dataList allKeys] objectAtIndex:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *classStr = [_dataList objectForKey:cell.textLabel.text];
    UIViewController *vc = [[NSClassFromString(classStr) alloc] init];
    vc.title = cell.textLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
