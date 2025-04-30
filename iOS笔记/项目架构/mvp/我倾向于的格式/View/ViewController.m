//
//  ViewController.m
//  QCMVP
//
//  Created by EricZhang on 2018/5/31.
//  Copyright © 2018年 BYX. All rights reserved.
//

#import "ViewController.h"
#import "QCViewProtocal.h"
#import "QCPresenter.h"

//协议实现
@interface ViewController ()<QCTestProtocal,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSArray *bindArr;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) QCPresenter *presenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor =  [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    //建立联系
    self.presenter = [QCPresenter new];
    [self.presenter attatchView:self];
    [self.presenter exchangeData];
    

}


//MARK: tableview DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bindArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = [self.bindArr[indexPath.row] valueForKey:@"title"];
    cell.backgroundColor = [UIColor greenColor];
    cell.textLabel.textColor =[UIColor grayColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
    
    
}


//MARK: tableview Delagete
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}


//MARK: QCTestProcotal delagete
-(void)changeBgColor{
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
}
-(void)bindDataSurce:(NSArray *)data{
    
    self.bindArr = data;
    [self.tableView reloadData];
    
}



//MARK: tableview 懒加载
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [UITableView new];
        //初始化背景颜色为白色
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _tableView.separatorStyle = NO;
        
    }
    return _tableView;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
