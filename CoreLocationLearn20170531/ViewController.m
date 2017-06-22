//
//  ViewController.m
//  CoreLocationLearn20170531
//
//  Created by 寰宇 on 2017/5/31.
//  Copyright © 2017年 devhy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *arrayTitle;
@property (nonatomic, strong) NSArray *arrayName;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.title = @"Demo";
    [self.view addSubview:self.tableView];
}

- (void)initData {
    self.arrayTitle = @[@"BaseDemo", @"RegionDemo", @"HeadingDemo", @"GeocoderDemo"];
    self.arrayName  = @[@"LocationBaseDemoViewController",
                        @"RegionDemoViewController",
                        @"HeadingDemoViewController",
                        @"GeocodeDemoViewController"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"demoListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = self.arrayTitle[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class className = NSClassFromString(self.arrayName[indexPath.row]);
    UIViewController *vc = [className new];
    vc.title = self.arrayTitle[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

@end
