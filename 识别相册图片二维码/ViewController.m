//
//  ViewController.m
//  识别相册图片二维码
//
//  Created by 周天雨 on 16/3/30.
//  Copyright © 2016年 周天雨. All rights reserved.
//

#import "ViewController.h"
#import <ZXingObjC/ZXingObjC.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableSet *qrReader;
    BOOL scanningQR;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self install];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)install{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 100, 100, 40)];
    [leftBtn setTitle:@"从相册选择" forState:UIControlStateNormal];
     [leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    leftBtn.backgroundColor  = [UIColor redColor];
    [leftBtn addTarget:self action:@selector(pressButton3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
}
- (void)pressButton3:(UIButton *)button
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{
        [self getURLWithImage:image];
    }
     ];
    
}

-(void)getURLWithImage:(UIImage *)img{
    
    UIImage *loadImage= img;
    CGImageRef imageToDecode = loadImage.CGImage;
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        NSString *contents = result.text;
        NSLog(@"contents =%@",contents);
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"解析成功" message:contents delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alter show];
        
    } else {
        UIAlertView *alter1 = [[UIAlertView alloc] initWithTitle:@"解析失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alter1 show];
    }
}
@end
