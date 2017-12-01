//
//  ViewController.m
//  PCAdvertisment
//
//  Created by Abe_liu on 2017/12/1.
//  Copyright © 2017年 Abe_liu. All rights reserved.
//

#import "ViewController.h"
#import "AdvertismentView.h"
#import "TestView.h"

@interface ViewController ()
@property(nonatomic,strong)AdvertismentView *adView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TestView *testView=[[TestView alloc]init];
    
    TestView *testView2=[TestView shareInstance];
    
    NSLog(@"%@---%@",testView,testView2);
    
    [self simuReload];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 100, 100);
    btn.center=self.view.center;
    btn.backgroundColor=[UIColor redColor];
    [btn addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)refreshView{
    [self simuReload];
}
-(void)simuReload{
        NSArray *array=@[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg"];
        _adView=[AdvertismentView adCollectionViewFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200) modelArray:array pageControlShowStyle:UIPageControlShowStyleRight];
    _adView.clickBlock = ^(NSInteger currentRow) {
        NSLog(@"aaaaa%ld",currentRow);
    };
        [self.view addSubview:_adView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
