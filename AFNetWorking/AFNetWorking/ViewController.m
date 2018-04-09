//
//  ViewController.m
//  AFNetWorking
//
//  Created by 李世飞 on 2018/4/8.
//  Copyright © 2018年 李世飞. All rights reserved.
//

#import "ViewController.h"
#import "Api.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"AFNetWorking";
    
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(10, 100,200 , 30);
    [btn setTitle:@"获取商品信息" forState:normal];
    [btn setTitleColor:[UIColor blueColor] forState:normal];
    [btn addTarget:self action:@selector(Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)Action{
    
    Api * api =[[Api alloc] init:self tag:@"getGoodInfo"];
    [api getGoodInfo:@"374475284"];
    
    Api * api1 =[[Api alloc] init:self tag:@"ModfiyUsername"];
    [api1 ModfiyUsername:@"lsf"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 接口请求出错 sucess=0
-(void)Failed:(NSString*)message tag:(NSString*)tag
{
    
    NSLog(@"tag:%@  message=%@",tag,message);
    
}
#pragma mark 接口请求成功 sucess=1
-(void)Sucess:(id)response tag:(NSString*)tag
{
    if([tag isEqualToString:@"getGoodInfo"]){
        
        
    }
    else if ([tag isEqualToString:@"ModfiyUsername"]){
        
        
    }
}
@end
