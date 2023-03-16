#import <Flutter/Flutter.h>

@interface ImagePickersPlugin : NSObject<FlutterPlugin,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    FlutterResult resultBack;
}
@end
