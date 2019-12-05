//
//  AKGallery.m
//  AKGallery
//
//  Created by ak on 16/11/8.
//  Copyright © 2016年 ak. All rights reserved.
//

#import "AKGallery.h"
#import "AKGalleryList.h"
#import "AKGalleryViewer.h"

@implementation AKGalleryItem


+(instancetype)itemWithTitle:(NSString*)title url:(NSString* )url img:(UIImage*)img{
    AKGalleryItem* item =AKGalleryItem.new;
    item.title=title;
    item.img=img;
    item.url=url;
    return item;
}


@end


@interface AKGallery ()
@property(nonatomic,strong)AKGalleryList* listVC;
@property(nonatomic,strong)AKGalleryViewerContainer* viewVC;


@end

@implementation AKGallery 

-(instancetype)init{
    self  =  [super init];
    _custUI = AKGalleryCustUI.new;
    _listVC = AKGalleryList.new;
    _viewVC = AKGalleryViewerContainer.new;
    _selectIndex=-1;

    return self;
}

-(void)setSelectIndex:(NSInteger)selectIndex{

    if (selectIndex<0||selectIndex>=self.items.count) {
        _selectIndex=0;
    }else{
        _selectIndex=selectIndex;
        
        
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.selectIndex>=0) {

        self.viewControllers=@[self.listVC,self.viewVC];
    }
    else{
        self.viewControllers=@[self.listVC];
        
        _selectIndex=0;
    }
    
    self.navigationBar.tintColor=self.custUI.navigationTint;
    
    
//    //添加返回按钮
//    UIButton *  returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    returnBtn.frame = CGRectMake(0,[AKGallery isPhoneX]?40:20, 44, 44);
//    [returnBtn setTitle:@"<" forState:UIControlStateNormal];
//    [returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [returnBtn addTarget:self action:@selector(returnBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:returnBtn];
//
    
    
    
    

}
+ (BOOL)isPhoneX {
    BOOL iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return iPhoneX;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    return iPhoneX;
    
}
-(void)returnBtnAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    [self.navigationController popViewControllerAnimated:YES];
    
}

-(AKGalleryItem*)itemForRow:(NSInteger)row{
    if (row<0||row>=self.items.count) {
        return nil;
    }
    return  (AKGalleryItem*)self.items[row];
}

-(AKGalleryItem*)selectedItem{
    return [self itemForRow:self.selectIndex];
}

-(void)setItems:(NSArray *)items{
  
    if ([items.firstObject isKindOfClass:[NSString class]]) {
        NSMutableArray* tmp = @[].mutableCopy;
        [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                //string arr
                AKGalleryItem* item =[AKGalleryItem new];
                item.url=obj;
                [tmp addObject:item];
            }
            
        }];
        _items=tmp;
    }
    if ([items.firstObject isKindOfClass:[AKGalleryItem class]]) {
        _items=items;
    }
    
    
//   NSAssert(_items!=nil, @"setItems设置内容有错误");
}

@end

@implementation UIViewController(AKGallery)



-(void)presentAKGallery:(AKGallery *)gallery animated:(BOOL)flag completion:(void (^)(void))completion{
    
    //todo:defaults
    
    
    [self presentViewController:gallery animated:flag completion:completion];
    
    
    
}

@end

