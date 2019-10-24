#import "ImagePickersPlugin.h"
#import <image_pickers/image_pickers-Swift.h>

@implementation ImagePickersPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftImagePickersPlugin registerWithRegistrar:registrar];
}
@end
